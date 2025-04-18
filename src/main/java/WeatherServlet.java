import java.io.*;
import java.net.*;
import java.text.SimpleDateFormat;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.xml.parsers.*;
import org.w3c.dom.*;

public class WeatherServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String API_KEY = "bb90614a53f32a0e48f44f5836e0928c"; // Your API key

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String city = request.getParameter("city");
        if (city == null || city.trim().isEmpty()) {
            request.setAttribute("error", "Please enter a city name");
            RequestDispatcher rd = request.getRequestDispatcher("index.jsp");
            rd.forward(request, response);
            return;
        }

        try {
            // Get current weather data (using XML format)
            getCurrentWeather(city, request);
            
            // Get forecast data (using XML format)
            getForecastData(city, request);
            
            RequestDispatcher rd = request.getRequestDispatcher("index.jsp");
            rd.forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error fetching weather data: " + e.getMessage());
            RequestDispatcher rd = request.getRequestDispatcher("index.jsp");
            rd.forward(request, response);
        }
    }

    private void getCurrentWeather(String city, HttpServletRequest request) 
            throws Exception {
        
        // Encode city name for URL safety
        String encodedCity = URLEncoder.encode(city, "UTF-8");
        // Explicitly request temperature in metric units
        String urlString = "http://api.openweathermap.org/data/2.5/weather?q=" + 
                encodedCity + "&mode=xml&units=metric&appid=" + API_KEY;

        // Create URL using URI to avoid deprecated constructor
        URI uri = new URI(urlString);
        URL url = uri.toURL();

        // Create connection
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        // Check HTTP response
        if (conn.getResponseCode() != 200) {
            request.setAttribute("error", "City not found or API error. HTTP Status: " + 
                                 conn.getResponseCode());
            return;
        }

        // Parse XML
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        Document doc = builder.parse(conn.getInputStream());

        // Default values in case any data is missing
        String temperature = "N/A";
        String humidity = "N/A";
        String weather = "N/A";
        String windSpeed = "N/A";
        String pressure = "N/A";
        
        // Extract temperature data with null checks
        NodeList tempNodeList = doc.getElementsByTagName("temperature");
        if (tempNodeList != null && tempNodeList.getLength() > 0) {
            Node tempNode = tempNodeList.item(0);
            if (tempNode != null && tempNode.getAttributes() != null) {
                Node valueAttr = tempNode.getAttributes().getNamedItem("value");
                if (valueAttr != null) {
                    String temperatureValue = valueAttr.getNodeValue();
                    try {
                    	float tempFloat = Float.parseFloat(temperatureValue);
                    	// Process temperature based on reasonable ranges
                    	if (tempFloat > 273 && tempFloat < 373) {
                    	    // This is likely a Kelvin value
                    	    tempFloat = kelvinToCelsius(tempFloat);
                    	}
                    	temperature = String.format("%.1f", tempFloat);
                    } catch (NumberFormatException e) {
                        temperature = temperatureValue; // Use as-is if can't parse
                    }
                }
            }
        }
        
        // Extract humidity data with null checks
        NodeList humidityNodeList = doc.getElementsByTagName("humidity");
        if (humidityNodeList != null && humidityNodeList.getLength() > 0) {
            Node humidityNode = humidityNodeList.item(0);
            if (humidityNode != null && humidityNode.getAttributes() != null) {
                Node valueAttr = humidityNode.getAttributes().getNamedItem("value");
                if (valueAttr != null) {
                    humidity = valueAttr.getNodeValue();
                }
            }
        }
        
        // Extract weather description with null checks
        NodeList weatherNodeList = doc.getElementsByTagName("weather");
        if (weatherNodeList != null && weatherNodeList.getLength() > 0) {
            Node weatherNode = weatherNodeList.item(0);
            if (weatherNode != null && weatherNode.getAttributes() != null) {
                Node valueAttr = weatherNode.getAttributes().getNamedItem("value");
                if (valueAttr != null) {
                    weather = valueAttr.getNodeValue();
                }
            }
        }
        
        // Extract wind speed with null checks
        NodeList windNodeList = doc.getElementsByTagName("wind");
        if (windNodeList != null && windNodeList.getLength() > 0) {
            Node windNode = windNodeList.item(0);
            if (windNode != null && windNode.getChildNodes() != null && windNode.getChildNodes().getLength() > 1) {
                Node speedNode = windNode.getChildNodes().item(1); // speed is usually the second child
                if (speedNode != null && speedNode.getAttributes() != null) {
                    Node valueAttr = speedNode.getAttributes().getNamedItem("value");
                    if (valueAttr != null) {
                        windSpeed = valueAttr.getNodeValue();
                    }
                }
            }
        }
        
        // Extract pressure with null checks
        NodeList pressureNodeList = doc.getElementsByTagName("pressure");
        if (pressureNodeList != null && pressureNodeList.getLength() > 0) {
            Node pressureNode = pressureNodeList.item(0);
            if (pressureNode != null && pressureNode.getAttributes() != null) {
                Node valueAttr = pressureNode.getAttributes().getNamedItem("value");
                if (valueAttr != null) {
                    pressure = valueAttr.getNodeValue();
                }
            }
        }

        // Set attributes for JSP
        request.setAttribute("city", city);
        request.setAttribute("temperature", temperature);
        request.setAttribute("humidity", humidity);
        request.setAttribute("weather", weather);
        request.setAttribute("windSpeed", windSpeed);
        request.setAttribute("pressure", pressure);
    }

    private void getForecastData(String city, HttpServletRequest request) 
            throws Exception {
        
        // Encode city name for URL safety
        String encodedCity = URLEncoder.encode(city, "UTF-8");
        String forecastUrlString = "http://api.openweathermap.org/data/2.5/forecast?q=" + 
                                  encodedCity + "&mode=xml&units=metric&appid=" + API_KEY;
        
        // Create URL and connection
        URI uri = new URI(forecastUrlString);
        URL url = uri.toURL();
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        // Check response
        if (conn.getResponseCode() != 200) {
            request.setAttribute("error", "Forecast data not available. HTTP Status: " + 
                                 conn.getResponseCode());
            return;
        }
        
        // Parse XML
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        Document doc = builder.parse(conn.getInputStream());
        
        // Process forecast data
        NodeList timeNodes = doc.getElementsByTagName("time");
        Map<String, List<Map<String, String>>> dailyForecasts = new HashMap<>();
        SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
        SimpleDateFormat outputFormat = new SimpleDateFormat("EEEE"); // Full day name
        
        // Process all forecast entries
        for (int i = 0; i < timeNodes.getLength(); i++) {
            Node timeNode = timeNodes.item(i);
            if (timeNode == null || timeNode.getAttributes() == null) continue;
            
            Node fromAttr = timeNode.getAttributes().getNamedItem("from");
            if (fromAttr == null) continue;
            
            String fromTime = fromAttr.getNodeValue();
            if (fromTime == null || fromTime.isEmpty()) continue;
            
            try {
                // Parse date and get day name
                Date date = inputFormat.parse(fromTime);
                String dayKey = outputFormat.format(date); // Use directly as dayKey
                Calendar cal = Calendar.getInstance();
                cal.setTime(date);
                
                // Extract data for this forecast time
                NodeList temperatureNodes = ((Element)timeNode).getElementsByTagName("temperature");
                NodeList weatherNodes = ((Element)timeNode).getElementsByTagName("symbol");
                
                String tempValue = "N/A";
                String weatherDescription = "N/A";
                
                // Get temperature with null checks
                if (temperatureNodes != null && temperatureNodes.getLength() > 0) {
                    Node tempNode = temperatureNodes.item(0);
                    if (tempNode != null && tempNode.getAttributes() != null) {
                        Node valueAttr = tempNode.getAttributes().getNamedItem("value");
                        if (valueAttr != null) {
                            tempValue = valueAttr.getNodeValue();
                            
                            // Process temperature value
                            try {
                                float tempFloat = Float.parseFloat(tempValue);
                                // Process temperature based on reasonable ranges
                                if (tempFloat > 273 && tempFloat < 373) {
                                    // This is likely a Kelvin value
                                    tempFloat = kelvinToCelsius(tempFloat);
                                }
                                tempValue = String.format("%.1f", tempFloat);
                            } catch (NumberFormatException e) {
                                // Use original value if parsing fails
                            }
                        }
                    }
                }
                
                // Get weather description with null checks
                if (weatherNodes != null && weatherNodes.getLength() > 0) {
                    Node weatherNode = weatherNodes.item(0);
                    if (weatherNode != null && weatherNode.getAttributes() != null) {
                        Node nameAttr = weatherNode.getAttributes().getNamedItem("name");
                        if (nameAttr != null) {
                            weatherDescription = nameAttr.getNodeValue();
                        }
                    }
                }
                
                // Create forecast entry
                Map<String, String> forecastEntry = new HashMap<>();
                forecastEntry.put("temp", tempValue);
                forecastEntry.put("description", weatherDescription);
                forecastEntry.put("hour", String.valueOf(cal.get(Calendar.HOUR_OF_DAY)));
                
                // Add to daily forecasts
                dailyForecasts.computeIfAbsent(dayKey, k -> new ArrayList<>()).add(forecastEntry);
            } catch (Exception e) {
                // Skip this entry if there's an error
                continue;
            }
        }
        
        // Aggregate daily data to find min/max temperatures
        List<Map<String, String>> forecast = new ArrayList<>();
        
        for (Map.Entry<String, List<Map<String, String>>> entry : dailyForecasts.entrySet()) {
            String dayKey = entry.getKey();
            List<Map<String, String>> dayEntries = entry.getValue();
            
            // Find min and max temperatures
            float minTemp = Float.MAX_VALUE;
            float maxTemp = Float.MIN_VALUE;
            String description = "N/A";
            
            // Look for the entry closest to noon for the weather description
            int closestToNoon = Integer.MAX_VALUE;
            boolean validTempFound = false;
            
            for (Map<String, String> dayEntry : dayEntries) {
                try {
                    if (!"N/A".equals(dayEntry.get("temp"))) {
                        float temp = Float.parseFloat(dayEntry.get("temp"));
                        minTemp = Math.min(minTemp, temp);
                        maxTemp = Math.max(maxTemp, temp);
                        validTempFound = true;
                    }
                    
                    int hour = Integer.parseInt(dayEntry.get("hour"));
                    int hourDiff = Math.abs(hour - 12);
                    if (hourDiff < closestToNoon) {
                        closestToNoon = hourDiff;
                        description = dayEntry.get("description");
                    }
                } catch (NumberFormatException e) {
                    // Skip this entry
                }
            }
            
            // Only add forecast if we have valid temperature data
            if (validTempFound) {
                // Create day forecast with properly formatted temperatures
                Map<String, String> dayForecast = new HashMap<>();
                
                try {
                    Calendar cal = Calendar.getInstance();
                    cal.setTime(outputFormat.parse(dayKey)); // Parse day name back to date for today check
                    dayForecast.put("dayName", today(cal) ? "Today" : dayKey);
                } catch (Exception e) {
                    dayForecast.put("dayName", dayKey);
                }
                
                dayForecast.put("tempMax", String.format("%.1f", maxTemp));
                dayForecast.put("tempMin", String.format("%.1f", minTemp));
                dayForecast.put("description", description);
                
                forecast.add(dayForecast);
            }
        }
        
        // Sort forecasts by date
        if (!forecast.isEmpty()) {
            Collections.sort(forecast, (f1, f2) -> {
                if (f1.get("dayName").equals("Today")) return -1;
                if (f2.get("dayName").equals("Today")) return 1;
                return getDayOfWeekValue(f1.get("dayName")) - getDayOfWeekValue(f2.get("dayName"));
            });
            
            // Limit to 7 days
            if (forecast.size() > 7) {
                forecast = forecast.subList(0, 7);
            }
        }
        
        request.setAttribute("forecast", forecast);
    }
    
    // Convert Kelvin to Celsius
    private float kelvinToCelsius(float kelvin) {
        return kelvin - 273.15f;
    }
    
    private boolean today(Calendar date) {
        Calendar today = Calendar.getInstance();
        return date.get(Calendar.YEAR) == today.get(Calendar.YEAR) &&
               date.get(Calendar.DAY_OF_YEAR) == today.get(Calendar.DAY_OF_YEAR);
    }
    
    private int getDayOfWeekValue(String day) {
        String[] daysOfWeek = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};
        for (int i = 0; i < daysOfWeek.length; i++) {
            if (daysOfWeek[i].equals(day)) return i;
        }
        return 0;
    }
}
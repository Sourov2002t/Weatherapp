<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>Weather Forecast</title>
    <meta charset="utf-8">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root {
            --bg-color: #f5f7fa;
            --card-color: #ffffff;
            --text-color: #333333;
            --accent-color: #4a90e2;
            --secondary-color: #666666;
            --highlight-color: #ff6b6b;
            --background-pattern: linear-gradient(120deg, #e0f7fa 0%, #bbdefb 100%);
        }

        .dark-mode {
            --bg-color: #1a1a2e;
            --card-color: #16213e;
            --text-color: #e6e6e6;
            --accent-color: #0f4c75;
            --secondary-color: #bbbbbb;
            --highlight-color: #ff6b6b;
            --background-pattern: linear-gradient(120deg, #0f2027 0%, #203a43 50%, #2c5364 100%);
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: var(--background-pattern);
            color: var(--text-color);
            margin: 0;
            padding: 0;
            transition: background-color 0.3s, color 0.3s;
            min-height: 100vh;
            background-attachment: fixed;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .logo {
            font-size: 24px;
            font-weight: bold;
            color: var(--accent-color);
            text-decoration: none;
            display: flex;
            align-items: center;
        }

        .logo i {
            margin-right: 10px;
        }

        .theme-toggle {
            background: none;
            border: none;
            color: var(--text-color);
            cursor: pointer;
            font-size: 20px;
            padding: 8px;
            border-radius: 50%;
            transition: background-color 0.3s;
        }

        .theme-toggle:hover {
            background-color: rgba(255, 255, 255, 0.1);
        }

        .search-box {
            display: flex;
            margin-bottom: 20px;
        }

        .search-box input {
            flex: 1;
            padding: 12px 15px;
            border: 1px solid rgba(221, 221, 221, 0.5);
            border-radius: 8px 0 0 8px;
            font-size: 16px;
            outline: none;
            background-color: rgba(255, 255, 255, 0.8);
            transition: background-color 0.3s;
        }

        .dark-mode .search-box input {
            background-color: rgba(0, 0, 0, 0.2);
            color: var(--text-color);
            border-color: rgba(255, 255, 255, 0.1);
        }

        .search-box button {
            padding: 12px 20px;
            background-color: var(--accent-color);
            color: white;
            border: none;
            border-radius: 0 8px 8px 0;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s;
        }

        .search-box button:hover {
            background-color: #3a7bc8;
        }

        .current-weather {
            background-color: var(--card-color);
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            position: relative;
            overflow: hidden;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .location {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 5px;
            display: flex;
            align-items: center;
        }

        .location i {
            margin-right: 8px;
            color: var(--accent-color);
        }

        .weather-main {
            display: flex;
            align-items: center;
            margin: 15px 0;
        }

        .temperature {
            font-size: 48px;
            font-weight: bold;
            margin-right: 20px;
        }

        .weather-icon {
            width: 80px;
            height: 80px;
            filter: drop-shadow(0 0 5px rgba(0, 0, 0, 0.2));
        }

        .weather-description {
            text-transform: capitalize;
            margin-bottom: 15px;
        }

        .weather-details {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
            background-color: rgba(0, 0, 0, 0.05);
            border-radius: 10px;
            padding: 15px;
        }

        .dark-mode .weather-details {
            background-color: rgba(255, 255, 255, 0.05);
        }

        .detail-item {
            text-align: center;
            flex: 1;
        }

        .detail-label {
            font-size: 14px;
            color: var(--secondary-color);
            margin-bottom: 5px;
        }

        .detail-value {
            font-size: 18px;
            font-weight: bold;
        }

        .aqi {
            position: absolute;
            top: 20px;
            right: 20px;
            background-color: #ffcc00;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: bold;
            display: flex;
            align-items: center;
        }

        .aqi i {
            margin-right: 5px;
        }

        .forecast-container {
            background-color: var(--card-color);
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .section-title {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }

        .section-title i {
            margin-right: 10px;
            color: var(--accent-color);
        }

        .forecast-days {
            display: flex;
            overflow-x: auto;
            gap: 15px;
            padding-bottom: 10px;
            scrollbar-width: thin;
            scrollbar-color: var(--accent-color) transparent;
        }

        .forecast-days::-webkit-scrollbar {
            height: 6px;
        }

        .forecast-days::-webkit-scrollbar-track {
            background: transparent;
        }

        .forecast-days::-webkit-scrollbar-thumb {
            background-color: var(--accent-color);
            border-radius: 6px;
        }

        .forecast-day {
            min-width: 100px;
            text-align: center;
            padding: 15px;
            border-radius: 10px;
            background-color: rgba(74, 144, 226, 0.1);
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .forecast-day:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .day-name {
            font-weight: bold;
            margin-bottom: 10px;
        }

        .day-icon {
            width: 40px;
            height: 40px;
            margin: 0 auto 10px;
            filter: drop-shadow(0 0 3px rgba(0, 0, 0, 0.2));
        }

        .day-temp {
    font-size: 16px;
    font-family: sans-serif;
    margin-bottom: 10px;
}
.temp-values {
    display: flex;
    justify-content: space-between;
    margin-bottom: 4px;
}

.temp-high, .temp-low {
    font-weight: bold;
}

.temp-bar {
    height: 8px;
    background: linear-gradient(to right, #ff6666, #ffff66, #66cc66);
    margin-top: 5px;
    border-radius: 4px;
    position: relative;
}

.temp-indicator {
    height: 14px;
    width: 14px;
    background-color: #333;
    border-radius: 50%;
    position: absolute;
    top: -3px;
}

        .chart-container {
            background-color: var(--card-color);
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .chart-tabs {
            display: flex;
            margin-bottom: 15px;
            border-bottom: 1px solid rgba(0, 0, 0, 0.1);
        }

        .chart-tab {
            padding: 8px 15px;
            margin-right: 10px;
            cursor: pointer;
            border-bottom: 2px solid transparent;
            transition: all 0.3s;
        }

        .chart-tab.active {
            border-bottom: 2px solid var(--accent-color);
            color: var(--accent-color);
            font-weight: bold;
        }

        .error-message {
            color: #ff3333;
            font-weight: bold;
            margin: 10px 0;
            padding: 15px;
            background-color: rgba(255, 51, 51, 0.1);
            border-radius: 8px;
            text-align: center;
            border-left: 4px solid #ff3333;
        }

        .temp-bar {
            position: relative;
            height: 6px;
            background: #ccc;
            border-radius: 3px;
            margin: 10px 0;
            overflow: hidden;
        }

        .temp-bar-fill {
            position: absolute;
            height: 100%;
            background: linear-gradient(to right, #3399ff, #ff3333);
            border-radius: 3px;
        }

        @media (max-width: 600px) {
            .weather-main {
                flex-direction: column;
                text-align: center;
            }
            
            .temperature {
                margin-right: 0;
                margin-bottom: 10px;
            }
            
            .weather-details {
                flex-wrap: wrap;
            }
            
            .detail-item {
                flex: 50%;
                margin-bottom: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <a href="https://openweathermap.org/" class="logo" target="_blank">
                <i class="fas fa-cloud-sun"></i>WeatherApp
            </a>
            <button class="theme-toggle" id="themeToggle">
                <i class="fas fa-moon"></i>
            </button>
        </div>

        <form action="weather" method="post" class="search-box">
            <input type="text" name="city" required placeholder="Enter city name..." 
                   value="<%= request.getParameter("city") != null ? request.getParameter("city") : "" %>" />
            <button type="submit"><i class="fas fa-search"></i> Search</button>
        </form>

        <% 
        String error = (String) request.getAttribute("error");
        if (error != null) {
        %>
            <div class="error-message"><i class="fas fa-exclamation-circle"></i> <%= error %></div>
        <% } %>
        <% 
        String weather = (String) request.getAttribute("weather");
        String temperature = (String) request.getAttribute("temperature");
        String humidity = (String) request.getAttribute("humidity");
        String windSpeed = (String) request.getAttribute("windSpeed");
        String pressure = (String) request.getAttribute("pressure");
        String cityName = (String) request.getAttribute("city");
        String aqi = (String) request.getAttribute("aqi");
        
        if (weather != null && temperature != null) {
            float tempC = Float.parseFloat(temperature);
            
            String iconUrl = "https://openweathermap.org/img/wn/";
            if (weather.toLowerCase().contains("clear")) {
                iconUrl += "01d@2x.png";
            } else if (weather.toLowerCase().contains("cloud")) {
                iconUrl += "03d@2x.png";
            } else if (weather.toLowerCase().contains("rain")) {
                iconUrl += "09d@2x.png";
            } else if (weather.toLowerCase().contains("snow")) {
                iconUrl += "13d@2x.png";
            } else if (weather.toLowerCase().contains("thunder")) {
                iconUrl += "11d@2x.png";
            } else if (weather.toLowerCase().contains("mist") || weather.toLowerCase().contains("fog")) {
                iconUrl += "50d@2x.png";
            } else {
                iconUrl += "02d@2x.png";
            }
        %>
            <div class="current-weather">
                <div class="location"><i class="fas fa-map-marker-alt"></i> <%= cityName %></div>
                <div class="aqi"><i class="fas fa-wind"></i> AQI <%= aqi %></div>
                
                <div class="weather-main">
                    <div class="temperature"><%= String.format("%.0f°C", tempC) %></div>
                    <img class="weather-icon" src="<%= iconUrl %>" alt="Weather Condition" />
                </div>
                
                <div class="weather-description"><%= weather %></div>
                
                <div class="weather-details">
                    <div class="detail-item">
                        <div class="detail-label"><i class="fas fa-tint"></i> Humidity</div>
                        <div class="detail-value"><%= humidity %>%</div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label"><i class="fas fa-wind"></i> Wind</div>
                        <div class="detail-value"><%= windSpeed %> m/s</div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label"><i class="fas fa-compress-alt"></i> Pressure</div>
                        <div class="detail-value"><%= pressure %> hPa</div>
                    </div>
                </div>
            </div>
            
            <% 
            List<Map<String, String>> hourlyData = (List<Map<String, String>>) request.getAttribute("hourlyData");
            if (hourlyData != null && !hourlyData.isEmpty()) {
            %>
                <div class="chart-container">
                    <div class="section-title">
                        <i class="fas fa-chart-line"></i>Hourly Temperature
                    </div>
                    <div class="chart-tabs">
                        <div class="chart-tab active" id="tempTab">Temperature</div>
                        <div class="chart-tab" id="humidityTab">Humidity</div>
                    </div>
                    <canvas id="temperatureChart" height="250"></canvas>
                    <canvas id="humidityChart" height="250" style="display: none;"></canvas>
                    <script>
                        // Set chart colors based on theme
                        const isDark = document.body.classList.contains('dark-mode');
                        const gridColor = isDark ? 'rgba(255, 255, 255, 0.1)' : 'rgba(0, 0, 0, 0.1)';
                        const textColor = isDark ? '#e6e6e6' : '#333333';
                        
                        // Temperature Chart
                        const tempCtx = document.getElementById('temperatureChart').getContext('2d');
                        const gradientFill = tempCtx.createLinearGradient(0, 0, 0, 250);
                        gradientFill.addColorStop(0, 'rgba(74, 144, 226, 0.5)');
                        gradientFill.addColorStop(1, 'rgba(74, 144, 226, 0.1)');
                        
                        const tempChart = new Chart(tempCtx, {
                            type: 'line',
                            data: {
                                labels: [
                                    <% for (Map<String, String> hour : hourlyData) { %>
                                        "<%= hour.get("time") %>",
                                    <% } %>
                                ],
                                datasets: [{
                                    label: 'Temperature (°C)',
                                    data: [
                                        <% for (Map<String, String> hour : hourlyData) { 
                                            float temp = Float.parseFloat(hour.get("temp"));
                                        %>
                                            <%= String.format("%.1f", temp) %>,
                                        <% } %>
                                    ],
                                    borderColor: '#4a90e2',
                                    backgroundColor: gradientFill,
                                    borderWidth: 3,
                                    tension: 0.4,
                                    fill: true,
                                    pointBackgroundColor: '#ffffff',
                                    pointBorderColor: '#4a90e2',
                                    pointRadius: 4,
                                    pointHoverRadius: 6
                                }]
                            },
                            options: {
                                responsive: true,
                                plugins: {
                                    legend: {
                                        display: true,
                                        labels: {
                                            color: textColor
                                        }
                                    },
                                    tooltip: {
                                        mode: 'index',
                                        intersect: false,
                                        backgroundColor: isDark ? '#16213e' : '#ffffff',
                                        titleColor: isDark ? '#e6e6e6' : '#333333',
                                        bodyColor: isDark ? '#e6e6e6' : '#333333',
                                        borderColor: isDark ? '#4a90e2' : '#4a90e2',
                                        borderWidth: 1
                                    }
                                },
                                scales: {
                                    y: {
                                        beginAtZero: false,
                                        grid: {
                                            color: gridColor
                                        },
                                        ticks: {
                                            color: textColor
                                        }
                                    },
                                    x: {
                                        grid: {
                                            display: false
                                        },
                                        ticks: {
                                            color: textColor
                                        }
                                    }
                                }
                            }
                        });
                        
                        // Humidity Chart
                        const humCtx = document.getElementById('humidityChart').getContext('2d');
                        const humGradient = humCtx.createLinearGradient(0, 0, 0, 250);
                        humGradient.addColorStop(0, 'rgba(102, 126, 234, 0.5)');
                        humGradient.addColorStop(1, 'rgba(102, 126, 234, 0.1)');
                        
                        const humChart = new Chart(humCtx, {
                            type: 'line',
                            data: {
                                labels: [
                                    <% for (Map<String, String> hour : hourlyData) { %>
                                        "<%= hour.get("time") %>",
                                    <% } %>
                                ],
                                datasets: [{
                                    label: 'Humidity (%)',
                                    data: [
                                        <% for (Map<String, String> hour : hourlyData) { %>
                                            <%= hour.get("humidity") %>,
                                        <% } %>
                                    ],
                                    borderColor: '#667eea',
                                    backgroundColor: humGradient,
                                    borderWidth: 3,
                                    tension: 0.4,
                                    fill: true,
                                    pointBackgroundColor: '#ffffff',
                                    pointBorderColor: '#667eea',
                                    pointRadius: 4,
                                    pointHoverRadius: 6
                                }]
                            },
                            options: {
                                responsive: true,
                                plugins: {
                                    legend: {
                                        display: true,
                                        labels: {
                                            color: textColor
                                        }
                                    },
                                    tooltip: {
                                        mode: 'index',
                                        intersect: false,
                                        backgroundColor: isDark ? '#16213e' : '#ffffff',
                                        titleColor: isDark ? '#e6e6e6' : '#333333',
                                        bodyColor: isDark ? '#e6e6e6' : '#333333',
                                        borderColor: isDark ? '#667eea' : '#667eea',
                                        borderWidth: 1
                                    }
                                },
                                scales: {
                                    y: {
                                        beginAtZero: true,
                                        max: 100,
                                        grid: {
                                            color: gridColor
                                        },
                                        ticks: {
                                            color: textColor
                                        }
                                    },
                                    x: {
                                        grid: {
                                            display: false
                                        },
                                        ticks: {
                                            color: textColor
                                        }
                                    }
                                }
                            }
                        });
                        
                        // Tab switching logic
                        document.getElementById('tempTab').addEventListener('click', function() {
                            this.classList.add('active');
                            document.getElementById('humidityTab').classList.remove('active');
                            document.getElementById('temperatureChart').style.display = 'block';
                            document.getElementById('humidityChart').style.display = 'none';
                        });
                        
                        document.getElementById('humidityTab').addEventListener('click', function() {
                            this.classList.add('active');
                            document.getElementById('tempTab').classList.remove('active');
                            document.getElementById('temperatureChart').style.display = 'none';
                            document.getElementById('humidityChart').style.display = 'block';
                        });
                    </script>
                </div>
            <% } %>
            
            
            <div class="forecast-container">
                <div class="section-title">
                    <i class="fas fa-calendar-alt"></i>7-Day Forecast
                </div>
                <div class="forecast-days">
                    <% 
                    List<Map<String, String>> forecast = 
                        (List<Map<String, String>>) request.getAttribute("forecast");
                    
                    if (forecast != null && !forecast.isEmpty()) {
                        for (Map<String, String> day : forecast) {
                            String iconUrlForecast = "https://openweathermap.org/img/wn/";
                            String description = day.get("description");
                            if (description != null) {
                                if (description.toLowerCase().contains("clear")) {
                                    iconUrlForecast += "01d@2x.png";
                                } else if (description.toLowerCase().contains("cloud")) {
                                    iconUrlForecast += "03d@2x.png";
                                } else if (description.toLowerCase().contains("rain")) {
                                    iconUrlForecast += "09d@2x.png";
                                } else if (description.toLowerCase().contains("snow")) {
                                    iconUrlForecast += "13d@2x.png";
                                } else if (description.toLowerCase().contains("thunder")) {
                                    iconUrlForecast += "11d@2x.png";
                                } else if (description.toLowerCase().contains("mist") || description.toLowerCase().contains("fog")) {
                                    iconUrlForecast += "50d@2x.png";
                                } else {
                                    iconUrlForecast += "02d@2x.png";
                                }
                            }
                            
                            float tempMax = Float.parseFloat(day.get("tempMax"));
                            float tempMin = Float.parseFloat(day.get("tempMin"));
                    %>
                        <div class="forecast-day">
                            <div class="day-name"><%= day.get("dayName") %></div>
                            <img class="day-icon" src="<%= iconUrlForecast %>" alt="Weather" />
                            <div class="temp-values">
        <span class="temp-low"><%= String.format("%.0f°C", tempMin) %></span>
        <span class="temp-high"><%= String.format("%.0f°C", tempMax) %></span>
    </div>
                            <div class="temp-bar">
                            
        <% 
            // Normalize the values for bar positioning (example: 0 to 50°C range)
            double minRange = 0;
            double maxRange = 50;
            double normalizedMin = ((tempMin - minRange) / (maxRange - minRange)) * 100;
            double normalizedMax = ((tempMax - minRange) / (maxRange - minRange)) * 100;
        %>
        
        <div class="temp-indicator" style="left: <%= normalizedMin %>%;" title="Min Temp"></div>
        <div class="temp-indicator" style="left: <%= normalizedMax %>%;" title="Max Temp"></div>
    </div>
                        </div>
                        
                    <% } 
                    } %>
                </div>
            </div>
        <% } %>
    </div>

    <script>
        // Dark/Light mode toggle
        const themeToggle = document.getElementById('themeToggle');
        const icon = themeToggle.querySelector('i');
        
        // Check for saved theme preference or use preferred color scheme
        const savedTheme = localStorage.getItem('theme');
        const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
        
        if (savedTheme === 'dark' || (!savedTheme && prefersDark)) {
            document.body.classList.add('dark-mode');
            icon.classList.remove('fa-moon');
            icon.classList.add('fa-sun');
        }
        
        themeToggle.addEventListener('click', () => {
            document.body.classList.toggle('dark-mode');
            
            if (document.body.classList.contains('dark-mode')) {
                icon.classList.remove('fa-moon');
                icon.classList.add('fa-sun');
                localStorage.setItem('theme', 'dark');
                
                // Update chart colors for dark mode if charts exist
                if (typeof tempChart !== 'undefined') {
                    tempChart.options.scales.y.grid.color = 'rgba(255, 255, 255, 0.1)';
                    tempChart.options.scales.y.ticks.color = '#e6e6e6';
                    tempChart.options.scales.x.ticks.color = '#e6e6e6';
                    tempChart.update();
                }
                
                if (typeof humChart !== 'undefined') {
                    humChart.options.scales.y.grid.color = 'rgba(255, 255, 255, 0.1)';
                    humChart.options.scales.y.ticks.color = '#e6e6e6';
                    humChart.options.scales.x.ticks.color = '#e6e6e6';
                    humChart.update();
                }
            } else {
                icon.classList.remove('fa-sun');
                icon.classList.add('fa-moon');
                localStorage.setItem('theme', 'light');
                
                // Update chart colors for light mode if charts exist
                if (typeof tempChart !== 'undefined') {
                    tempChart.options.scales.y.grid.color = 'rgba(0, 0, 0, 0.1)';
                    tempChart.options.scales.y.ticks.color = '#333333';
                    tempChart.options.scales.x.ticks.color = '#333333';
                    tempChart.update();
                }
                
                if (typeof humChart !== 'undefined') {
                    humChart.options.scales.y.grid.color = 'rgba(0, 0, 0, 0.1)';
                    humChart.options.scales.y.ticks.color = '#333333';
                    humChart.options.scales.x.ticks.color = '#333333';
                    humChart.update();
                }
            }
            
            function updateForecastDisplay(dailyForecasts) {
                const forecastContainer = document.getElementById('forecastContainer');
                forecastContainer.innerHTML = '';
                
                // Find overall min and max temps for proper scaling
                const allTemps = dailyForecasts.flatMap(day => [day.minTemp, day.maxTemp]);
                const overallMin = Math.min(...allTemps) - 2; // Padding for visualization
                const overallMax = Math.max(...allTemps) + 2;
                const tempRange = overallMax - overallMin;
                
                dailyForecasts.forEach(day => {
                    const dayElement = document.createElement('div');
                    dayElement.className = 'forecast-day';
                    
                    const dayName = formatDayName(day.date);
                    let iconHTML = getWeatherIcon(day.condition);
                    
                    // Calculate bar positions as percentages
                    const startPercent = ((day.minTemp - overallMin) / tempRange) * 100;
                    const widthPercent = ((day.maxTemp - day.minTemp) / tempRange) * 100;
                    
                    dayElement.innerHTML = `
                        <div class="day-name">${dayName}</div>
                        <div class="weather-icon">${iconHTML}</div>
                        <div class="temp-bar">
                            <div class="temp-bar-fill" style="left: ${startPercent}%; width: ${widthPercent}%;"></div>
                        </div>
                        <div class="forecast-temp-range">
                            <span class="forecast-low">${day.minTemp}°C</span>
                            <span class="forecast-high">${day.maxTemp}°C</span>
                        </div>
                    ;
                    
                    forecastContainer.appendChild(dayElement);
                });
            }
        });
    </script>
</body>
</html>
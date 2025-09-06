import 'package:flutter/material.dart';
import '../models/weather_models.dart';
import '../services/weather_service.dart';
import '../widgets/weather_detail_item.dart';
import '../widgets/forecast_item.dart';
import '../widgets/error_widget.dart';
import 'location_list_page.dart';

// Weather Home Page with Theme Support
class WeatherHomePage extends StatefulWidget {
  final String? selectedCity;
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  WeatherHomePage({
    this.selectedCity,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  WeatherData? _weatherData;
  bool _isLoading = true;
  String? _error;
  String _currentCity = 'Current Location';

  @override
  void initState() {
    super.initState();
    _currentCity = widget.selectedCity ?? 'Current Location';
    _loadWeather();
  }

  void _loadWeather() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      WeatherData weather;
      if (_currentCity == 'Current Location') {
        weather = await WeatherService.getCurrentLocationWeather();
      } else {
        weather = await WeatherService.getWeatherByCity(_currentCity);
      }
      
      setState(() {
        _weatherData = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        print("harsh -" + e.toString());
        _isLoading = false;
      });
    }
  }

  Color _getBackgroundColor() {
    if (_weatherData == null) {
      return widget.isDarkMode ? Colors.blue.shade800 : Colors.blue.shade300;
    }
    
    final iconCode = _weatherData!.iconCode.replaceAll(RegExp(r'[dn]'), '');
    
    switch (iconCode) {
      case '01': // Clear sky
        return widget.isDarkMode ? Colors.orange.shade800 : Colors.orange.shade300;
      case '02': // Few clouds
      case '03': // Scattered clouds
        return widget.isDarkMode ? Colors.blue.shade800 : Colors.blue.shade400;
      case '04': // Broken clouds
        return widget.isDarkMode ? Colors.blueGrey.shade800 : Colors.blueGrey.shade400;
      case '09': // Shower rain
      case '10': // Rain
        return widget.isDarkMode ? Colors.grey.shade700 : Colors.grey.shade500;
      case '11': // Thunderstorm
        return widget.isDarkMode ? Colors.indigo.shade900 : Colors.indigo.shade600;
      case '13': // Snow
        return widget.isDarkMode ? Colors.lightBlue.shade700 : Colors.lightBlue.shade200;
      case '50': // Mist
        return widget.isDarkMode ? Colors.blueGrey.shade600 : Colors.blueGrey.shade300;
      default:
        return widget.isDarkMode ? Colors.blue.shade800 : Colors.blue.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => _loadWeather(),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _getBackgroundColor(),
                _getBackgroundColor().withOpacity(0.7),
              ],
            ),
          ),
          child: SafeArea(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(
                    color: widget.isDarkMode ? Colors.black : Colors.white
                  ))
                : _error != null
                    ? WeatherErrorWidget(
                        error: _error,
                        onRetry: _loadWeather,
                        isDarkMode: widget.isDarkMode,
                      )
                    : SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              _buildHeader(),
                              SizedBox(height: 30),
                              _buildCurrentWeather(),
                              SizedBox(height: 20),
                              _buildWeatherDetails(),
                              SizedBox(height: 30),
                              _buildForecast(),
                            ],
                          ),
                        ),
                      ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(
            Icons.location_on, 
            color: widget.isDarkMode ? Colors.black : Colors.white, 
            size: 30
          ),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LocationListPage(
                  isDarkMode: widget.isDarkMode,
                ),
              ),
            );
            if (result != null) {
              setState(() => _currentCity = result);
              _loadWeather();
            }
          },
        ),
        Text(
          'WeatherNow',
          style: TextStyle(
            color: widget.isDarkMode ? Colors.black : Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: Icon(
            widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            color: widget.isDarkMode ? Colors.black : Colors.white,
            size: 30,
          ),
          onPressed: widget.onThemeToggle,
        ),
      ],
    );
  }

  Widget _buildCurrentWeather() {
    if (_weatherData == null) return SizedBox();

    return Column(
      children: [
        Text(
          _weatherData!.city,
          style: TextStyle(
            color: widget.isDarkMode ? Colors.black : Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          _weatherData!.weatherIcon,
          style: TextStyle(fontSize: 80),
        ),
        SizedBox(height: 10),
        Text(
          '${_weatherData!.temperature.round()}°',
          style: TextStyle(
            color: widget.isDarkMode ? Colors.black : Colors.white,
            fontSize: 72,
            fontWeight: FontWeight.w200,
          ),
        ),
        Text(
          _weatherData!.description.toUpperCase(),
          style: TextStyle(
            color: widget.isDarkMode ? Colors.black87 : Colors.white70,
            fontSize: 16,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherDetails() {
    if (_weatherData == null) return SizedBox();

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          WeatherDetailItem(
            label: 'Feels Like',
            value: '${_weatherData!.feelsLike.round()}°',
            isDarkMode: widget.isDarkMode,
          ),
          WeatherDetailItem(
            label: 'Humidity',
            value: '${_weatherData!.humidity}%',
            isDarkMode: widget.isDarkMode,
          ),
          WeatherDetailItem(
            label: 'Wind',
            value: '${_weatherData!.windSpeed.toStringAsFixed(1)} m/s',
            isDarkMode: widget.isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildForecast() {
    if (_weatherData == null || _weatherData!.forecast.isEmpty) return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '5-Day Forecast',
          style: TextStyle(
            color: widget.isDarkMode ? Colors.black : Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15),
        Container(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _weatherData!.forecast.length,
            itemBuilder: (context, index) {
              final forecast = _weatherData!.forecast[index];
              return ForecastItem(
                forecast: forecast,
                isDarkMode: widget.isDarkMode,
              );
            },
          ),
        ),
      ],
    );
  }
}

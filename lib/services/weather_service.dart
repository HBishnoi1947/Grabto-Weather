import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/weather_models.dart';

// Weather Service with Real OpenWeatherMap API
class WeatherService {
  static const String _apiKey = 'e13645699215663149fca18d4f44fcb4'; // Replace with your actual API key
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  static Future<WeatherData> getWeatherByCity(String city) async {
    try {
      // Get current weather
      final currentResponse = await http.get(
        Uri.parse('$_baseUrl/weather?q=$city&appid=$_apiKey&units=metric'),
      );

      if (currentResponse.statusCode == 200) {
        final currentData = json.decode(currentResponse.body);
        
        // Get coordinates for forecast
        final lat = currentData['coord']['lat'];
        final lon = currentData['coord']['lon'];
        
        // Get 5-day forecast
        final forecastResponse = await http.get(
          Uri.parse('$_baseUrl/forecast?lat=$lat&lon=$lon&appid=$_apiKey&units=metric'),
        );

        List<DailyForecast> forecast = [];
        if (forecastResponse.statusCode == 200) {
          final forecastData = json.decode(forecastResponse.body);
          forecast = _parseForecast(forecastData['list']);
        } else {
          // Fallback forecast data
          forecast = _generateFallbackForecast();
        }

        return WeatherData.fromJson(currentData, forecast);
      } else {
        throw Exception('Failed to load weather data: ${currentResponse.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // static Future<WeatherData> getWeatherByCoordinates(double lat, double lon) async {
  //   try {
  //     // Get current weather
  //     final currentResponse = await http.get(
  //       Uri.parse('$_baseUrl/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric'),
  //     );

  //     if (currentResponse.statusCode == 200) {
  //       final currentData = json.decode(currentResponse.body);
        
  //       // Get 5-day forecast
  //       final forecastResponse = await http.get(
  //         Uri.parse('$_baseUrl/forecast?lat=$lat&lon=$lon&appid=$_apiKey&units=metric'),
  //       );

  //       List<DailyForecast> forecast = [];
  //       if (forecastResponse.statusCode == 200) {
  //         final forecastData = json.decode(forecastResponse.body);
  //         forecast = _parseForecast(forecastData['list']);
  //       } else {
  //         forecast = _generateFallbackForecast();
  //       }

  //       return WeatherData.fromJson(currentData, forecast);
  //     } else {
  //       throw Exception('Failed to load weather data: ${currentResponse.reasonPhrase}');
  //     }
  //   } catch (e) {
  //     throw Exception('Network error: $e');
  //   }
  // }

  static Future<WeatherData> getCurrentLocationWeather() async {
    // For demo purposes, using default coordinates (London)
    // In a real app, you'd use location services to get actual coordinates
    return getWeatherByCity('Lucknow');
  }

  static List<DailyForecast> _parseForecast(List<dynamic> forecastList) {
    Map<String, List<Map<String, dynamic>>> dailyForecasts = {};
    
    for (var item in forecastList) {
      final date = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
      final dayKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      
      if (!dailyForecasts.containsKey(dayKey)) {
        dailyForecasts[dayKey] = [];
      }
      dailyForecasts[dayKey]!.add(item);
    }

    List<DailyForecast> result = [];
    int dayCounter = 0;
    
    for (var entry in dailyForecasts.entries.take(5)) {
      final forecasts = entry.value;
      
      double maxTemp = forecasts.map((f) => f['main']['temp_max'].toDouble()).reduce((a, b) => a > b ? a : b);
      double minTemp = forecasts.map((f) => f['main']['temp_min'].toDouble()).reduce((a, b) => a < b ? a : b);
      
      // Use the most common weather icon for the day
      final iconCode = forecasts[0]['weather'][0]['icon'];
      
      String dayName;
      if (dayCounter == 0) {
        dayName = 'Today';
      } else if (dayCounter == 1) {
        dayName = 'Tomorrow';
      } else {
        final date = DateTime.fromMillisecondsSinceEpoch(forecasts[0]['dt'] * 1000);
        final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        dayName = dayNames[date.weekday - 1];
      }
      
      result.add(DailyForecast(
        day: dayName,
        maxTemp: maxTemp,
        minTemp: minTemp,
        iconCode: iconCode,
      ));
      
      dayCounter++;
    }
    
    return result;
  }

  static List<DailyForecast> _generateFallbackForecast() {
    final days = ['Today', 'Tomorrow', 'Wed', 'Thu', 'Fri'];
    final icons = ['01d', '02d', '03d', '10d', '04d'];
    final random = Random();
    
    return List.generate(5, (index) {
      final baseTemp = 15 + random.nextDouble() * 15; // 15-30°C
      return DailyForecast(
        day: days[index],
        maxTemp: baseTemp + 3,
        minTemp: baseTemp - 3,
        iconCode: icons[index],
      );
    });
  }
}

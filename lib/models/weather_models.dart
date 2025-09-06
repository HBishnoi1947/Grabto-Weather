// Weather Data Models
class WeatherData {
  final String city;
  final double temperature;
  final String description;
  final String iconCode;
  final double minTemp;
  final double maxTemp;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final List<DailyForecast> forecast;

  WeatherData({
    required this.city,
    required this.temperature,
    required this.description,
    required this.iconCode,
    required this.minTemp,
    required this.maxTemp,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.forecast,
  });

  String get weatherIcon {
    switch (iconCode.replaceAll(RegExp(r'[dn]'), '')) {
      case '01': return '☀️'; // clear sky
      case '02': return '⛅'; // few clouds
      case '03': return '☁️'; // scattered clouds
      case '04': return '☁️'; // broken clouds
      case '09': return '🌧️'; // shower rain
      case '10': return '🌦️'; // rain
      case '11': return '⛈️'; // thunderstorm
      case '13': return '❄️'; // snow
      case '50': return '🌫️'; // mist
      default: return '🌤️';
    }
  }

  factory WeatherData.fromJson(Map<String, dynamic> json, List<DailyForecast> forecast) {
    return WeatherData(
      city: json['name'],
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      iconCode: json['weather'][0]['icon'],
      minTemp: json['main']['temp_min'].toDouble(),
      maxTemp: json['main']['temp_max'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      humidity: json['main']['humidity'],
      windSpeed: json['wind']?['speed']?.toDouble() ?? 0.0,
      forecast: forecast,
    );
  }
}

class DailyForecast {
  final String day;
  final double maxTemp;
  final double minTemp;
  final String iconCode;

  DailyForecast({
    required this.day,
    required this.maxTemp,
    required this.minTemp,
    required this.iconCode,
  });

  String get weatherIcon {
    switch (iconCode.replaceAll(RegExp(r'[dn]'), '')) {
      case '01': return '☀️';
      case '02': return '⛅';
      case '03': return '☁️';
      case '04': return '☁️';
      case '09': return '🌧️';
      case '10': return '🌦️';
      case '11': return '⛈️';
      case '13': return '❄️';
      case '50': return '🌫️';
      default: return '🌤️';
    }
  }

  factory DailyForecast.fromJson(Map<String, dynamic> json, String dayName) {
    return DailyForecast(
      day: dayName,
      maxTemp: json['main']['temp_max'].toDouble(),
      minTemp: json['main']['temp_min'].toDouble(),
      iconCode: json['weather'][0]['icon'],
    );
  }
}

import 'package:flutter/material.dart';

class WeatherErrorWidget extends StatelessWidget {
  final String? error;
  final VoidCallback onRetry;
  final bool isDarkMode;

  const WeatherErrorWidget({
    Key? key,
    required this.error,
    required this.onRetry,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline, 
            size: 64, 
            color: isDarkMode ? Colors.black87 : Colors.white70
          ),
          SizedBox(height: 16),
          Text(
            'Unable to load weather data',
            style: TextStyle(
              color: isDarkMode ? Colors.black : Colors.white, 
              fontSize: 18
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            error?.contains('API') == true
                ? 'Please add your OpenWeatherMap API key' 
                : 'Check your internet connection',
            style: TextStyle(
              color: isDarkMode ? Colors.black87 : Colors.white70, 
              fontSize: 14
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode 
                  ? Colors.black.withOpacity(0.2) 
                  : Colors.white.withOpacity(0.2),
              foregroundColor: isDarkMode ? Colors.black : Colors.white,
            ),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }
}

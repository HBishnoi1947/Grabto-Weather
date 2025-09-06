import 'package:flutter/material.dart';
import '../models/weather_models.dart';

class ForecastItem extends StatelessWidget {
  final DailyForecast forecast;
  final bool isDarkMode;

  const ForecastItem({
    Key? key,
    required this.forecast,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              forecast.day,
              style: TextStyle(
                color: isDarkMode ? Colors.black : Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
            Text(
              forecast.weatherIcon,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 4),
            Text(
              '${forecast.maxTemp.round()}°',
              style: TextStyle(
                color: isDarkMode ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              '${forecast.minTemp.round()}°',
              style: TextStyle(
                color: isDarkMode ? Colors.black87 : Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

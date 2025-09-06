import 'package:flutter/material.dart';

class WeatherDetailItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isDarkMode;

  const WeatherDetailItem({
    Key? key,
    required this.label,
    required this.value,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDarkMode ? Colors.black87 : Colors.white70, 
            fontSize: 12
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: isDarkMode ? Colors.black : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'managers/favorites_manager.dart';
import 'pages/splash_screen.dart';

// Main App with Theme Management
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FavoritesManager.initialize();
  runApp(WeatherNowApp());
}

class WeatherNowApp extends StatefulWidget {
  @override
  _WeatherNowAppState createState() => _WeatherNowAppState();
}

class _WeatherNowAppState extends State<WeatherNowApp> {
  bool _isDarkMode = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  void _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _isDarkMode = prefs.getBool('isDarkMode') ?? false;
        _isLoading = false;
      });
    } catch (e) {
      // If there's an error loading preferences, default to light mode
      setState(() {
        _isDarkMode = false;
        _isLoading = false;
      });
    }
  }

  void _toggleTheme() async {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', _isDarkMode);
    } catch (e) {
      // If saving fails, the theme change is still applied in the UI
      print('Error saving theme preference: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        title: 'Grabto Weather',
        theme: _buildLightTheme(), // Default to light theme while loading
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        debugShowCheckedModeBanner: false,
      );
    }

    return MaterialApp(
      key: ValueKey(_isDarkMode), // Force rebuild when theme changes
      title: 'Grabto Weather',
      theme: _isDarkMode ? _buildDarkTheme() : _buildLightTheme(),
      home: SplashScreen(
        isDarkMode: _isDarkMode,
        onThemeToggle: _toggleTheme,
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.blue.shade50,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.grey.shade900,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: Colors.grey.shade800,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black87),
      ),
    );
  }
}
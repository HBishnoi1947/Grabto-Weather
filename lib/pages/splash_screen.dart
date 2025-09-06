import 'package:flutter/material.dart';
import 'weather_home_page.dart';

// Splash Screen with Sun/Moon Animation
class SplashScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  SplashScreen({required this.isDarkMode, required this.onThemeToggle});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _sunController;
  late AnimationController _moonController;
  late Animation<double> _sunAnimation;
  late Animation<double> _moonAnimation;

  @override
  void initState() {
    super.initState();
    
    _sunController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    
    _moonController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _sunAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _sunController, curve: Curves.easeInOut),
    );
    
    _moonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _moonController, curve: Curves.easeInOut),
    );

    _startAnimation();
  }

  void _startAnimation() async {
    await _sunController.forward();
    await Future.delayed(Duration(milliseconds: 500));
    await _sunController.reverse();
    await _moonController.forward();
    await Future.delayed(Duration(seconds: 1));
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WeatherHomePage(
          isDarkMode: widget.isDarkMode,
          onThemeToggle: widget.onThemeToggle,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _sunController.dispose();
    _moonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: widget.isDarkMode
                ? [Colors.indigo.shade900, Colors.purple.shade900]
                : [Colors.orange.shade200, Colors.blue.shade300],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _sunAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, -100 * _sunAnimation.value),
                    child: Opacity(
                      opacity: _sunAnimation.value,
                      child: Icon(
                        Icons.wb_sunny,
                        size: 80,
                        color: Colors.orange,
                      ),
                    ),
                  );
                },
              ),
              AnimatedBuilder(
                animation: _moonAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, -100 * _moonAnimation.value),
                    child: Opacity(
                      opacity: _moonAnimation.value,
                      child: Icon(
                        Icons.nights_stay,
                        size: 80,
                        color: Colors.yellow.shade100,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 40),
              Text(
                'Grabto Weather',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: widget.isDarkMode ? Colors.black : Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Real-time weather at your fingertips',
                style: TextStyle(
                  fontSize: 16,
                  color: widget.isDarkMode ? Colors.black87 : Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

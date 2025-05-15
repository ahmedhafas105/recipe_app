import 'package:flutter/material.dart';
import 'package:recipe_app/home_screen.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Recipe Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[50],
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoPulseAnimation;
  int _pulseCount = 0;
  final int _maxPulses = 3; // Number of pulsation cycles before navigation

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Duration of one pulsation cycle
    );

    // Logo pulsates (vibrates) for a set number of cycles
    _logoPulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _pulseCount++;
        if (_pulseCount < _maxPulses) {
          _controller.reverse(); // Reverse for the next cycle
        } else {
          _controller.stop();
          _navigateToHome();
        }
      } else if (status == AnimationStatus.dismissed) {
        _pulseCount++;
        if (_pulseCount < _maxPulses) {
          _controller.forward(); // Forward for the next cycle
        } else {
          _controller.stop();
          _navigateToHome();
        }
      }
    });

    _controller.forward(); // Start the pulsation animation
  }

  void _navigateToHome() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB3E5FC), // Light Blue 100
              Color(0xFF4FC3F7), // Light Blue 300
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return ScaleTransition(
                scale: _logoPulseAnimation,
                child: Image.asset(
                  'assets/images/final_logo.png',
                  width: 300,
                  height: 300,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(_controller);

    _controller.forward();

    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _animation,
        child: Container(
          color: Colors.white, // fondo blanco detrás de la imagen
          child: Center(
            child: Image.asset(
              "assets/images/logo_vetapp_oficial.png",
              fit: BoxFit.contain, // mantiene proporciones
              width:
                  MediaQuery.of(context).size.width *
                  0.6, // ocupa 60% del ancho
            ),
          ),
        ),
      ),
    );
  }
}

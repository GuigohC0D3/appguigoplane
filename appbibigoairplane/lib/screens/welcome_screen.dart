import 'dart:async';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  String displayedText = '';
  final String fullText = 'O destino dos seus sonhos\ncomeça aqui';
  int _charIndex = 0;
  Timer? _timer;

  late AnimationController _logoController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _startTypingEffect();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );
  }

  void _startTypingEffect() {
    _timer = Timer.periodic(const Duration(milliseconds: 60), (timer) {
      if (_charIndex < fullText.length) {
        setState(() {
          displayedText += fullText[_charIndex];
          _charIndex++;
        });
      } else {
        _timer?.cancel();
        Future.delayed(const Duration(milliseconds: 300), () {
          _logoController.forward();
          Future.delayed(const Duration(seconds: 2), () {
            if (!mounted) return;
            Navigator.pushReplacementNamed(context, '/home');
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      shadows: [
        Shadow(
          blurRadius: 4,
          color: Colors.black.withOpacity(0.25),
          offset: const Offset(1, 2),
        ),
      ],
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFaee0fd),
              Color.fromARGB(255, 255, 255, 255),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Texto animado
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                displayedText,
                textAlign: TextAlign.center,
                style: textStyle,
              ),
            ),
            const SizedBox(height: 40),

            // Logo com animação
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Image.asset(
                  'assets/img/bibigoairplanee.png',
                  width: 160,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

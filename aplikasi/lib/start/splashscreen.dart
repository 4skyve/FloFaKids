import 'package:app1/services/audio_service.dart';
import 'package:app1/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'dart:math';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController? _scaleController;
  AnimationController? _fadeController;
  Animation<double>? _scaleAnimation;
  Animation<double>? _fadeAnimation;
  bool _audioStarted = false;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController!,
      curve: Curves.elasticOut,
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController!,
      curve: Curves.easeIn,
    );

    _scaleController!.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _fadeController!.forward();
      }
    });

    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
  AudioService.playSplash().catchError((_) {});

  FirebaseService.clearCache();

  await Future.wait([
    FirebaseService.getQuestions(1),
    FirebaseService.getQuestions(2),
    FirebaseService.getQuestions(3),
    FirebaseService.getQuestionsEn(1),
    FirebaseService.getQuestionsEn(2),
    FirebaseService.getQuestionsEn(3),
    FirebaseService.getFloraArticles(),
    FirebaseService.getFaunaArticles(),
    FirebaseService.getFloraArticlesEn(),
    FirebaseService.getFaunaArticlesEn(),
  ]);

  await Future.delayed(const Duration(seconds: 4));
  AudioService.stopMusic().catchError((_) {});
  AudioService.playBacksound().catchError((_) {});

  if (mounted) {
    Navigator.pushReplacementNamed(context, '/home');
  }
}

   Future<void> _startAudioOnTap() async {
    if (_audioStarted) return;
    _audioStarted = true;
    await AudioService.playSplash();
  }

  @override
  void dispose() {
    _scaleController?.dispose();
    _fadeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_scaleAnimation == null || _fadeAnimation == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return GestureDetector(        
    onTap: _startAudioOnTap,     
    behavior: HitTestBehavior.opaque,
    child: Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE), Color(0xFFDEFDE0)],
          ),
        ),
      
        child: Stack(
          children: [
            // Hiasan bunga-bunga terbang
            ...List.generate(15, (index) {
              return FloatingDecoration(
                key: ValueKey(index),
                icon: index % 3 == 0
                    ? Icons.local_florist
                    : (index % 3 == 1 ? Icons.eco : Icons.pets),
                color: index % 3 == 0
                    ? Colors.pink.shade200
                    : (index % 3 == 1
                          ? Colors.green.shade300
                          : Colors.orange.shade300),
                delay: index * 0.3,
              
              );
            
            }),

            // Logo
            Center(
              child: Transform.translate(
                offset: const Offset(0, -30), // ← minus = naik
                child: ScaleTransition(
                  scale: _scaleAnimation!,
                  child: Image.asset(
                    'images/logo_flofa.png',
                    width: 230,
                    height: 230,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // Loading
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnimation!,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.green.shade400,
                    ),
                    strokeWidth: 3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class FloatingDecoration extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double delay;

  const FloatingDecoration({
    super.key,
    required this.icon,
    required this.color,
    required this.delay,
  });

  @override
  State<FloatingDecoration> createState() => _FloatingDecorationState();
}

class _FloatingDecorationState extends State<FloatingDecoration>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  late double startX;
  late double startY;
  late double endY;

  @override
  void initState() {
    super.initState();
    final random = Random();
    startX = random.nextDouble() * 300;
    startY = -50;
    endY = 800;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4 + random.nextInt(3)),
    );

    Future.delayed(Duration(milliseconds: (widget.delay * 1000).toInt()), () {
      if (mounted && _controller != null) {
        _controller!.repeat();
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _controller!,
      builder: (context, child) {
        final offsetY = startY + (endY - startY) * _controller!.value;
        final offsetX = startX + sin(_controller!.value * 2 * pi * 2) * 30;

        return Positioned(
          left: offsetX,
          top: offsetY,
          child: Opacity(
            opacity: 0.6,
            child: Icon(widget.icon, color: widget.color, size: 24),
          ),
        );
      },
    );
  }
}

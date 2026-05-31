import 'package:app1/services/audio_service.dart';
import 'package:app1/start/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:app1/pengaturan/setting.dart';

//ini buat bagian masuk ke fitur(animasi keluar)
class masuk extends StatefulWidget {
  const masuk({super.key});

  @override
  State<masuk> createState() => _MasukState();
}

class _MasukState extends State<masuk> with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _menuController;
  late AnimationController _characterController;

  late Animation<Offset> _headerSlideAnimation;
  late Animation<double> _menuAnimation;
  late Animation<double> _characterAnimation;

  @override
  void initState() {
    super.initState();

    // Animasi header keluar ke atas
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _headerSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -2),
    ).animate(CurvedAnimation(parent: _headerController, curve: Curves.easeIn));

    // Animasi menu buttons fade out
    _menuController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _menuAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _menuController, curve: Curves.easeIn));

    // Animasi karakter keluar ke bawah
    _characterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _characterAnimation = Tween<double>(begin: 0, end: 300).animate(
      CurvedAnimation(parent: _characterController, curve: Curves.easeIn),
    );
  }

  // Method untuk trigger animasi keluar
  void _startExitAnimations() async {
    _menuController.forward();

    await Future.delayed(const Duration(milliseconds: 100));
    _characterController.forward();

    await Future.delayed(const Duration(milliseconds: 100));
    _headerController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    _menuController.dispose();
    _characterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bg_homepage.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Header bagian atas
            SlideTransition(
              position: _headerSlideAnimation,
              child: Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Image.asset(
                  L10n.headerImage(context), 
                  width: screenWidth,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),

            // Content
            SafeArea(
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.25),

                  Spacer(),

                  SizedBox(height: 70),

                  // Menu Buttons
                  FadeTransition(
                    opacity: _menuAnimation,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildMenuButton(
                              imagePath: 'images/btn_book.png',
                              onTap: () {
                                _startExitAnimations();
                                Future.delayed(
                                  const Duration(milliseconds: 500),
                                  () => Navigator.pushNamed(context, '/learn'),
                                );
                              },
                            ),
                            SizedBox(width: 42),
                            _buildMenuButton(
                              imagePath: 'images/btn_game.png',
                              onTap: () {
                                _startExitAnimations();
                                Future.delayed(
                                  const Duration(milliseconds: 500),
                                  () => Navigator.pushNamed(context, '/game'),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        _buildMenuButton(
                          imagePath: 'images/btn_settings.png',
                          onTap: () {
                            _startExitAnimations();
                            Future.delayed(
                              const Duration(milliseconds: 500),
                              () => Navigator.pushNamed(context, '/settings'),
                            );
                          },
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),

                  Spacer(),

                  // Karakter bawah
                  AnimatedBuilder(
                    animation: _characterAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _characterAnimation.value),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            onTap: () => AudioService.playBacksound(),
                            child: Image.asset(
                              'images/character_bottom.png',
                              width: screenWidth * 0.6,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Button tersembunyi POJOK KANAN ATAS
            Positioned(
              top: 0,
              right: 0,
              child: SafeArea(
                child: GestureDetector(
                  onTap: () {
                    print("Button diklik!"); 
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SplashScreen()),
                    );
                  },
                  child: Container(
                    width: 120,
                    height: 120,
                    // Uncomment untuk lihat area button
                    color: Colors.transparent,
                    //child: Center(
                    //child: Icon(Icons.close, color: Colors.white, size: 30),
                    //),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(imagePath, width: 65, height: 65, fit: BoxFit.contain),
    );
  }
}

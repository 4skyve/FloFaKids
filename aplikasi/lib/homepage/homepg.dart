import 'package:app1/homepage/homepg2.dart';
import 'package:app1/services/audio_service.dart';
import 'package:app1/start/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:app1/pengaturan/setting.dart';

class utama extends StatefulWidget {
  const utama({super.key});

  @override
  State<utama> createState() => _HomePageState();
}

class _HomePageState extends State<utama> with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _menuController;
  late AnimationController _characterController;

  late Animation<Offset> _headerSlideAnimation;
  late Animation<double> _menuAnimation;
  late Animation<double> _characterAnimation;

  @override
  void initState() {
    super.initState();

    // Animasi header (daun + monyet + title jadi 1)
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _headerSlideAnimation =
        Tween<Offset>(begin: const Offset(0, -2), end: Offset.zero).animate(
          CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
        );

    // Animasi menu buttons
    _menuController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _menuAnimation = CurvedAnimation(
      parent: _menuController,
      curve: Curves.easeInOut,
    );

    // Animasi karakter bawah
    _characterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _characterAnimation = Tween<double>(begin: 300, end: 0).animate(
      CurvedAnimation(parent: _characterController, curve: Curves.easeOut),
    );

    // Mulai semua animasi bertahap
    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _headerController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
    _characterController.forward();

    await Future.delayed(const Duration(milliseconds: 600));
    _menuController.forward();
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
            // Header bagian atas (GABUNG SEMUA: daun + monyet + title)
            SlideTransition(
              position: _headerSlideAnimation,
              child: Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Image.asset(
                  L10n.headerImage(context), // otomatis pilih versi bahasa
                  width: screenWidth,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),

            // Content
            SafeArea(
              child: Column(
                children: [
                  // Spacer buat header
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
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                        ) => masuk(),
                                    transitionDuration: Duration.zero,
                                  ),
                                );
                              },
                            ),
                            SizedBox(width: 42),
                            _buildMenuButton(
                              imagePath: 'images/btn_game.png',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                        ) => masuk(),
                                    transitionDuration: Duration.zero,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        // Button Belajar (Buku)
                        _buildMenuButton(
                          imagePath: 'images/btn_settings.png',
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        masuk(),
                                transitionDuration: Duration.zero,
                              ),
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
                            // ← tambah
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
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: GestureDetector(
        onTap: onTap,
        child: Image.asset(
          imagePath,
          width: 65,
          height: 65,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

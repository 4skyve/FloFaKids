import 'package:app1/services/audio_service.dart';
import 'package:app1/start/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:app1/homepage/homepg2.dart';
import 'package:app1/pengaturan/setting.dart';

//ini buat bagian keluar dari fitur
class kembali extends StatefulWidget {
  const kembali({super.key});

  @override
  State<kembali> createState() => _KembaliState();
}

class _KembaliState extends State<kembali> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _menuController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _menuScaleAnimation;

  @override
  void initState() {
    super.initState();

    // Animasi fade in semua elemen
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    // Animasi scale kecil menu buttons
    _menuController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _menuScaleAnimation = Tween<double>(
      begin: 0.95, 
      end: 1.0,
    ).animate(CurvedAnimation(parent: _menuController, curve: Curves.easeOut));

    // Mulai animasi
    _startAnimations();
  }

  void _startAnimations() async {
    _fadeController.forward();
    _menuController.forward(); // tdk delay
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _menuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFF3D5A3D),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
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
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Image.asset(
                  L10n.headerImage(context), // otomatis pilih versi bhsa
                  width: screenWidth,
                  fit: BoxFit.fitWidth,
                ),
              ),

              // Content
              SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.25),

                    Spacer(),

                    SizedBox(height: 70),

                    // Menu Buttons dgn scale animation kecil
                    ScaleTransition(
                      scale: _menuScaleAnimation,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildMenuButton(
                                imagePath: 'images/btn_book.png',
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                          ) => masuk(),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration: Duration.zero,
                                    ),
                                  );
                                },
                              ),
                              SizedBox(width: 42),
                              _buildMenuButton(
                                imagePath: 'images/btn_game.png',
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                          ) => masuk(),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration: Duration.zero,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          _buildMenuButton(
                            imagePath: 'images/btn_settings.png',
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                      ) => masuk(),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
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
                    Align(
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

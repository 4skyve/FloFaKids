import 'package:app1/kuis/kuis.dart';
import 'package:app1/kuis/level1.dart';
import 'package:app1/services/progress_service.dart';
import 'package:app1/pengaturan/setting.dart';
import 'package:flutter/material.dart';

class Level2Page extends StatefulWidget {
  const Level2Page({Key? key}) : super(key: key);

  @override
  State<Level2Page> createState() => _Level2PageState();
}

class _Level2PageState extends State<Level2Page> {
  List<int> starsPerLevel = List.filled(20, 0);
  int unlockedCount = 0; // 0 = semua terkunci sampai level1 page 1 slsai
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    // Level2Page mulai dari soal nomor 21-40 di Firestore
    // tapi progress key-nya pakai 'l2_1' sampai 'l2_20' biar ga bentrok
    List<int> stars = [];
    int unlocked = 0;

    // Cek apakah level2 sudah terbuka (atw level1 uda slsai)
    final level2Unlocked = await ProgressService.isUnlocked(21);
    if (level2Unlocked) unlocked = 1;

    for (int i = 21; i <= 40; i++) {
      final s = await ProgressService.getStars(i);
      stars.add(s);
      final isUnlocked = await ProgressService.isUnlocked(i);
      if (isUnlocked && (i - 20) > unlocked) unlocked = i - 20;
    }

    setState(() {
      starsPerLevel = stars;
      unlockedCount = unlocked;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Home icon
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/kembali'),
                    child: const Icon(
                      Icons.home_filled,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 35),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const Level1Page(),
                        transitionsBuilder: (_, anim, __, child) =>
                            FadeTransition(opacity: anim, child: child),
                        transitionDuration: const Duration(milliseconds: 200),
                      ),
                    ),
                    child: Image.asset(
                      'images/arrow_left.png',
                      width: 35,
                      height: 35,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFC8E6A0), Color(0xFFA8D67E)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Level',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D6644),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppScope.of(context).language == AppLanguage.english
                              ? 'Level 3 not available yet'
                              : 'Level 3 belum tersedia',
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    ),
                    child: Image.asset(
                      'images/arrow_right.png',
                      width: 35,
                      height: 35,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 35),

              // Grid
              isLoading
                  ? const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    )
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1,
                              ),
                          itemCount: 20,
                          itemBuilder: (context, index) {
                            final levelNum = index + 1; // tampilan 1-20
                            final firestoreLevel = index + 21; // soal 21-40
                            final isUnlocked = levelNum <= unlockedCount;
                            final stars = starsPerLevel[index];

                            return GestureDetector(
                              onTap: () {
                                if (isUnlocked) {
                                  _playLevel(context, firestoreLevel);
                                } else {
                                  _showLockedMessage(context);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: isUnlocked
                                        ? [
                                            const Color(0xFF9ACB70),
                                            const Color(0xFF74A94F),
                                          ]
                                        : [
                                            const Color(0xFF7FAF97),
                                            const Color(0xFF5E8E77),
                                          ],
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    isUnlocked
                                        ? Text(
                                            '$levelNum',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF2D6644),
                                            ),
                                          )
                                        : Icon(
                                            Icons.lock,
                                            color: Colors.white.withOpacity(
                                              0.7,
                                            ),
                                            size: 24,
                                          ),
                                    if (isUnlocked && stars > 0)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(
                                          3,
                                          (j) => Icon(
                                            Icons.star,
                                            size: 10,
                                            color: j < stars
                                                ? Colors.orange
                                                : Colors.white30,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _playLevel(BuildContext context, int firestoreLevel) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => QuizPage(level: firestoreLevel)),
    );
    _loadProgress(); // refresh bintang setelah selesai
  }

  void _showLockedMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(L10n.locked(context)),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.orange,
      ),
    );
  }
}

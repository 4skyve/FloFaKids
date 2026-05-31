import 'package:app1/services/progress_service.dart';
import 'package:flutter/material.dart';
import 'package:app1/kuis/kuis.dart';

class LevelSelectPage extends StatefulWidget {
  const LevelSelectPage({super.key});

  @override
  State<LevelSelectPage> createState() => _LevelSelectPageState();
}

class _LevelSelectPageState extends State<LevelSelectPage> {
  // Data tiap level: [unlocked, stars]
  List<Map<String, dynamic>> levelData = [];
  bool isLoading = true;
  final int totalLevels = 3; // ganti angka ini kalau nambah level y

  @override
  void initState() {
    super.initState();
    _loadLevels();
  }

  Future<void> _loadLevels() async {
    List<Map<String, dynamic>> data = [];
    for (int i = 1; i <= totalLevels; i++) {
      final unlocked = await ProgressService.isUnlocked(i);
      final stars = await ProgressService.getStars(i);
      final score = await ProgressService.getScore(i);
      data.add({
        'level': i,
        'unlocked': unlocked,
        'stars': stars,
        'score': score,
      });
    }
    setState(() {
      levelData = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('images/background.png', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'Pilih Level',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Grid level
                isLoading
                    ? const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      )
                    : Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(20),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: levelData.length,
                          itemBuilder: (context, i) {
                            final data = levelData[i];
                            final bool unlocked = data['unlocked'];
                            final int stars = data['stars'];
                            final int level = data['level'];

                            return GestureDetector(
                              onTap: unlocked
                                  ? () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              QuizPage(level: level),
                                        ),
                                      );
                                      _loadLevels(); // refresh bintang setelah main
                                    }
                                  : null, // null = gbs ditekan
                              child: Container(
                                decoration: BoxDecoration(
                                  color: unlocked
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Ikon gembok kalo terkunci
                                    Icon(
                                      unlocked ? Icons.play_circle_fill : Icons.lock,
                                      size: 40,
                                      color: unlocked
                                          ? Colors.green
                                          : Colors.white,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Level $level',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: unlocked
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Bintang
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(
                                        3,
                                        (j) => Icon(
                                          Icons.star,
                                          size: 22,
                                          color: j < stars
                                              ? Colors.orange
                                              : Colors.grey.shade300,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:app1/services/audio_service.dart';
import 'package:app1/services/firebase_service.dart';
import 'package:app1/services/progress_service.dart';
import 'package:app1/pengaturan/setting.dart';
import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  final int level;

  const QuizPage({super.key, this.level = 1});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int index = 0;
  int selectedIndex = -1;
  int score = 0;
  bool showResult = false;
  bool isLoading = true;
  bool _isInit = false;

  List<Map<String, dynamic>> questions = [];
  late int level;

  @override
  void initState() {
    super.initState();
    level = widget.level;
    // Delay satu frame biar context siap
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadQuestions();
    });
  }

  Future<void> _loadQuestions() async {
    try {
      final lang = AppScope.of(context).language;

      print(' Mulai fetch...');
      final stopwatch = Stopwatch()..start();

      final data = lang == AppLanguage.english
          ? await FirebaseService.getQuestionsEn(level)
          : await FirebaseService.getQuestions(level);

      stopwatch.stop();

      print(
        ' Selesai fetch: ${stopwatch.elapsedMilliseconds}ms, dapat ${data.length} soal',
      );

      setState(() {
        questions = data;
        isLoading = false;
      });
    } catch (e) {
      print(' ERROR LOAD QUESTION: $e');

      setState(() {
        isLoading = false;
      });
    }
  }

  void selectAnswer(int i) {
    if (selectedIndex == -1) {
      setState(() {
        selectedIndex = i;
        showResult = true;

        if (i == questions[index]["answer"]) {
          score++;
          AudioService.playCorrect();
        } else {
          AudioService.playWrong();
        }
      });
    }
  }

  void nextQuestion() {
    setState(() {
      showResult = false;
      selectedIndex = -1;

      if (index < questions.length - 1) {
        index++;
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ScorePage(score: score, total: questions.length, level: level),
          ),
        ).then((value) {
          if (value == true) {
            setState(() {
              level++;
              index = 0;
              score = 0;
              isLoading = true;
              _loadQuestions();
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset('images/background.png', fit: BoxFit.cover),
            ),
            const Center(child: CircularProgressIndicator(color: Colors.white)),
          ],
        ),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset('images/background.png', fit: BoxFit.cover),
            ),
            const Center(
              child: Text(
                'Soal tidak ditemukan.\nCek koneksi internet kamu.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      );
    }

    double progress = (index + 1) / questions.length;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('images/background.png', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/game'),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Color(0xFF2A4C36),
                            size: 18,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        L10n.level(context, level),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: Colors.white,
                    color: Colors.green,
                  ),

                  const SizedBox(height: 20),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 1),
                          end: Offset.zero,
                        ).animate(animation),
                        child: FadeTransition(opacity: animation, child: child),
                      );
                    },
                    child: Stack(
                      key: ValueKey(index),
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            questions[index]["question"],
                            style: const TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.lightGreen,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            L10n.question(context, index + 1, questions.length),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  Column(
                    children: List.generate(
                      questions[index]["options"].length,
                      (i) {
                        Color color = Colors.white;

                        if (selectedIndex != -1) {
                          if (i == questions[index]["answer"]) {
                            color = Colors.green;
                          } else if (i == selectedIndex) {
                            color = Colors.red;
                          }
                        }

                        return GestureDetector(
                          onTap: () => selectAnswer(i),
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: Text(
                                questions[index]["options"][i],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (showResult)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
                  width: 280,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: selectedIndex == questions[index]["answer"]
                        ? Colors.green
                        : Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        selectedIndex == questions[index]["answer"]
                            ? Icons.check_circle
                            : Icons.cancel,
                        size: 80,
                        color: Colors.white,
                      ),

                      const SizedBox(height: 10),

                      Text(
                        selectedIndex == questions[index]["answer"]
                            ? L10n.correct(context)
                            : L10n.wrong(context),
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: nextQuestion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: Text(
                          L10n.next(context),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

//  hal skor

class ScorePage extends StatefulWidget {
  final int score;
  final int total;
  final int level;

  const ScorePage({
    super.key,
    required this.score,
    required this.total,
    required this.level,
  });

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _saveProgress();

    AudioService.playWin();
  }

  Future<void> _saveProgress() async {
    final s = stars;

    await ProgressService.saveScore(widget.level, widget.score);

    await ProgressService.saveStars(widget.level, s);

    await ProgressService.unlockLevel(widget.level + 1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get stars {
    double percent = widget.score / widget.total;

    if (percent >= 0.8) return 3;
    if (percent >= 0.5) return 2;

    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('images/background.png', fit: BoxFit.cover),
          ),

          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(painter: ConfettiPainter(_controller.value));
              },
            ),
          ),

          Center(
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.yellow.shade400,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    L10n.levelUp(context),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (i) => Icon(
                        Icons.star,
                        size: 50,
                        color: i < stars ? Colors.orange : Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    L10n.score(context, widget.score, widget.total),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(L10n.next(context)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// confetti akhir kuis

class ConfettiPainter extends CustomPainter {
  final double progress;

  ConfettiPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    for (int i = 0; i < 40; i++) {
      double x = (size.width / 40) * i;
      double y = (size.height * progress + i * 25) % size.height;

      canvas.drawCircle(Offset(x, y), 4, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

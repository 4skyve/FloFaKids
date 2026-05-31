import 'package:app1/services/audio_service.dart';
import 'package:flutter/material.dart';

class pengaturan extends StatefulWidget {
  const pengaturan({super.key});

  @override
  State<pengaturan> createState() => _SettingsPopupState();
}

class _SettingsPopupState extends State<pengaturan> {
  double soundVolume = 0.5;
  double musicVolume = 0.5;
  AppLanguage language = AppLanguage.indonesian;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final settings = AppScope.of(context);
    soundVolume = settings.sfx;
    musicVolume = settings.music;
    language = settings.language;
  }

  void nextLanguage() {
    setState(() {
      language =
          AppLanguage.values[(language.index + 1) % AppLanguage.values.length];
    });
  }

  void prevLanguage() {
    setState(() {
      language =
          AppLanguage.values[(language.index - 1 + AppLanguage.values.length) %
              AppLanguage.values.length];
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = AppScope.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'images/background.png',
            ), 
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: screenWidth * 0.85,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE8C7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.brown, width: 3),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// TITLE
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 37, 196, 45),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        L10n.settings(context).toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// SOUND SLIDER
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.volume_up,
                            size: 32,
                            color: Colors.brown,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Colors.green,
                                inactiveTrackColor: Colors.green.withOpacity(
                                  0.3,
                                ),
                                thumbColor: Colors.green,
                                overlayColor: Colors.green.withOpacity(0.2),
                              ),
                              child: Slider(
                                value: soundVolume,
                                min: 0,
                                max: 1,
                                onChanged: (value) {
                                  setState(() {
                                    soundVolume = value;
                                  });
                                  AudioService.setSfxVolume(
                                    value,
                                  ); // ← tambah ini
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// MUSIC SLIDER
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.music_note,
                            size: 32,
                            color: Colors.brown,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Colors.green,
                                inactiveTrackColor: Colors.green.withOpacity(
                                  0.3,
                                ),
                                thumbColor: Colors.green,
                                overlayColor: Colors.green.withOpacity(0.2),
                              ),
                              child: Slider(
                                value: musicVolume,
                                min: 0,
                                max: 1,
                                onChanged: (value) {
                                  setState(() {
                                    musicVolume = value;
                                  });
                                  AudioService.setMusicVolume(
                                    value,
                                  ); // ← tambah ini
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // buat plh bahasa
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: prevLanguage,
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.brown,
                          ),
                          iconSize: 24,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(), 
                        ),
                        const SizedBox(width: 8), 
                        Flexible(
                        
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16, 
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              L10n.langLabel(language).toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14, 
                              ),
                              textAlign: TextAlign.center, 
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8), 
                        IconButton(
                          onPressed: nextLanguage,
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.brown,
                          ),
                          iconSize: 24, 
                          padding: EdgeInsets.zero, 
                          constraints: const BoxConstraints(), 
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    /// BUTTONS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/home2',
                                  (route) => false,
                                );
                              },
                              child: Text(
                                L10n.cancel(context).toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () async {
                                await settings.setSfx(soundVolume);
                                await settings.setMusic(musicVolume);
                                await settings.setLanguage(language);
                                AudioService.setSfxVolume(soundVolume);
                                AudioService.setMusicVolume(musicVolume);
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/home2',
                                  (route) => false,
                                );
                              },
                              child: Text(
                                L10n.save(context).toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum AppLanguage { english, indonesian }

class AppScope extends InheritedWidget {
  final double sfx;
  final double music;
  final AppLanguage language;
  final Future<void> Function(double) setSfx;
  final Future<void> Function(double) setMusic;
  final Future<void> Function(AppLanguage) setLanguage;

  const AppScope({
    Key? key,
    required this.sfx,
    required this.music,
    required this.language,
    required this.setSfx,
    required this.setMusic,
    required this.setLanguage,
    required Widget child,
  }) : super(key: key, child: child);

  static AppScope of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppScope>()!;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) {
    return sfx != oldWidget.sfx ||
        music != oldWidget.music ||
        language != oldWidget.language;
  }
}

class L10n {
  //  Deteksi bahasa
  static AppLanguage _lang(BuildContext context) {
    return AppScope.of(context).language;
  }
  static String headerImage(BuildContext context) =>
    _lang(context) == AppLanguage.english
        ? 'images/header_top_en.png'
        : 'images/header_top.png';

  // penyesuaian bhs nya

  static String settings(BuildContext context) =>
      _lang(context) == AppLanguage.english ? 'Settings' : 'Pengaturan';

  static String cancel(BuildContext context) =>
      _lang(context) == AppLanguage.english ? 'Cancel' : 'Batal';

  static String save(BuildContext context) =>
      _lang(context) == AppLanguage.english ? 'Save' : 'Simpan';

  // homepg
  static String play(BuildContext context) =>
      _lang(context) == AppLanguage.english ? 'Play' : 'Bermain';

  static String learn(BuildContext context) =>
      _lang(context) == AppLanguage.english ? 'Learn' : 'Belajar';

  // kuis
  static String question(BuildContext context, int current, int total) =>
      _lang(context) == AppLanguage.english
          ? 'Question $current of $total'
          : 'Soal $current dari $total';

  static String level(BuildContext context, int n) =>
      _lang(context) == AppLanguage.english ? 'Level $n' : 'Level $n';

  static String correct(BuildContext context) =>
      _lang(context) == AppLanguage.english ? 'CORRECT!' : 'BENAR!';

  static String wrong(BuildContext context) =>
      _lang(context) == AppLanguage.english ? 'WRONG!' : 'SALAH!';

  static String next(BuildContext context) =>
      _lang(context) == AppLanguage.english ? 'Next' : 'Lanjut';

  static String score(BuildContext context, int s, int total) =>
      _lang(context) == AppLanguage.english
          ? 'Score: $s / $total'
          : 'Skor: $s / $total';

  static String levelUp(BuildContext context) =>
      _lang(context) == AppLanguage.english ? 'LEVEL UP!' : 'LEVEL NAIK!';

  // Level yg masi lock 
  static String locked(BuildContext context) =>
      _lang(context) == AppLanguage.english
          ? 'Level is locked!'
          : 'Level ini masih terkunci!';

  // bacaan
  static String read(BuildContext context) =>
      _lang(context) == AppLanguage.english ? 'READ' : 'BACA';

  static String playButton(BuildContext context) =>
      _lang(context) == AppLanguage.english ? "Let's Play!" : 'Mari Bermain!';

  // HalBuku
  static String flora(BuildContext context) =>
      _lang(context) == AppLanguage.english ? 'Flora' : 'Flora';

  static String fauna(BuildContext context) =>
      _lang(context) == AppLanguage.english ? 'Fauna' : 'Fauna';

  // Label bahasa
  static String langLabel(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.indonesian:
        return 'Indonesian';
    }
  }
}
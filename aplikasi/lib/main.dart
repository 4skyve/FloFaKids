import 'package:app1/homepage/homepg.dart';
import 'package:app1/homepage/homepg2.dart';
import 'package:app1/bacaan/Halbuku.dart';
import 'package:app1/homepage/homepg3.dart';
import 'package:app1/kuis/level1.dart';
import 'package:app1/pengaturan/setting.dart';
import 'package:app1/services/firebase_service.dart';
import 'package:app1/start/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/audio_service.dart';
import 'package:app1/kuis/level_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final musicVol = prefs.getDouble('music') ?? 0.5;
  final sfxVol = prefs.getDouble('sfx') ?? 0.5;
  await AudioService.init();
  await AudioService.setMusicVolume(musicVol);
  await AudioService.setSfxVolume(sfxVol);
  FirebaseService.clearCache(); // ← tambah ini
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // State untuk pengaturan
  double sfxVolume = 0.5;
  double musicVolume = 0.5;
  AppLanguage currentLanguage = AppLanguage.indonesian;

  Future<void> updateSfx(double value) async {
    setState(() {
      sfxVolume = value;
    });
    // TODO: Simpan ke SharedPreferences jika perlu
  }

  Future<void> updateMusic(double value) async {
    setState(() {
      musicVolume = value;
    });
    // TODO: Simpan ke SharedPreferences jika perlu
  }

  Future<void> updateLanguage(AppLanguage lang) async {
    setState(() {
      currentLanguage = lang;
    });
    // TODO: Simpan ke SharedPreferences jika perlu
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      sfx: sfxVolume,
      music: musicVolume,
      language: currentLanguage,
      setSfx: updateSfx,
      setMusic: updateMusic,
      setLanguage: updateLanguage,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FloraKids',
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/home': (context) => const utama(),
          '/home2': (context) => const kembali(),
          '/masuk': (context) => const masuk(),
          '/kembali': (context) => const kembali(),
          '/learn': (context) => const florafauna(),
          '/game': (context) => const Level1Page(),
          '/settings': (context) => const pengaturan(),
        },
      ),
    );
  }
}

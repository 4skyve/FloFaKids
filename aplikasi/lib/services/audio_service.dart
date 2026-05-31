import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static AudioPlayer? _musicPlayer;
  static AudioPlayer? _sfxPlayer;

  static double _musicVolume = 0.5;
  static double _sfxVolume = 0.5;

  // Init player (dipanggil di main)
  static Future<void> init() async {
    _musicPlayer = AudioPlayer();
    _sfxPlayer = AudioPlayer();
    await _musicPlayer!.setVolume(_musicVolume);
    await _sfxPlayer!.setVolume(_sfxVolume);
  }

  // ── Backsound ──
  static Future<void> playBacksound() async {
    if (_musicPlayer == null) await init();
    await _musicPlayer!.setReleaseMode(ReleaseMode.loop);
    await _musicPlayer!.setVolume(_musicVolume);
    await _musicPlayer!.play(AssetSource('audio/backsound.mp3'));
  }

  // ── Splash sound ──
  static Future<void> playSplash() async {
    if (_musicPlayer == null) await init();
    await _musicPlayer!.setReleaseMode(ReleaseMode.stop);
    await _musicPlayer!.setVolume(_musicVolume);
    await _musicPlayer!.play(AssetSource('audio/splash.mp3'));
  }

  static Future<void> stopMusic() async {
    await _musicPlayer?.stop();
  }

  static Future<void> pauseMusic() async {
    await _musicPlayer?.pause();
  }

  static Future<void> resumeMusic() async {
    await _musicPlayer?.resume();
  }

  // ── SFX ──
  static Future<void> playCorrect() async {
    if (_sfxPlayer == null) await init();
    final player = AudioPlayer(); 
    await player.setVolume(_sfxVolume);
    await player.play(AssetSource('audio/correct.mp3'));
    player.onPlayerComplete.listen((_) => player.dispose());
  }

  static Future<void> playWrong() async {
    if (_sfxPlayer == null) await init();
    final player = AudioPlayer();
    await player.setVolume(_sfxVolume);
    await player.play(AssetSource('audio/wrong.mp3'));
    player.onPlayerComplete.listen((_) => player.dispose());
  }

  static Future<void> playWin() async {
    if (_sfxPlayer == null) await init();
    final player = AudioPlayer();
    await player.setVolume(_sfxVolume);
    await player.play(AssetSource('audio/score.mp3'));
    player.onPlayerComplete.listen((_) => player.dispose());
  }

  // ── Volume ──
  static Future<void> setMusicVolume(double volume) async {
    _musicVolume = volume;
    await _musicPlayer?.setVolume(volume);
  }

  static Future<void> setSfxVolume(double volume) async {
    _sfxVolume = volume;
  }
}
import 'package:audioplayers/audioplayers.dart';

class AudioUtil {
  static final AudioPlayer _soundAudioPlayer = AudioPlayer();
  static final AudioPlayer _backgroundAudioPlayer = AudioPlayer();
  static bool _isPlaying = false;
  static String _currentFile = '';

  // used for Sound modules, word modules use google_tts_util
  static Future<void> playSound(String audioFilePath) async {
    await _soundAudioPlayer.play(AssetSource(audioFilePath));
  }

  static Future<void> toggleBackgroundSound(String audioFilePath) async {
    if (_isPlaying && _currentFile == audioFilePath) {
      await _backgroundAudioPlayer.stop();
      _isPlaying = false;

    } else {
      await _backgroundAudioPlayer.play(AssetSource(audioFilePath));
      _isPlaying = true;
      _currentFile = audioFilePath;
    }
  }

  static Future<void> stopAll() async {
    await _soundAudioPlayer.stop();

    if (_isPlaying = true) {
      await _backgroundAudioPlayer.stop();
      _isPlaying = false; 
    }
    _currentFile = ''; 
  }
}

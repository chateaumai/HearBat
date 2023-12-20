import 'package:audioplayers/audioplayers.dart';

class AudioUtil {
  static final AudioPlayer _wordAudioPlayer = AudioPlayer();
  static final AudioPlayer _backgroundAudioPlayer = AudioPlayer();
  static bool _isPlaying = false;
  static String _currentFile = '';

  static Future<void> playWordSound(String audioFilePath) async {
    await _wordAudioPlayer.play(AssetSource(audioFilePath));
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
}

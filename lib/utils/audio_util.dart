import 'package:audioplayers/audioplayers.dart';

class AudioUtil {
  static final AudioPlayer _soundAudioPlayer = AudioPlayer();

  // used for Sound modules, word modules use google_tts_util
  static Future<void> playSound(String audioFilePath) async {
    await _soundAudioPlayer.play(AssetSource(audioFilePath));
  }

  static Future<void> stop() async {
    await _soundAudioPlayer.stop();
  }
}

import 'package:audioplayers/audioplayers.dart';

// Utility for handling audio playback in Sound modules.
class AudioUtil {
  static final AudioPlayer _soundAudioPlayer = AudioPlayer();

  // used for Sound modules, word modules use google_tts_util
  static Future<void> playSound(String audioFilePath) async {
    await _soundAudioPlayer.play(AssetSource(audioFilePath));
  }

  // Stops any currently playing audio.
  static Future<void> stop() async {
    await _soundAudioPlayer.stop();
  }
}

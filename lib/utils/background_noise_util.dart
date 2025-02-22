import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundNoiseUtil {
  static final AudioPlayer _audioPlayer = AudioPlayer()
  ..setReleaseMode(ReleaseMode.loop);

  static Future<void> initialize() async {
  await _audioPlayer.setPlayerMode(PlayerMode.mediaPlayer);
  // Need this so that the audio doesn't get taken over from other audio players
  await _audioPlayer.setAudioContext(AudioContext(
    android: AudioContextAndroid(
      isSpeakerphoneOn: false,
      stayAwake: false,
      contentType: AndroidContentType.music,
      usageType: AndroidUsageType.media,
      audioFocus: AndroidAudioFocus.none, 
    ),
    iOS: AudioContextIOS(
      category: AVAudioSessionCategory.playback,
        options: {
          AVAudioSessionOptions.mixWithOthers, 
        },
      ),
    ));
  }

  // Plays the saved background sound based on user preference.
  static Future<void> playSavedSound() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? backgroundSound = prefs.getString('backgroundSoundPreference');
    String? audioVolume = prefs.getString('audioVolumePreference');

    if (backgroundSound != null && backgroundSound != 'None') {
      String fileName = backgroundSound.replaceAll(' Sound', '').toLowerCase();
      await _adjustVolume(audioVolume);
      await _audioPlayer.play(
        AssetSource("audio/background/$fileName.mp3"),
      );
    }
  }

  // Stops the currently playing background sound.
  static Future<void> stopSound() async {
    await _audioPlayer.stop();
  }

  // Adjusts the volume level based on user preference.
  static Future<void> _adjustVolume(String? volumeLevel) async {
    switch (volumeLevel) {
      case 'Low':
        _audioPlayer.setVolume(0.2);
      case 'Medium':
        _audioPlayer.setVolume(0.6);
      case 'High':
        _audioPlayer.setVolume(1.0);
      default:
        _audioPlayer.setVolume(0.2);
    }
  }
}

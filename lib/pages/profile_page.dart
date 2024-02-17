import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import '../utils/google_tts_util.dart';

class GlobalAudioPlayer {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static final GlobalAudioPlayer _instance = GlobalAudioPlayer._internal();

  factory GlobalAudioPlayer() {
    return _instance;
  }

  GlobalAudioPlayer._internal();

  static AudioPlayer get player => _audioPlayer;

  void playSound(String filePath, {bool loop = false}) async {
    await _audioPlayer.setSourceAsset(filePath);
    await _audioPlayer
        .setReleaseMode(loop ? ReleaseMode.loop : ReleaseMode.stop);
    await _audioPlayer.resume();
  }

  void stopSound() async {
    await _audioPlayer.stop();
  }

  void setVolume(double volume) async {
    await _audioPlayer.setVolume(volume);
  }
}

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  String? _voicePreference;
  final GoogleTTSUtil _googleTTSUtil = GoogleTTSUtil();
  bool isCaching = false;
  double _currentVolume = 1.0;

  List<String> voiceTypes = [
    "en-US-Studio-O",
    "en-US-Neural2-C",
    "en-GB-Neural2-C",
    "en-IN-Neural2-A",
    "en-AU-Neural2-C",
    "en-US-Studio-Q",
    "en-US-Neural2-D",
    "en-GB-Neural2-B",
    "en-IN-Neural2-B",
    "en-AU-Neural2-B",
  ];

  Map<String, String> voiceTypeTitles = {
    "en-US-Studio-O": "US1 Female",
    "en-US-Neural2-C": "US2 Female",
    "en-GB-Neural2-C": "UK Female",
    "en-IN-Neural2-A": "IN Female",
    "en-AU-Neural2-C": "AU Female",
    "en-US-Studio-Q": "US1 Male",
    "en-US-Neural2-D": "US2 Male",
    "en-GB-Neural2-B": "UK Male",
    "en-IN-Neural2-B": "IN Male",
    "en-AU-Neural2-B": "AU Male",
  };

  @override
  void initState() {
    super.initState();
    _loadVoicePreference();
    _cacheVoiceTypes();
  }

  _loadVoicePreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _voicePreference = prefs.getString('voicePreference') ?? "en-US-Studio-O";
    });
  }

  _updateVoicePreference(String voiceType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _voicePreference = voiceType;
      prefs.setString('voicePreference', voiceType);
    });
  }

  Future<void> _cacheVoiceTypes() async {
    setState(() {
      isCaching = true;
    });

    String phraseToCache = "Hello this is how I sound";

    List<Future> downloadFutures = [];

    for (String voiceType in voiceTypes) {
      downloadFutures.add(
          _googleTTSUtil.downloadMP3(phraseToCache, voiceType).catchError((e) {
        print("Error downloading for voice type $voiceType: $e");
      }));
    }

    await Future.wait(downloadFutures);

    setState(() {
      isCaching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Select Voice Type",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_voicePreference != null) {
                    _googleTTSUtil.speak(
                        "Hello this is how I sound", _voicePreference!);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please select a voice preference first"),
                      ),
                    );
                  }
                },
                child: Text('Test Audio'),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      for (int i = 0; i < 5; i++)
                        ListTile(
                          title: Text(voiceTypeTitles[voiceTypes[i]] ?? ""),
                          leading: Radio<String>(
                            value: voiceTypes[i],
                            groupValue: _voicePreference,
                            onChanged: _voicePreference == null
                                ? null
                                : (String? value) {
                                    _updateVoicePreference(value!);
                                  },
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      for (int i = 5; i < 10; i++)
                        ListTile(
                          title: Text(voiceTypeTitles[voiceTypes[i]] ?? ""),
                          leading: Radio<String>(
                            value: voiceTypes[i],
                            groupValue: _voicePreference,
                            onChanged: _voicePreference == null
                                ? null
                                : (String? value) {
                                    _updateVoicePreference(value!);
                                  },
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            Slider(
              value: _currentVolume,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              label: "${(_currentVolume * 100).toInt()}%",
              onChanged: (double value) {
                setState(() {
                  _currentVolume = value;
                  GlobalAudioPlayer().setVolume(_currentVolume);
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                GlobalAudioPlayer()
                    .playSound("audio/background/rain.mp3", loop: true);
              },
              child: Text('Play Rain Sound'),
            ),
            ElevatedButton(
              onPressed: () {
                GlobalAudioPlayer()
                    .playSound("audio/background/shop.mp3", loop: true);
              },
              child: Text('Play Shop Sound'),
            ),
            ElevatedButton(
              onPressed: () {
                GlobalAudioPlayer().stopSound();
              },
              child: Text('Stop Sound'),
            ),
          ],
        ),
      ),
    );
  }
}

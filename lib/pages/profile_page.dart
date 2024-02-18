import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import '../utils/google_tts_util.dart';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  String? _voicePreference;
  String _backgroundSound = 'None';
  String _audioVolume = 'Low';
  final GoogleTTSUtil _googleTTSUtil = GoogleTTSUtil();
  bool isCaching = false;
  AudioPlayer audioPlayer = AudioPlayer();

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
    _loadPreferences();
    _cacheVoiceTypes();
    audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  void _loadPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _voicePreference = prefs.getString('voicePreference') ?? "en-US-Studio-O";
      _backgroundSound = prefs.getString('backgroundSoundPreference') ?? 'None';
      _audioVolume = prefs.getString('audioVolumePreference') ?? 'Low';
    });
  }

  void _updatePreference(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
    _loadPreferences();
  }

  Future<void> _cacheVoiceTypes() async {
    setState(() {
      isCaching = true;
    });
    String phraseToCache = "Hello this is how I sound";
    List<Future> downloadFutures = [];
    for (String voiceType in voiceTypes) {
      downloadFutures.add(_googleTTSUtil
          .downloadMP3(phraseToCache, voiceType)
          .catchError((e) {}));
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Select Voice Type",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (_voicePreference != null) {
                  _googleTTSUtil.speak(
                      "Hello this is how I sound", _voicePreference!);
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
                          onChanged: (String? value) {
                            _updatePreference('voicePreference', value!);
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
                          onChanged: (String? value) {
                            _updatePreference('voicePreference', value!);
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Select Background Sound",
                style: Theme.of(context).textTheme.titleLarge),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_backgroundSound != 'None') {
                String fileName =
                    _backgroundSound.replaceAll(' Sound', '').toLowerCase();
                await audioPlayer
                    .play(AssetSource("audio/background/$fileName.mp3"));
                await Future.delayed(Duration(seconds: 3));
                await audioPlayer.stop();
              }
            },
            child: Text('Test Background Noise'),
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Rain Sound'),
                      leading: Radio<String>(
                        value: 'Rain Sound',
                        groupValue: _backgroundSound,
                        onChanged: (String? value) {
                          _updatePreference(
                              'backgroundSoundPreference', value!);
                        },
                      ),
                    ),
                    ListTile(
                      title: Text('Shop Sound'),
                      leading: Radio<String>(
                        value: 'Shop Sound',
                        groupValue: _backgroundSound,
                        onChanged: (String? value) {
                          _updatePreference(
                              'backgroundSoundPreference', value!);
                        },
                      ),
                    ),
                    ListTile(
                      title: Text('None'),
                      leading: Radio<String>(
                        value: 'None',
                        groupValue: _backgroundSound,
                        onChanged: (String? value) {
                          _updatePreference(
                              'backgroundSoundPreference', value!);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Low'),
                      leading: Radio<String>(
                        value: 'Low',
                        groupValue: _audioVolume,
                        onChanged: (String? value) {
                          _updatePreference('audioVolumePreference', value!);
                        },
                      ),
                    ),
                    ListTile(
                      title: Text('Medium'),
                      leading: Radio<String>(
                        value: 'Medium',
                        groupValue: _audioVolume,
                        onChanged: (String? value) {
                          _updatePreference('audioVolumePreference', value!);
                        },
                      ),
                    ),
                    ListTile(
                      title: Text('High'),
                      leading: Radio<String>(
                        value: 'High',
                        groupValue: _audioVolume,
                        onChanged: (String? value) {
                          _updatePreference('audioVolumePreference', value!);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

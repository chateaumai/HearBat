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
    _loadVoicePreference();
    _cacheVoiceTypes();
    audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  @override
  void dispose() {
    audioPlayer.stop();
    super.dispose();
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
      body: Column(
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
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Please select a voice preference first"),
                  ));
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
                          onChanged: (String? value) {
                            _updateVoicePreference(value!);
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
            child: Text(
              "Select Background Sounds",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              switch (_backgroundSound) {
                case 'Rain Sound':
                  await audioPlayer
                      .play(AssetSource("audio/background/rain.mp3"));
                  break;
                case 'Shop Sound':
                  await audioPlayer
                      .play(AssetSource("audio/background/shop.mp3"));
                  break;
                case 'None':
                  audioPlayer.stop();
                  break;
              }
              if (_backgroundSound != 'None') {
                await Future.delayed(Duration(seconds: 5));
                await audioPlayer.stop();
              }
            },
            child: Text('Test Background Noise'),
          ),
          ListTile(
            title: Text('Rain Sound'),
            leading: Radio<String>(
              value: 'Rain Sound',
              groupValue: _backgroundSound,
              onChanged: (String? value) {
                setState(() {
                  _backgroundSound = value!;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Shop Sound'),
            leading: Radio<String>(
              value: 'Shop Sound',
              groupValue: _backgroundSound,
              onChanged: (String? value) {
                setState(() {
                  _backgroundSound = value!;
                });
              },
            ),
          ),
          ListTile(
            title: Text('None'),
            leading: Radio<String>(
              value: 'None',
              groupValue: _backgroundSound,
              onChanged: (String? value) {
                setState(() {
                  _backgroundSound = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

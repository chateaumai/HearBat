import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hearbat/data/answer_pair.dart';
import 'package:hearbat/widgets/top_bar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import '../module/module_widget.dart';
import 'package:hearbat/utils/cache_words_util.dart';

class DifficultySelectionWidget extends StatefulWidget {
  final String moduleName;
  final List<AnswerGroup> answerGroups;

  DifficultySelectionWidget(
      {required this.moduleName, required this.answerGroups});

  @override
  DifficultySelectionWidgetState createState() =>
      DifficultySelectionWidgetState();
}

class DifficultySelectionWidgetState extends State<DifficultySelectionWidget> {
  String _difficulty = 'Normal';
  String _backgroundSound = 'None';
  String _audioVolume = 'Low';
  final CacheWordsUtil cacheUtil = CacheWordsUtil();
  bool isCaching = false;
  AudioPlayer audioPlayer = AudioPlayer();
  String? _voiceType;

  List<String> voiceTypes = [
    "en-US-Studio-O",
    // "en-US-Neural2-C",
    "en-GB-Neural2-C",
    "en-IN-Neural2-A",
    "en-AU-Neural2-C",
    "en-US-Studio-Q",
    // "en-US-Neural2-D",
    "en-GB-Neural2-B",
    "en-IN-Neural2-B",
    "en-AU-Neural2-B",
  ];

  Map<String, String> voiceTypeTitles = {
    "en-US-Studio-O": "US Female",
    //"en-US-Neural2-C": "US2 Female",
    "en-GB-Neural2-C": "UK Female",
    "en-IN-Neural2-A": "IN Female",
    "en-AU-Neural2-C": "AU Female",
    "en-US-Studio-Q": "US Male",
    // "en-US-Neural2-D": "US2 Male",
    "en-GB-Neural2-B": "UK Male",
    "en-IN-Neural2-B": "IN Male",
    "en-AU-Neural2-B": "AU Male",
  };

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _loadVoiceType();
    audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  void _loadPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _backgroundSound = prefs.getString('backgroundSoundPreference') ?? 'None';
      _audioVolume = prefs.getString('audioVolumePreference') ?? 'Low';
      _difficulty = prefs.getString('difficultyPreference') ?? 'Normal';
    });
    _adjustVolume(_audioVolume);
  }

  void _loadVoiceType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _voiceType = prefs.getString('voicePreference') ??
          "en-US-Studio-O"; // Default voice type
    });
  }

  void _updatePreference(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
    if (key == 'audioVolumePreference') {
      _adjustVolume(value);
    }
    _loadPreferences();
  }

  void _adjustVolume(String volumeLevel) {
    switch (volumeLevel) {
      case 'Low':
        audioPlayer.setVolume(0.2);
      case 'Medium':
        audioPlayer.setVolume(0.6);
      case 'High':
        audioPlayer.setVolume(1.0);
      default:
        audioPlayer.setVolume(0.3);
        break;
    }
  }

  void _updateDifficulty(String? value) {
    setState(() {
      _difficulty = value!;
    });
    _updatePreference('difficultyPreference', _difficulty);
  }

  Future<void> _cacheAndNavigate(
      String moduleName, List<AnswerGroup> answerGroups) async {
    if (_voiceType == null) {
      print("Voice type not set. Unable to cache module words.");
      return;
    }

    // Show loading indicator while caching
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 10),
              Text("Loading..."),
            ],
          ),
        );
      },
    );

    // Caching all words
    await cacheUtil.cacheModuleWords(answerGroups, _voiceType!);

    // Check if the widget is still in the tree (mounted) after the async operation
    if (!mounted) return; // Early return if not mounted

    Navigator.pop(context); // Close the loading dialog if still mounted
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModuleWidget(
          title: moduleName,
          answerGroups: answerGroups,
          isWord: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: 'Select Difficulties',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: 20.0),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Difficulty",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    _buildDifficultyOptions(),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Background Noise",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    _buildSoundOptions(),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Noise Intensity",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    _buildVolumeOptions(),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    _cacheAndNavigate(widget.moduleName, widget.answerGroups);
                  },
                  child: Text('Go to Module'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyOptions() {
    return Column(
      children: [
        ListTile(
          title: Text(
            'Normal',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          leading: Radio<String>(
            value: 'Normal',
            groupValue: _difficulty,
            onChanged: _updateDifficulty,
          ),
        ),
        ListTile(
          title: Text(
            'Hard',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          leading: Radio<String>(
            value: 'Hard',
            groupValue: _difficulty,
            onChanged: _updateDifficulty,
          ),
        ),
      ],
    );
  }

  Widget _buildSoundOptions() {
    return Column(
      children: [
        ListTile(
          title: Text(
            'Rain',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          leading: Radio<String>(
            value: 'Rain Sound',
            groupValue: _backgroundSound,
            onChanged: (String? value) {
              _updatePreference('backgroundSoundPreference', value!);
            },
          ),
        ),
        ListTile(
          title: Text(
            'Coffee Shop',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          leading: Radio<String>(
            value: 'Shop Sound',
            groupValue: _backgroundSound,
            onChanged: (String? value) {
              _updatePreference('backgroundSoundPreference', value!);
            },
          ),
        ),
        ListTile(
          title: Text(
            'None',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          leading: Radio<String>(
            value: 'None',
            groupValue: _backgroundSound,
            onChanged: (String? value) {
              _updatePreference('backgroundSoundPreference', value!);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVolumeOptions() {
    return Column(
      children: [
        ListTile(
          title: Text(
            'Low',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          leading: Radio<String>(
            value: 'Low',
            groupValue: _audioVolume,
            onChanged: (String? value) {
              _updatePreference('audioVolumePreference', value!);
            },
          ),
        ),
        ListTile(
          title: AutoSizeText(
            'Medium',
            maxLines: 1,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          leading: Radio<String>(
            value: 'Medium',
            groupValue: _audioVolume,
            onChanged: (String? value) {
              _updatePreference('audioVolumePreference', value!);
            },
          ),
        ),
        ListTile(
          title: Text(
            'High',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          leading: Radio<String>(
            value: 'High',
            groupValue: _audioVolume,
            onChanged: (String? value) {
              _updatePreference('audioVolumePreference', value!);
            },
          ),
        ),
      ],
    );
  }
}

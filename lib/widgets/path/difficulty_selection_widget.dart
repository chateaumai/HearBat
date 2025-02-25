import 'package:flutter/material.dart';
import 'package:hearbat/data/answer_pair.dart';
import 'package:hearbat/utils/audio_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../module/module_widget.dart';
import 'package:hearbat/utils/cache_words_util.dart';
import 'package:hearbat/utils/background_noise_util.dart';

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
  final CacheWordsUtil cacheUtil = CacheWordsUtil();
  bool isCaching = false;
  String? _voiceType;

  List<String> voiceTypes = [
    "en-US-Studio-O",
    "en-GB-Neural2-C",
    "en-IN-Neural2-A",
    "en-AU-Neural2-C",
    "en-US-Studio-Q",
    "en-GB-Neural2-B",
    "en-IN-Neural2-B",
    "en-AU-Neural2-B",
  ];

  Map<String, String> voiceTypeTitles = {
    "en-US-Studio-O": "US Female",
    "en-GB-Neural2-C": "UK Female",
    "en-IN-Neural2-A": "IN Female",
    "en-AU-Neural2-C": "AU Female",
    "en-US-Studio-Q": "US Male",
    "en-GB-Neural2-B": "UK Male",
    "en-IN-Neural2-B": "IN Male",
    "en-AU-Neural2-B": "AU Male",
  };

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _loadVoiceType();
    BackgroundNoiseUtil.initialize();
    AudioUtil.initialize();
  }

  void _loadPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _difficulty = prefs.getString('difficultyPreference') ?? 'Normal';
    });
  }

  void _loadVoiceType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String language = prefs.getString('languagePreference') ?? 'English';
    setState(() {
      _voiceType = prefs.getString('voicePreference') ?? "en-US-Studio-O";
      if (language == 'Vietnamese') {
        _voiceType = 'vi-VN-Standard-A';
      }
    });
  }

  void _updatePreference(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
    _loadPreferences();
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
      appBar: null,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.0),
                Text(
                  "Difficulty",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "By completing modules, you can unlock difficulty levels",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                        color: Color.fromARGB(255, 7, 45, 78), width: 4.0),
                  ),
                  child: Column(
                    children: <Widget>[
                      DifficultyOptionsWidget(
                        updateDifficultyCallback: (difficulty) =>
                            _updateDifficulty(difficulty),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  "Background Noise",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Background noises to add an extra challenge",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                        color: Color.fromARGB(255, 7, 45, 78), width: 4.0),
                  ),
                  child: Column(
                    children: <Widget>[
                      SoundOptionsWidget(
                        updatePreferenceCallback: (preference, value) =>
                            _updatePreference(preference, value),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  "Noise Intensity",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Choose the intensity of background noises",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                        color: Color.fromARGB(255, 7, 45, 78), width: 4.0),
                  ),
                  child: Column(
                    children: <Widget>[
                      VolumeOptionsWidget(
                        updatePreferenceCallback: (preference, value) =>
                            _updatePreference(preference, value),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _cacheAndNavigate(widget.moduleName, widget.answerGroups);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 7, 45, 78),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: Size(380, 50),
                    ),
                    child: Text(
                      'START EXCERCISE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      SharedPreferences.getInstance().then((prefs) {
                      prefs.setString('difficultyPreference', 'Normal');
                      prefs.setString('backgroundSoundPreference', 'None');
                      prefs.setString('audioVolumePreference', 'Low');
                    });
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                              color: Color.fromARGB(255, 7, 45, 78),
                              width: 4.0)),
                      minimumSize: Size(380, 50),
                    ),
                    child: Text(
                      'CANCEL',
                      style: TextStyle(
                        color: Color.fromARGB(255, 7, 45, 78),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SoundOptionsWidget extends StatefulWidget {
  final Function(String, String) updatePreferenceCallback;

  SoundOptionsWidget({required this.updatePreferenceCallback});

  @override
  SoundOptionsWidgetState createState() => SoundOptionsWidgetState();
}

class SoundOptionsWidgetState extends State<SoundOptionsWidget> {
  String _selectedSound = 'None';

  @override
  void initState() {
    super.initState();
    _loadSavedPreference();
  }

  void _loadSavedPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedSound = prefs.getString('backgroundSoundPreference');
    if (savedSound != null) {
      setState(() {
        _selectedSound = savedSound;
      });
    }
  }

  void _handleTap(String value) {
    setState(() {
      _selectedSound = value;
      widget.updatePreferenceCallback('backgroundSoundPreference', value);
    });
  }

  Widget _buildOption(String sound, String value) {
    bool isSelected = _selectedSound == value;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: InkWell(
        onTap: () => _handleTap(value),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: ListTile(
              title: Text(
                sound,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              trailing: isSelected
                  ? Icon(Icons.check, color: Color.fromARGB(255, 7, 45, 78))
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildOption('None', 'None'),
        Divider(
          color: Color.fromARGB(255, 7, 45, 78),
          thickness: 3,
          indent: 20,
          endIndent: 20,
        ),
        _buildOption('Rain', 'Rain Sound'),
        Divider(
          color: Color.fromARGB(255, 7, 45, 78),
          thickness: 3,
          indent: 20,
          endIndent: 20,
        ),
        _buildOption('Coffee Shop', 'Shop Sound'),
      ],
    );
  }
}

class VolumeOptionsWidget extends StatefulWidget {
  final Function(String, String) updatePreferenceCallback;

  VolumeOptionsWidget({required this.updatePreferenceCallback});

  @override
  VolumeOptionsWidgetState createState() => VolumeOptionsWidgetState();
}

class VolumeOptionsWidgetState extends State<VolumeOptionsWidget> {
  String _selectedVolume = 'Low'; // Default selected value

  @override
  void initState() {
    super.initState();
    _loadSavedPreference();
  }

  void _loadSavedPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedVolume = prefs.getString('audioVolumePreference');
    if (savedVolume != null) {
      setState(() {
        _selectedVolume = savedVolume;
      });
    }
  }

  void _handleTap(String value) {
    setState(() {
      _selectedVolume = value;
      widget.updatePreferenceCallback('audioVolumePreference', value);
    });
  }

  Widget _buildOption(String volume) {
    bool isSelected = _selectedVolume == volume;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: InkWell(
        onTap: () => _handleTap(volume),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: ListTile(
              title: Text(
                volume,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              trailing: isSelected
                  ? Icon(Icons.check, color: Color.fromARGB(255, 7, 45, 78))
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildOption('Low'),
        Divider(
          color: Color.fromARGB(255, 7, 45, 78),
          thickness: 3,
          indent: 20,
          endIndent: 20,
        ),
        _buildOption('Medium'),
        Divider(
          color: Color.fromARGB(255, 7, 45, 78),
          thickness: 3,
          indent: 20,
          endIndent: 20,
        ),
        _buildOption('High'),
      ],
    );
  }
}

class DifficultyOptionsWidget extends StatefulWidget {
  final Function(String) updateDifficultyCallback;

  DifficultyOptionsWidget({required this.updateDifficultyCallback});

  @override
  DifficultyOptionsWidgetState createState() => DifficultyOptionsWidgetState();
}

class DifficultyOptionsWidgetState extends State<DifficultyOptionsWidget> {
  String _selectedDifficulty = 'Normal';

  @override
  void initState() {
    super.initState();
    _loadSavedPreference();
  }

  void _loadSavedPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedDifficulty = prefs.getString('difficultyPreference');
    if (savedDifficulty != null) {
      _selectedDifficulty = savedDifficulty;
    }
  }

  void _handleTap(String difficulty) {
    setState(() {
      _selectedDifficulty = difficulty;
      widget.updateDifficultyCallback(difficulty);
    });
  }

  Widget _buildOption(String difficulty) {
    bool isSelected = _selectedDifficulty == difficulty;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: InkWell(
        onTap: () => _handleTap(difficulty),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: ListTile(
              title: Text(
                difficulty,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              trailing: isSelected
                  ? Icon(Icons.check, color: Color.fromARGB(255, 7, 45, 78))
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildOption('Normal'),
        Divider(
          color: Color.fromARGB(255, 7, 45, 78),
          thickness: 3,
          indent: 20,
          endIndent: 20,
        ),
        _buildOption('Hard'),
      ],
    );
  }
}

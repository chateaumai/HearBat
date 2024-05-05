import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../utils/google_stt_util.dart';
import '../../utils/google_tts_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'module_progress_bar_widget.dart';
import 'check_button_widget.dart';

class SpeechModuleWidget extends StatefulWidget {
  final String chapter;
  final List<String> sentences;

  SpeechModuleWidget({required this.chapter, required this.sentences});

  @override
  SpeechModuleWidgetState createState() => SpeechModuleWidgetState();
}

class SpeechModuleWidgetState extends State<SpeechModuleWidget> {
  late FlutterSoundRecorder _recorder;
  bool _isRecording = false;
  String _transcription = '';
  String _sentence = '';
  double _grade = 0.0;
  String voiceType = 'en-US-Wavenet-D'; // Default voice type
  String language = 'English';
  bool _isSubmitted = false; // New variable
  bool _isCompleted = false; // New variable

  int currentSentenceIndex =
      0; // New variable to keep track of the current sentence index

  final GoogleTTSUtil _ttsUtil = GoogleTTSUtil(); // Initialize TTS utility

  @override
  void initState() {
    super.initState();
    _init();
    _loadVoiceType(); // Load voiceType preference
    _sentence = _getRandomSentence();
  }

  Future<void> _init() async {
    _recorder = FlutterSoundRecorder();

    if (await Permission.microphone.request().isGranted) {
      await _recorder.openRecorder();
    }
  }

  Future<void> _loadVoiceType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    voiceType = prefs.getString('voiceType') ??
        'en-US-Wavenet-D'; // Load voiceType from prefs or use default
    language = prefs.getString('languagePreference')!;
  }

  String _getRandomSentence() {
    return widget.sentences[Random().nextInt(widget.sentences.length)];
  }

  double _calculateGrade(String original, String transcription) {
    int totalChars = original.length;
    int missedChars = 0;

    original = original.toLowerCase();
    transcription = transcription.toLowerCase();

    List<String> originalWords = original.split(' ');
    List<String> transcribedWords = transcription.split(' ');

    for (String word in originalWords) {
      if (!transcribedWords.contains(word)) {
        missedChars += word.length;
      }
    }

    double correctChars = (totalChars - missedChars).toDouble();
    return (correctChars / totalChars) * 100;
  }

  Future<void> _toggleRecording() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/flutter_sound_example.wav';

    if (_isRecording) {
      await _recorder.stopRecorder();

      final sttUtil = GoogleSTTUtil();
      try {
        final transcription = await sttUtil.transcribeAudio(path);
        double grade = _calculateGrade(_sentence, transcription);
        setState(() {
          _transcription = transcription;
          _grade = grade;
        });
      } catch (e) {
        print('Error in transcription: $e');
        setState(() {
          _transcription = 'Could not transcribe audio.';
          _grade = 0.0;
        });
      }
    } else {
      await _recorder.startRecorder(toFile: path, codec: Codec.pcm16WAV);
      print('Recording saved to: $path');
    }

    setState(() {
      _isRecording = !_isRecording;
    });
  }

  // New method
  void _submitRecording() {
    setState(() {
      currentSentenceIndex++; // Increment the current sentence index after submission
      if (currentSentenceIndex < widget.sentences.length) {
        _sentence = _getRandomSentence(); // Get a new sentence after submission
      } else {
        _isCompleted =
            true; // Set _isCompleted to true when all sentences are submitted
      }
      _isSubmitted = true; // Set _isSubmitted to true here
    });
  }

  Future<void> _playSentence() async {
    await _ttsUtil.speak(_sentence, voiceType); // Use specified voice type
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isSubmitted)
              ModuleProgressBarWidget(
                // Add the ModuleProgressBarWidget here
                currentIndex: currentSentenceIndex,
                total: widget.sentences.length,
              ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 7, 45, 78),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: Size(355, 90),
              ),
              onPressed: _playSentence,
              icon: Icon(
                Icons.volume_up,
                color: Colors.white,
                size: 50,
              ),
              label: Text(""),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleRecording,
              child: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
            ),
            SizedBox(height: 20),
            CheckButtonWidget(
              isCheckingAnswer: _isRecording,
              isSelectedWordValid: _transcription.isNotEmpty,
              onPressed: _submitRecording,
              language: language,
            ),
            SizedBox(height: 20),
            if (_transcription.isNotEmpty)
              Text('Transcription: $_transcription'),
            if (_isSubmitted) ...[
              Text('Original: $_sentence'),
              Text('Accuracy: ${_grade.toStringAsFixed(2)}%'),
            ],
            if (_isCompleted)
              Text('Congratulations! You have completed all sentences.'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }
}

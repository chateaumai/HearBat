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
  String voiceType = 'en-US-Wavenet-D';
  bool _isSubmitted = false;
  bool _isCompleted = false;
  int currentSentenceIndex = 0;
  String language = 'English';
  bool _isCheckPressed = false;

  final GoogleTTSUtil _ttsUtil = GoogleTTSUtil();

  @override
  void initState() {
    super.initState();
    _init();
    _loadVoiceType();
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
    voiceType = prefs.getString('voiceType') ?? 'en-US-Wavenet-D';
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
    return (totalChars - missedChars).toDouble() / totalChars * 100;
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
          _isSubmitted = true;
        });
      } catch (e) {
        setState(() {
          _transcription = 'Could not transcribe audio.';
          _grade = 0.0;
          _isSubmitted = true;
        });
      }
    } else {
      await _recorder.startRecorder(toFile: path, codec: Codec.pcm16WAV);
    }
    setState(() {
      _isRecording = !_isRecording;
    });
  }

  void _submitRecording() {
    setState(() {
      _isCheckPressed = !_isCheckPressed;
      if (_isCheckPressed == false) {
        currentSentenceIndex++;
        if (currentSentenceIndex < widget.sentences.length) {
          _sentence = _getNextSentence();
        } else {
          _isCompleted = true;
        }
        _isSubmitted = false;
        _transcription = '';
      }
    });
  }

  String _getNextSentence() {
    return widget.sentences[currentSentenceIndex];
  }

  Future<void> _playSentence() async {
    await _ttsUtil.speak(_sentence, voiceType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isCompleted ? buildCompletionScreen() : buildModuleContent(),
      ),
    );
  }

  Widget buildModuleContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ModuleProgressBarWidget(
              currentIndex: currentSentenceIndex,
              total: widget.sentences.length,
            ),
          ),
          Text('What do you hear?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 7, 45, 78),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              minimumSize: Size(355, 90),
            ),
            onPressed: _playSentence,
            icon: Icon(Icons.volume_up, color: Colors.white, size: 30),
            label: Text('Play',
                style: TextStyle(fontSize: 20, color: Colors.white)),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: _toggleRecording,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            ),
            child: Text(_isRecording ? 'Stop Recording' : 'Start Recording',
                style: TextStyle(fontSize: 20)),
          ),
          if (_transcription.isNotEmpty)
            Text('Transcription: $_transcription',
                style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
          if (_isSubmitted && _isCheckPressed) ...[
            Text('Original: $_sentence'),
            Text('Accuracy: ${_grade.toStringAsFixed(2)}%'),
          ],
          CheckButtonWidget(
            isCheckingAnswer: !_isCheckPressed,
            isSelectedWordValid: !_isRecording && _transcription.isNotEmpty,
            onPressed: _submitRecording,
            language: language,
          ),
        ],
      ),
    );
  }

  Widget buildCompletionScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        Text('Congratulations! You have completed all sentences.',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Spacer(),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text('Return to Path', style: TextStyle(fontSize: 20)),
        ),
        Spacer(),
      ],
    );
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utils/google_stt_util.dart';

class TestPage extends StatefulWidget {
  @override
  TestPageState createState() => TestPageState();
}

class TestPageState extends State<TestPage> {
  late FlutterSoundRecorder _recorder;
  bool _isRecording = false;
  String _transcription = '';
  String _sentence = '';
  double _grade = 0.0;
  final List<String> _sentences = [
    'The quick brown fox jumps over the lazy dog.',
    'Flutter makes it easy and fast to build beautiful apps.',
    'A journey of a thousand miles begins with a single step.',
    'Every moment is a fresh beginning.',
    'Stay hungry, stay foolish.',
    'All limitations are self-imposed.',
    'Tough times never last, but tough people do.',
    'Have enough courage to start and enough heart to finish.',
    'Nothing will work unless you do.'
  ];

  @override
  void initState() {
    super.initState();
    _init();
    _sentence = _getRandomSentence();
  }

  Future<void> _init() async {
    _recorder = FlutterSoundRecorder();

    if (await Permission.microphone.request().isGranted) {
      await _recorder.openRecorder();
    }
  }

  String _getRandomSentence() {
    return _sentences[Random().nextInt(_sentences.length)];
  }

  double _calculateGrade(String original, String transcription) {
    int totalChars = original.length;
    int missedChars = 0;

    // Normalize the strings to lower case to make the comparison case insensitive
    original = original.toLowerCase();
    transcription = transcription.toLowerCase();

    // Split the sentences into words to compare
    List<String> originalWords = original.split(' ');
    List<String> transcribedWords = transcription.split(' ');

    // Calculate the missed characters by word comparison
    for (String word in originalWords) {
      if (!transcribedWords.contains(word)) {
        missedChars += word.length;
      }
    }

    // Calculate the grade based on the characters that were correctly transcribed
    double correctChars = (totalChars - missedChars).toDouble();
    return (correctChars / totalChars) * 100;
  }

  Future<void> _toggleRecording() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/flutter_sound_example.wav';

    if (_isRecording) {
      await _recorder.stopRecorder();

      // Transcribe the recorded audio
      final sttUtil = GoogleSTTUtil();
      try {
        final transcription = await sttUtil.transcribeAudio(path);
        double grade = _calculateGrade(_sentence, transcription);
        setState(() {
          _transcription = transcription;
          _grade = grade;
          _sentence =
              _getRandomSentence(); // Get a new sentence after recording
        });
      } catch (e) {
        print('Error in transcription: $e');
        setState(() {
          _transcription = 'Could not transcribe audio.';
          _grade = 0.0;
          _sentence = _getRandomSentence(); // Get a new sentence even on error
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _sentence,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleRecording,
              child: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
            ),
            SizedBox(height: 20),
            Text(_transcription),
            SizedBox(height: 20),
            Text('Accuracy: ${_grade.toStringAsFixed(2)}%'),
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

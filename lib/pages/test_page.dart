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

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _recorder = FlutterSoundRecorder();

    if (await Permission.microphone.request().isGranted) {
      await _recorder.openRecorder();
    }
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
        setState(() {
          _transcription = transcription;
        });
      } catch (e) {
        print('Error in transcription: $e');
        setState(() {
          _transcription = 'Could not transcribe audio.';
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
            ElevatedButton(
              onPressed: _toggleRecording,
              child: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
            ),
            SizedBox(height: 20),
            Text(_transcription),
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

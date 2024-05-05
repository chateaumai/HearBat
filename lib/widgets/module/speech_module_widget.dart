import 'package:auto_size_text/auto_size_text.dart';
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
    language = prefs.getString('languagePreference')!;
  }

  List<String> shuffledSentences = [];

  String _getRandomSentence() {
    // If shuffledSentences is empty, copy all sentences and shuffle them
    if (shuffledSentences.isEmpty) {
      shuffledSentences = List<String>.from(widget.sentences);
      shuffledSentences.shuffle();
    }

    // Take the last sentence from shuffledSentences
    String sentence = shuffledSentences.removeLast();

    return sentence;
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
          _sentence = _getRandomSentence();
        } else {
          _isCompleted = true;
        }
        _isSubmitted = false;
        _transcription = '';
      }
    });
  }

  Future<void> _playSentence() async {
    await _ttsUtil.speak(_sentence, voiceType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isCompleted
          ? null
          : AppBar(
              surfaceTintColor: Colors.transparent,
              leading: Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close, size: 40),
                ),
              ),
              titleSpacing: 0,
              title: ModuleProgressBarWidget(
                currentIndex: currentSentenceIndex,
                total: widget.sentences.length,
              ),
              backgroundColor: Color.fromARGB(255, 232, 218, 255),
            ),
      body: SafeArea(
        child: _isCompleted ? buildCompletionScreen() : buildModuleContent(),
      ),
    );
  }

  Widget buildModuleContent() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30.0, 20.0, 20.0, 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Repeat back what you hear!',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(height: 20),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 7, 45, 78),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            minimumSize: Size(355, 90),
                          ),
                          onPressed: _playSentence,
                          icon: Icon(Icons.volume_up,
                              color: Colors.white, size: 30),
                          label: Text('Play',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: _toggleRecording,
                          style: ElevatedButton.styleFrom(
                            primary: _isRecording ? Colors.red : Colors.green,
                            onPrimary: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            _isRecording ? 'Stop Recording' : 'Start Recording',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(height: 30),
                        if (_transcription.isNotEmpty)
                          Container(
                            padding: EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('What you said: $_transcription',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                                textAlign: TextAlign.center),
                          ),
                        SizedBox(height: 30),
                        if (_isSubmitted && _isCheckPressed) ...[
                          Container(
                            padding: EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('Original: $_sentence',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                                textAlign: TextAlign.center),
                          ),
                          SizedBox(height: 30),
                          Text('Accuracy: ${_grade.toStringAsFixed(2)}%',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center),
                        ],
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(bottom: 20, left: 30, right: 30),
                    child: SizedBox(
                      width: 350,
                      height: 56,
                      child: CheckButtonWidget(
                        isCheckingAnswer: !_isCheckPressed,
                        isSelectedWordValid:
                            !_isRecording && _transcription.isNotEmpty,
                        onPressed: _submitRecording,
                        language: language,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildCompletionScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(flex: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
              child: AutoSizeText(
                'Good Job Completing the Module!',
                maxLines: 3,
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 7, 45, 78)),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Image.asset("assets/visuals/HBCompletion.png",
                fit: BoxFit.contain),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40.0, bottom: 40.0),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
              child: AutoSizeText(
                'Return to Path',
                maxLines: 1,
                style: TextStyle(
                    fontSize: 20, color: Color.fromARGB(255, 7, 45, 78)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }
}

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
import 'package:confetti/confetti.dart';
import 'dart:math';

class SpeechModuleWidget extends StatefulWidget {
  final String chapter;
  final List<String> sentences;
  final String voiceType;

  SpeechModuleWidget(
      {required this.chapter,
      required this.sentences,
      required this.voiceType});

  @override
  SpeechModuleWidgetState createState() => SpeechModuleWidgetState();
}

class SpeechModuleWidgetState extends State<SpeechModuleWidget> {
  late FlutterSoundRecorder _recorder;
  bool _isRecording = false;
  String _transcription = '';
  String _sentence = '';
  double _grade = 0.0;
  double _gradeSum = 0.0;
  String voiceType = '';
  bool _isSubmitted = false;
  bool _isCompleted = false;
  int currentSentenceIndex = 0;
  String language = 'English';
  bool _isCheckPressed = false;
  ConfettiController _confettiController =
      ConfettiController(duration: const Duration(seconds: 3));

  final GoogleTTSUtil _ttsUtil = GoogleTTSUtil();

  @override
  void initState() {
    super.initState();
    voiceType = widget.voiceType;
    _init();
    _loadVoiceType();
    _sentence = _getRandomSentence();
    _confettiController.play();
    setState(() {});
  }

  Future<void> _init() async {
    _recorder = FlutterSoundRecorder();
    if (await Permission.microphone.request().isGranted) {
      await _recorder.openRecorder();
    }
  }

  Future<void> _loadVoiceType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    voiceType = prefs.getString('voicePreference') ?? voiceType;
    language = prefs.getString('languagePreference')!;
  }

  Future<void> _playSentence() async {
    await _ttsUtil.speak(_sentence, voiceType);
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
    original = original.replaceAll(RegExp(r'\W'), '').toLowerCase();
    transcription = transcription.replaceAll(RegExp(r'\W'), '').toLowerCase();

    int distance = _levenshteinDistance(original, transcription);
    int maxLength = max(original.length, transcription.length);

    return (1 - distance / maxLength) * 100;
  }

  int _levenshteinDistance(String s, String t) {
    if (s == t) return 0;
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;

    List<int> v0 = List.filled(t.length + 1, 0);
    List<int> v1 = List.filled(t.length + 1, 0);

    for (int i = 0; i < t.length + 1; i++) {
      v0[i] = i;
    }

    for (int i = 0; i < s.length; i++) {
      v1[0] = i + 1;

      for (int j = 0; j < t.length; j++) {
        int cost = (s[i] == t[j]) ? 0 : 1;
        v1[j + 1] = min(min(v1[j] + 1, v0[j + 1] + 1), v0[j] + cost);
      }

      for (int j = 0; j < t.length + 1; j++) {
        v0[j] = v1[j];
      }
    }

    return v1[t.length];
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
          _gradeSum += grade;
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
                    padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 20.0),
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
                            foregroundColor: Colors.white,
                            backgroundColor:
                                _isRecording ? Colors.red : Colors.green,
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
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          particleDrag: 0.05,
          emissionFrequency: 0.1,
          numberOfParticles: 8,
          gravity: 0.2,
          colors: const [
            Colors.yellow,
            Colors.blue,
            Colors.pink,
            Colors.orange,
            Colors.green
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding:
                const EdgeInsets.only(left: 120.0, right: 120.0, top: 60.0),
              child: Image.asset("assets/visuals/HBCompletion.png", fit: BoxFit.contain),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
              child: AutoSizeText(
                'Lesson Complete!',
                maxLines: 1,
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 7, 45, 78)),
                textAlign: TextAlign.center,
              ),
            ),
            // Today's score
            ScoreWidget(
              context: context,
              averageGrade: _gradeSum / 100.0,
              subtitleText: "Score",
              icon: Icon(
                Icons.star,
                color: Color.fromARGB(255, 7, 45, 78),
                size: 30,
              ),
              boxDecoration: gradientBoxDecoration,
              totalGrade: 100, // editting
            ),
            ScoreWidget(
              context: context,
              averageGrade: _gradeSum / 100.0,
              subtitleText: "Highest Score",
              icon: Icon(
                Icons.emoji_events,
                color: Color.fromARGB(255, 255, 255, 255),
                size: 30,
              ),
              boxDecoration: blueBoxDecoration,
              totalGrade: 100, // editting
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
                      fontSize: 20, color: Color.fromARGB(255, 7, 45, 78)
                  ),
                ),
              ),
            ),
          ]
        )

        //Center(
        //  child: Column(
        //    mainAxisAlignment: MainAxisAlignment.center,
        //    children: [
        //      Spacer(flex: 1),
        //      Expanded(
        //        child: Padding(
        //          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
        //          child: AutoSizeText(
        //            'Good Job Completing the Module!',
        //            maxLines: 3,
        //            style: TextStyle(
        //                fontSize: 40,
        //                fontWeight: FontWeight.bold,
        //                color: Color.fromARGB(255, 7, 45, 78)),
        //            textAlign: TextAlign.center,
        //          ),
        //        ),
        //      ),
        //      Padding(
        //        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        //        child: Image.asset("assets/visuals/HBCompletion.png",
        //            fit: BoxFit.contain),
        //      ),
        //      Padding(
        //        padding: const EdgeInsets.only(top: 40.0, bottom: 40.0),
        //        child: ElevatedButton(
        //          onPressed: () => Navigator.pop(context),
        //          style: ElevatedButton.styleFrom(
        //            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        //            shape: RoundedRectangleBorder(
        //                borderRadius: BorderRadius.circular(10.0)),
        //          ),
        //          child: AutoSizeText(
        //            'Return to Path',
        //            maxLines: 1,
        //            style: TextStyle(
        //                fontSize: 20, color: Color.fromARGB(255, 7, 45, 78)),
        //          ),
        //        ),
        //      ),
        //    ],
        //  ),
        //),
      ],
    );
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
    _confettiController.dispose();
  }
}

var gradientBoxDecoration = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(255, 248, 213, 245),
      Color.fromARGB(255, 255, 192, 199),
      Color.fromARGB(255, 213, 177, 239),
    ],
  ),
  borderRadius: BorderRadius.circular(8.0),
  border: Border.all(
    color: Color.fromARGB(255, 7, 45, 78),
    width: 3.0,
  ),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withAlpha((0.5 * 255).toInt()),
      spreadRadius: 5,
      blurRadius: 7,
      offset: Offset(0, 3),
    ),
  ],
);

var blueBoxDecoration = BoxDecoration(
  color: Color.fromARGB(255, 7, 45, 78),
  borderRadius: BorderRadius.circular(8.0),
  border: Border.all(
    color: Color.fromARGB(255, 7, 45, 78),
    width: 3.0,
  ),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withAlpha((0.5 * 255).toInt()),
      spreadRadius: 5,
      blurRadius: 7,
      offset: Offset(0, 3),
    ),
  ],
);


class ScoreWidget extends StatelessWidget {
  const ScoreWidget(
      {super.key,
        required this.context,
        required this.averageGrade,
        required this.subtitleText,
        required this.icon,
        required this.boxDecoration,
        required this.totalGrade});

  final BuildContext context;
  final double averageGrade;
  final String subtitleText;
  final Icon icon;
  final BoxDecoration boxDecoration;
  final int totalGrade;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .90,
      height: MediaQuery.of(context).size.height * .1,
      margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
      padding: EdgeInsets.all(8.0),
      decoration: boxDecoration,
      child: Stack(
        children: [
          Positioned(
            left: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  '$averageGrade% / $totalGrade%',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      color: subtitleText == "Highest Score"
                          ? Colors.white
                          : Color.fromARGB(255, 7, 45, 78)),
                ),
                AutoSizeText(
                  subtitleText,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: subtitleText == "Highest Score"
                          ? Colors.white
                          : Color.fromARGB(255, 7, 45, 78)),
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: icon,
          ),
        ],
      ),
    );
  }
}


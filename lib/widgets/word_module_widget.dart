import 'package:flutter/material.dart';
import 'package:hearbat/data/answer_pair.dart';
import '../../../../widgets/two_word_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WordModuleWidget extends StatefulWidget {
  final String title;
  final List<AnswerGroup> answerGroups;
  final bool isWord;
  WordModuleWidget({Key? key, required this.title, required this.answerGroups, required this.isWord})
      : super(key: key);

  @override
  State createState() => _WordModulePageState();
}

class _WordModulePageState extends State<WordModuleWidget> {
  bool moduleCompleted = false;
  String voiceType = "en-US-Studio-O";

  void getVoiceType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedVoiceType = prefs.getString('voicePreference');
    if (storedVoiceType != null) {
      setState(() {
        voiceType = storedVoiceType;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getVoiceType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: moduleCompleted ? buildCompletionScreen() : buildModuleContent(),
      ),
    );
  }

  Widget buildModuleContent() {
    return TwoWordWidget(
      answerGroups: widget.answerGroups,
      onCompletion: () => setState(() => moduleCompleted = true),
      voiceType: voiceType,
    );
  }

  Widget buildCompletionScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Good Job Completing the Module!'),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Back to Word Path'),
        ),
      ],
    );
  }
}
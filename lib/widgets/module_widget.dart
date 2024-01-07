import 'package:flutter/material.dart';
import 'package:hearbat/data/answer_pair.dart';
import '../../../../widgets/four_answer_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModuleWidget extends StatefulWidget {
  final String title;
  final List<AnswerGroup> answerGroups;
  final bool isWord;
  ModuleWidget({Key? key, required this.title, required this.answerGroups, required this.isWord})
      : super(key: key);

  @override
  State createState() => _ModulePageState();
}

class _ModulePageState extends State<ModuleWidget> {
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
    if (widget.isWord) {
      getVoiceType();
    }
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
    return Container(
      color: Color.fromARGB(255, 232, 218, 255),
      child: FourAnswerWidget(
        answerGroups: widget.answerGroups,
        onCompletion: () => setState(() => moduleCompleted = true),
        voiceType: voiceType,
        isWord: widget.isWord,
      ),
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
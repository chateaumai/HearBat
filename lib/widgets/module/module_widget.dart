import 'package:flutter/material.dart';
import 'package:hearbat/data/answer_pair.dart';
import 'package:hearbat/widgets/module/module_progress_bar_widget.dart';
import 'four_answer_widget.dart';
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
  int currentIndex = 0;

  // this is for the progress bar, bar needs to be here to be on same level as x
  void updateProgress(int newIndex) {
    setState(() {
      currentIndex = newIndex;
    });
  }

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
      appBar: moduleCompleted ? null : AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: IconButton(
            onPressed:() => Navigator.of(context).pop(),
            icon: Icon(
              Icons.close,
              size: 40,
            ),
          ),
        ),
        titleSpacing: 0,
        title: ModuleProgressBarWidget(
          currentIndex: currentIndex,
          total: widget.answerGroups.length, 
        ),
        backgroundColor: Color.fromARGB(255, 232, 218, 255),
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
        onProgressUpdate: updateProgress,
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
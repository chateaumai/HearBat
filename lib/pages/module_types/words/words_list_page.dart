import 'package:flutter/material.dart';
import 'package:hearbat/data/answer_pair.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/top_bar_widget.dart';
import '../../../widgets/path/module_card_widget.dart';

class WordsList extends StatefulWidget {
  final Map<String, List<AnswerGroup>> modules;
  final String chapterName;
  WordsList({Key? key, required this.modules, required this.chapterName}) : super(key: key);

  @override
  State<WordsList> createState() => _WordsListState();
}

class _WordsListState extends State<WordsList> {
  String voiceType = "en-US-Studio-O";
  double elevation = 5.0;

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
      appBar: TopBar(
        title: "${widget.chapterName} WORDS",
        leadingIcon: Icons.west,
      ),
      body: ListView.builder(
        itemCount: widget.modules.length,
        itemBuilder: (context, index) {
          String moduleName = widget.modules.keys.elementAt(index);
          List<AnswerGroup> answerGroups = widget.modules[moduleName]!;
          return ModuleCard(
            moduleName: moduleName,
            answerGroups: answerGroups,
            voiceType: voiceType, 
          );
        },
      ),
    );
  }
}

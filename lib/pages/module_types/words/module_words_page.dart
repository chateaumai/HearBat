import 'package:flutter/material.dart';
import 'package:hearbat/data/answer_pair.dart';
import '../../../utils/google_tts_util.dart';
import '../../../widgets/top_bar_widget.dart';
import '../../../widgets/path/single_word_widget.dart';

class ModuleWordsPage extends StatefulWidget {
  final String moduleName;
  final List<AnswerGroup> answerGroups;
  final String voiceType;

  ModuleWordsPage({Key? key, required this.moduleName, required this.answerGroups, required this.voiceType}) : super(key: key);

  @override
  State<ModuleWordsPage> createState() => _ModuleWordsPageState();
}

class _ModuleWordsPageState extends State<ModuleWordsPage> {
  double elevation = 5.0; 
  GoogleTTSUtil googleTTSUtil = GoogleTTSUtil();

  void playAnswer(String answer) {
    googleTTSUtil.speak(answer, widget.voiceType);
  }

  @override
  Widget build(BuildContext context) {
    List<String> words = widget.answerGroups.expand((group) => [
      group.answer1.answer,
      group.answer2.answer,
      group.answer3.answer,
      group.answer4.answer,
    ]).toList();

    return Scaffold(
      appBar: TopBar(
        title: widget.moduleName,
        leadingIcon: Icons.west,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 2.4, 
              ),
              itemCount: words.length,
              itemBuilder: (context, index) {
                return WordCard(
                  word: words[index],
                  onWordTap: (word) => playAnswer(word),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

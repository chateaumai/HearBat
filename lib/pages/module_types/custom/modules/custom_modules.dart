import 'package:flutter/material.dart';
import 'package:hearbat/data/answer_pair.dart';
import '../../../../widgets/word_module_widget.dart';
// import '../../../../utils/gemini_util.dart';

class CustomModule extends StatelessWidget {
  final String moduleName;
  final List<AnswerGroup> answerGroups;

  CustomModule({required this.moduleName, required this.answerGroups});

  @override
  Widget build(BuildContext context) {
    /* This is just to print and test the LLM response
    String word = wordPairs[0].wordA;
    GeminiUtil.generateContent(word).then((response) {
      print(response);
    }).catchError((error) {
      print('Error: $error');
    });
    */
    return WordModuleWidget(
      title: moduleName,
      answerGroups: answerGroups,
    );
  }
}

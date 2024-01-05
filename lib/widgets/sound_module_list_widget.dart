import 'package:flutter/material.dart';
import 'package:hearbat/data/answer_pair.dart';
import 'module_widget.dart';

class SoundModuleListWidget extends StatelessWidget {
  final Map<String, List<AnswerGroup>> modules;
  final isWord = false;
  SoundModuleListWidget({Key? key, required this.modules}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var moduleList = modules.entries.toList();

    return ListView.builder(
      itemCount: moduleList.length,
      itemBuilder: (context, index) {
        final module = moduleList[index];
        return GestureDetector(
          onTap: () => 
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ModuleWidget(
                title: module.key,
                answerGroups: module.value,
                isWord: isWord,
              ),
            ),
          ),
          child: Container(
            width: 150, // Circle diameter
            height: 150, 
            margin: EdgeInsets.symmetric(vertical: 20), // space between circles
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue, 
            ),
            child: Center(
              child: Text(
                module.key,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ), 
              ),
            ),
          ),
        );
      },
    );
  }
}

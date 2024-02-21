import 'package:flutter/material.dart';
import 'package:hearbat/data/answer_pair.dart';
import 'package:hearbat/widgets/path/animated_button_widget.dart';
import 'module/module_widget.dart';
import '../widgets/path/sound_trangular_path_layout_widget.dart';

class SoundModuleListWidget extends StatelessWidget {
  final Map<String, List<AnswerGroup>> modules;

  SoundModuleListWidget({Key? key, required this.modules}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var moduleList = modules.entries.toList();
    void navigate(String moduleName, List<AnswerGroup> answerGroups) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ModuleWidget(
            title: moduleName,
            answerGroups: answerGroups,
            isWord: false, 
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SoundTriangularPathLayout(
          itemCount: moduleList.length,
          itemBuilder: (context, index) {
            final module = moduleList[index];
            return Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // color: Color.fromARGB(255, 34, 38, 110), 
                    color: Color.fromARGB(255, 94, 63, 117),
                  ),
                  width: 100.0,
                  height: 100.0,
                ),
                AnimatedButton(
                  moduleName: module.key,
                  answerGroups: module.value,
                  onButtonPressed: (String moduleName, List<AnswerGroup> answerGroups) {
                    navigate(moduleName, answerGroups);    
                  }
                ),
              ],
            );
          },
          itemSize: 120.0, 
          spacing: 80.0, 
        ),
      ),
    );
  }
}
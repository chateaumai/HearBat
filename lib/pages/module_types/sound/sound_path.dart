import 'package:flutter/material.dart';
import 'package:hearbat/data/answer_pair.dart';
import 'package:hearbat/widgets/sound_module_list_widget.dart';
import '../../../utils/module_util.dart';

class SoundPath extends StatelessWidget {
  final String chapter;

  SoundPath({Key? key, required this.chapter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, List<AnswerGroup>> modules = getModulesForChapter(chapter);

    return Scaffold(
      appBar: AppBar(
        title: Text(chapter),
      ),
      body: Column(
        children: [
          /* ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        WordsList()), // where the user can view all of the words in the chapter
              );
            },
            child: Text('View All Words'),
          ),*/
          Expanded(
            child: SoundModuleListWidget(
                modules: modules), // all of the modules for the chapter
          ),
        ],
      ),
    );
  }
}

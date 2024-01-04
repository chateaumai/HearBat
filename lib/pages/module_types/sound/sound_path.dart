import 'package:flutter/material.dart';
import 'package:hearbat/data/answer_pair.dart';
import '../../../data/sound_modules_data.dart';
import '../../../utils/module_util.dart';
import '../../../widgets/module_list_widget.dart';

class SoundPath extends StatelessWidget {
  final String chapter;

  SoundPath({Key? key, required this.chapter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, List<AnswerGroup>> modules = getModulesForChapter(chapter);

    return Scaffold(
      appBar: AppBar(
        title: Text('Sound Modules - $chapter'),
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
            child: ModuleListWidget(
                modules: modules), // all of the modules for the chapter
          ),
        ],
      ),
    );
  }

  List<AnswerGroup> getSoundGroupsForChapter(String chapter) {
    if (chapter == "Chapter 1") {
      return chapter1module1SoundGroups + chapter1module2SoundGroups;
    } else if (chapter == "Chapter 2") {
      return chapter1module2SoundGroups;
    }
    return [];
  }
}

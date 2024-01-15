import 'package:flutter/material.dart';
import 'words_list_page.dart';
import 'package:hearbat/data/answer_pair.dart';
import '../../../utils/module_util.dart';
import '../../../widgets/module_list_widget.dart';

class WordPath extends StatelessWidget {
  final String chapter;

  WordPath({Key? key, required this.chapter}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    Map<String, List<AnswerGroup>> modules = getModulesForChapter(chapter);

    return Scaffold(
      appBar: AppBar(
        title: Text(chapter),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        WordsList(modules: modules)), // where the user can view all of the words in the chapter
              );
            },
            child: Text('View All Words'),
          ),
          Expanded(
            child: ModuleListWidget(
                modules: modules), // all of the modules for the chapter
          ),
        ],
      ),
    );
  }
}

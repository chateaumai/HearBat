import 'package:flutter/material.dart';
import 'package:hearbat/widgets/module_list_widget.dart';
import 'package:hearbat/models/modules.dart';
import '../words/words_list_page.dart';

class WordPath extends StatelessWidget {
  final String chapter;

  WordPath({Key? key, required this.chapter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Modules - $chapter'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WordsList()),
              );
            },
            child: Text('View All Words'),
          ),
          Expanded(
            child: ModuleListWidget(modules: wordModules),
          ),
        ],
      ),
    );
  }
}

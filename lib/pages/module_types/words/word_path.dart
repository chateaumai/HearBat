import 'package:flutter/material.dart';
import 'package:hearbat/data/answer_pair.dart';
import '../../../utils/module_util.dart';
import '../../../widgets/path/module_list_widget.dart';
import '../../../widgets/top_bar_widget.dart';

class WordPath extends StatefulWidget {
  final String chapter;

  WordPath({Key? key, required this.chapter}) : super(key: key);

  @override
  State<WordPath> createState() => _WordPathState();
}

class _WordPathState extends State<WordPath> {
  double elevation = 5.0; 

  @override
  Widget build(BuildContext context) {
    Map<String, List<AnswerGroup>> modules = getModulesForChapter(widget.chapter);

    return Scaffold(
      appBar: TopBar(
        title: widget.chapter.toUpperCase(),
        leadingIcon: Icons.west,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.4, 0.9, 1.0],
            colors: [
              Color.fromARGB(255, 212, 176, 237),
              Color.fromARGB(255, 251, 191, 203),
              Color.fromARGB(255, 255, 238, 247),
            ],
          ),
        ),
        child: Column(
          children: [
            // circles
            Expanded(
              child: ModuleListWidget(modules: modules, chapter: widget.chapter),
            ),
          ],
        ),
      ),
    );
  }
}

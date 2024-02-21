import 'package:flutter/material.dart';
import 'package:hearbat/data/answer_pair.dart';
import '../../../utils/module_util.dart';
import '../../../widgets/path/module_list_widget_copy.dart';
import '../../../widgets/top_bar_widget.dart';

class WordPath extends StatefulWidget {
  final String chapter;
  final String background;

  WordPath({Key? key, required this.chapter, required this.background}) : super(key: key);

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
      // backgroundColor: const Color.fromARGB(255, 232, 218, 255),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(widget.background),
            fit: BoxFit.cover,
          )
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

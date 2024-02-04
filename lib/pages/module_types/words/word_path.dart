import 'package:flutter/material.dart';
import 'words_list_page.dart';
import 'package:hearbat/data/answer_pair.dart';
import '../../../utils/module_util.dart';
import '../../../widgets/path/module_list_widget_copy.dart';
import '../../../widgets/top_bar_widget.dart';

class WordPath extends StatefulWidget {
  final String chapter;

  WordPath({Key? key, required this.chapter}) : super(key: key);

  @override
  State<WordPath> createState() => _WordPathState();
}

class _WordPathState extends State<WordPath> {
  double elevation = 5.0; 

  void _navigateToWordsList(BuildContext context, Map<String, List<AnswerGroup>> modules) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WordsList(modules: modules)),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<AnswerGroup>> modules = getModulesForChapter(widget.chapter);

    return Scaffold(
      appBar: TopBar(
        title: widget.chapter.toUpperCase(),
        leadingIcon: Icons.west,
      ),
      backgroundColor: const Color.fromARGB(255, 232, 218, 255),
      body: Column(
        children: [
          GestureDetector(
            onTapDown: (_) => setState(() => elevation = 1.0), 
            onTapUp: (_) => setState(() {
              elevation = 5.0; 
              _navigateToWordsList(context, modules);
            }),
            onTapCancel: () => setState(() => elevation = 5.0), 
            //View words
            child: Container(
              margin: EdgeInsets.all(20),
              child: Material(
                color: Colors.white, 
                elevation: elevation, 
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    'View All Words',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          // circles
          Expanded(
            child: ModuleListWidget(modules: modules),
          ),
        ],
      ),
    );
  }
}

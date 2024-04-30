import 'package:flutter/material.dart';
import 'package:hearbat/data/answer_pair.dart';
import 'package:hearbat/widgets/sound_module_list_widget.dart';
import '../../../utils/module_util.dart';
import '../../../widgets/top_bar_widget.dart';

class SoundPath extends StatefulWidget {
  final String chapter;

  SoundPath({Key? key, required this.chapter}) : super(key: key);

  @override
  State<SoundPath> createState() => _SoundPathState();
}

class _SoundPathState extends State<SoundPath> {
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
            Expanded(
              child: SoundModuleListWidget(
                  modules: modules), 
            ),
          ],
        ),
      ),
    );
  }
}

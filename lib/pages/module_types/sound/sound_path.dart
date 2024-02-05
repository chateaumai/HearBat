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
      body: Column(
        children: [
          Expanded(
            child: SoundModuleListWidget(
                modules: modules), // all of the modules for the chapter
          ),
        ],
      ),
    );
  }
}

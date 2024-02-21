import 'package:flutter/material.dart';
import 'package:hearbat/data/answer_pair.dart';
import 'package:hearbat/widgets/sound_module_list_widget.dart';
import '../../../utils/module_util.dart';
import '../../../widgets/top_bar_widget.dart';

class SoundPath extends StatefulWidget {
  final String chapter;
  final String background;

  SoundPath({Key? key, required this.chapter, required this.background}) : super(key: key);

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
          image: DecorationImage(
            image: AssetImage(widget.background),
            fit: BoxFit.cover,
          )
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

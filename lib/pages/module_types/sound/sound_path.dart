import 'package:flutter/material.dart';
import 'package:hearbat/data/answer_pair.dart';
import '../../../data/sound_modules_data.dart';

class SoundPath extends StatelessWidget {
  final String chapter;

  SoundPath({Key? key, required this.chapter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<AnswerGroup> soundGroups = getSoundGroupsForChapter(chapter);

    return Scaffold(
      appBar: AppBar(
        title: Text('Sound Modules - $chapter'),
      ),
      body: ListView.builder(
        itemCount: soundGroups.length,
        itemBuilder: (context, index) {
          AnswerGroup group = soundGroups[index];
          return Card(
            child: ListTile(
              title: Text('Sound Group'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Sound 1: ${group.answer1.answer} (${group.answer1.path})'),
                  Text(
                      'Sound 2: ${group.answer2.answer} (${group.answer2.path})'),
                  Text(
                      'Sound 3: ${group.answer3.answer} (${group.answer3.path})'),
                  Text(
                      'Sound 4: ${group.answer4.answer} (${group.answer4.path})'),
                ],
              ),
            ),
          );
        },
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

import 'package:flutter/material.dart';
import 'package:hearbat/models/sound_pair.dart';
import '../../../data/sound_modules_data.dart';

class SoundPath extends StatelessWidget {
  final String chapter;

  SoundPath({Key? key, required this.chapter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<SoundGroup> soundGroups = getSoundGroupsForChapter(chapter);

    return Scaffold(
      appBar: AppBar(
        title: Text('Sound Modules - $chapter'),
      ),
      body: ListView.builder(
        itemCount: soundGroups.length,
        itemBuilder: (context, index) {
          SoundGroup group = soundGroups[index];
          return Card(
            child: ListTile(
              title: Text('Sound Group'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sound 1: ${group.sound1.name} (${group.sound1.path})'),
                  Text('Sound 2: ${group.sound2.name} (${group.sound2.path})'),
                  Text('Sound 3: ${group.sound3.name} (${group.sound3.path})'),
                  Text('Sound 4: ${group.sound4.name} (${group.sound4.path})'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<SoundGroup> getSoundGroupsForChapter(String chapter) {
    if (chapter == "Chapter 1") {
      return module1SoundGroups;
    } else if (chapter == "Chapter 2") {
      return module2SoundGroups;
    }
    return [];
  }
}

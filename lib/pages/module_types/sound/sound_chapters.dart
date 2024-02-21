import 'package:flutter/material.dart';
import 'sound_path.dart';
import '../../../widgets/top_bar_widget.dart';
import '../../../widgets/chapter_card_widget.dart';

class SoundChapters extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> chapters = [
      { "name": "Home Sounds",
        "image": "assets/visuals/HBSoundChapterOne.png",
        "background": "assets/visuals/PathOne.png"
      },

      { "name": "Music Sounds",
        "image": "assets/visuals/HBSoundChapterTwo.png",
        "background": "assets/visuals/PathTwo.png"
      },

      {
        "name": "Nature Sounds",
        "image": "assets/visuals/HBSoundChapterThree.png",
        "background": "assets/visuals/PathThree.png"
      },
    ];

    return Scaffold(
      appBar: TopBar(
        title: "SOUND CHAPTERS",
        leadingIcon: Icons.west,
      ),
      body: ListView(
        children: [
          SizedBox(height: 10.0),
          ...List.generate(chapters.length, (index) {
            return ChapterCardWidget(
              chapterName: chapters[index]["name"]!,
              chapterNumber: index,
              image: chapters[index]["image"]!,
              destinationPage: SoundPath(chapter: chapters[index]["name"]!, background: chapters[index]["background"]!),
            );
          }),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }
}

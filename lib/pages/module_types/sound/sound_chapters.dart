import 'package:flutter/material.dart';
import 'sound_path.dart';
import '../../../widgets/top_bar_widget.dart';
import '../../../widgets/chapter_card_widget.dart';

class SoundChapters extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> chapters = [
      "Home Sounds",
      "Music Sounds",
      "Nature Sounds",
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
              chapterName: chapters[index],
              chapterNumber: index,
              destinationPage: SoundPath(chapter: chapters[index]), 
            );
          }),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
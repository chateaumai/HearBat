import 'package:flutter/material.dart';
import 'word_path.dart';
import '../../../widgets/top_bar_widget.dart';
import '../../../widgets/chapter_card_widget.dart';

class WordChapters extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> chapters = [
      "Beginner Foundations",
      "Intermediate Development",
      "Advanced Exploration",
      "Proficient Application",
      "Expert Mastery",
    ];

    return Scaffold(
      appBar: TopBar(
        title: "WORD CHAPTERS",
        leadingIcon: Icons.west,
      ),
      body: ListView(
        children: [
          SizedBox(height: 10.0),
          ...List.generate(chapters.length, (index) {
            return ChapterCardWidget(
              chapterName: chapters[index],
              chapterNumber: index,
              destinationPage: WordPath(chapter: chapters[index]),
            );
          }),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }
}

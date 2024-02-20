import 'package:flutter/material.dart';
import 'word_path.dart';
import '../../../widgets/top_bar_widget.dart';
import '../../../widgets/chapter_card_widget.dart';

class WordChapters extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> chapters = [
      {"name": "Beginner Foundations", "image": "assets/visuals"},
      {"name": "Intermediate Progress", "image": "assets/visuals"},
      {"name": "Advanced Exploration", "image": "assets/visuals"},
      {"name": "Proficient Application", "image": "assets/visuals"},
      {"name": "Expert Mastery", "image": "assets/visuals"},
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
              chapterName: chapters[index]["name"]!,
              chapterNumber: index,
              image: chapters[index]["image"]!,
              destinationPage: WordPath(chapter: chapters[index]["name"]!),
            );
          }),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }
}

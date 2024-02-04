import 'package:flutter/material.dart';
import 'word_path.dart';
import '../../../widgets/top_bar_widget.dart';
import '../../../widgets/chapter_card_widget.dart';

class WordChapters extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> chapters = [
      "Short 'a' Sound",
      "Short 'e' Sound",
      "Short 'i' Sound",
      "Short 'o' Sound",
      "Short 'u' Sound",
      "Buzzing and Hissing Sound",
      "Vowel Slides (Diphthongs)",
      "Nose Sounds (Nasals)",
      "Throaty Sounds (Gutturals)",
      "Tongue-Tip Sounds (Alveolars)",
    ];

    return Scaffold(
      appBar: TopBar(
        title: "WORD CHAPTERS",
        leadingIcon: Icons.west,
      ),
      body: ListView(
        children: List.generate(chapters.length, (index) {
          return ChapterCardWidget(
            chapterName: chapters[index],
            destinationPage: WordPath(chapter: chapters[index]), 
          );
        }),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'word_path.dart';

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
      appBar: AppBar(
        title: Text("Word Chapters"),
      ),
      body: ListView(
        children: List.generate(chapters.length, (index) {
          return ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WordPath(chapter: chapters[index])),
              );
            },
            child: Text(chapters[index]),
          );
        }),
      ),
    );
  }
}

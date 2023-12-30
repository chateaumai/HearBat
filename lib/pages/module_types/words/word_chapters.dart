// word_chapters.dart
import 'package:flutter/material.dart';
import 'word_path.dart';

class WordChapters extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> chapters = [
      "Chapter 1",
      "Chapter 2",
      "Chapter 3",
      "Chapter 4",
      "Chapter 5"
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

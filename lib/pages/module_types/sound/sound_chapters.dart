import 'package:flutter/material.dart';
import 'sound_path.dart';

class SoundChapters extends StatelessWidget {
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
        title: Text("Sound Chapters"),
      ),
      body: ListView(
        children: List.generate(chapters.length, (index) {
          return ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SoundPath(chapter: chapters[index])),
              );
            },
            child: Text(chapters[index]),
          );
        }),
      ),
    );
  }
}

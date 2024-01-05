import 'package:flutter/material.dart';
import 'sound_path.dart';

class SoundChapters extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> chapters = [
      "Home Sounds",
      "Music Sounds",
      "Chapter 3",
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

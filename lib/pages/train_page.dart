import 'package:flutter/material.dart';
import 'module_types/words/word_chapters.dart';
import 'module_types/sound/sound_chapters.dart';
import 'module_types/custom/custom_path.dart';

class TrainPage extends StatelessWidget {
  const TrainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WordChapters()),
            ),
            child: Text('Train Words'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SoundChapters()),
            ),
            child: Text('Train Sounds'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CustomPath()),
            ),
            child: Text('Custom Mode'),
          ),
        ],
      ),
    );
  }
}

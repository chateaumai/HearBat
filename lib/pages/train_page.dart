import 'package:flutter/material.dart';
import 'module_types/words/word_path.dart';
import 'module_types/sound/sound_path.dart';
import 'module_types/note/note_path.dart';
import 'module_types/endless/endless_path.dart';

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
              MaterialPageRoute(builder: (context) => WordPath()),
            ),
            child: Text('Train Words'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SoundPath()),
            ),
            child: Text('Train Sounds'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotePath()),
            ),
            child: Text('Train Notes'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EndlessPath()),
            ),
            child: Text('Endless Mode'),
          ),
        ],
      ),
    );
  }
}
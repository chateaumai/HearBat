import 'package:flutter/material.dart';
import 'word_modules.dart';
import 'sound_modules.dart';
import 'note_modules.dart';

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
              MaterialPageRoute(builder: (context) => WordModules()),
            ),
            child: Text('Train Words'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SoundModules()),
            ),
            child: Text('Train Sounds'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NoteModules()),
            ),
            child: Text('Train Notes'),
          ),
        ],
      ),
    );
  }
}
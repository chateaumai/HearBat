import 'package:flutter/material.dart';
import 'package:hearbat/utils/google_tts.dart';
import '../../../../widgets/two_word_widget.dart';
import '../../../../data/word_modules.dart';

class WordModule2 extends StatelessWidget {

  final GoogleTTS googleTTS = GoogleTTS();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Module 1', ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TwoWordWidget(
              wordPairs: wordModules['Module2'] ?? [],
            ),
          ],
        ),
      ),
    );
  }
}
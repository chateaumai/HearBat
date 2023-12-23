
import 'package:flutter/material.dart';
import 'package:hearbat/models/word_audio_pair.dart';
import 'package:hearbat/widgets/word_pair_row.dart';

class WordModule1 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: WordPairRow(
        wordPairs: [
          WordAudio("Tim", "audio/words/tim.mp3"),
          WordAudio("Tin", "audio/words/tin.mp3"),
        ]
      ),
    );
  }
}


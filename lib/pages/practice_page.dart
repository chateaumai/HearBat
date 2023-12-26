import 'package:flutter/material.dart';
import 'package:hearbat/utils/audio_util.dart';
import 'package:hearbat/models/word_pair.dart';
import '../widgets/word_pair_row.dart';

class PracticePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Row for buttons that will add background noise
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => AudioUtil.toggleBackgroundSound("audio/background/coffee.mp3"),
                child: const Text('Coffee Shop'),
              ),
              ElevatedButton(
                onPressed: () => AudioUtil.toggleBackgroundSound("audio/background/fireplace.mp3"),
                child: const Text('Fireplace'),
              ),
            ],
          ),
          Center(
            child: WordPairRow(
              wordPairs: [
                WordAudio("Tim", "audio/words/tim.mp3"),
                WordAudio("Tin", "audio/words/tin.mp3"),
              ]
            ),
          ),
        ],
      ),
    );
  }
}

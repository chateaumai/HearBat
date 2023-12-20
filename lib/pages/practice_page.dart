import 'package:hearbat/utils/audio_util.dart';
import 'package:flutter/material.dart';

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
            child: WordCard(
              word: "Hi",
              audioFile: "audio/words/hi.mp3",
            ),
          ),
        ],
      ),
    );
  }
}

class WordCard extends StatelessWidget {
  final String word;
  final String audioFile;

  WordCard({
    required this.word,
    required this.audioFile,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AudioUtil.playWordSound(audioFile),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(word, style: TextStyle(fontSize: 24)),
        ),
      ),
    );
  }
}

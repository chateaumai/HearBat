
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class PracticePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: WordCard(
        word: "Hi",
        audioFile: "audio/hi.mp3",
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

  void playSound() async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.setSource(AssetSource(audioFile));
    await audioPlayer.resume();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => playSound(),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(word, style: TextStyle(fontSize: 24)),
        ),
      ),
    );
  }
}

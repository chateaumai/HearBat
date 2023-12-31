import 'package:flutter/material.dart';
import '../utils/google_tts_util.dart';
import 'package:hearbat/models/word_pair.dart';

class IncorrectCardWidget extends StatelessWidget {
  final WordPair wordPair;
  final String correctWord;
  final String voiceType;
  final GoogleTTSUtil googleTTSUtil = GoogleTTSUtil();

  IncorrectCardWidget(
      {Key? key,
      required this.wordPair,
      required this.correctWord,
      required this.voiceType})
      : super(key: key);

  String get incorrectWord =>
      correctWord == wordPair.wordA ? wordPair.wordB : wordPair.wordA;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Correct word
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => googleTTSUtil.playVoice(correctWord, voiceType),
            icon: Icon(Icons.volume_up),
            label: Text('Correct Answer: $correctWord'),
          ),
        ),
        // Incorrect word
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => googleTTSUtil.playVoice(incorrectWord, voiceType),
            icon: Icon(Icons.volume_up),
            label: Text('Incorrect Answer: $incorrectWord'),
          ),
        ),
      ],
    );
  }
}

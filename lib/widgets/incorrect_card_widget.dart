import 'package:flutter/material.dart';
import '../utils/google_tts_util.dart';
import 'package:hearbat/models/word_pair.dart';

class IncorrectCardWidget extends StatelessWidget {
  final WordPair wordPair;
  final String correctWord;
  final GoogleTTSUtil googleTTSUtil = GoogleTTSUtil();

  IncorrectCardWidget(
      {Key? key, required this.wordPair, required this.correctWord})
      : super(key: key);
  String get incorrectWord =>
      correctWord == wordPair.wordA ? wordPair.wordB : wordPair.wordA;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // correct word
        Expanded(
          child: FilledButton.icon(
            onPressed: () =>
                googleTTSUtil.playVoice(correctWord, "en-US-Studio-O"),
            icon: Icon(Icons.volume_up),
            label: Text('Correct Answer: $correctWord'),
          ),
        ),
        Expanded(
          child: FilledButton.icon(
            onPressed: () =>
                googleTTSUtil.playVoice(incorrectWord, "en-US-Studio-O"),
            icon: Icon(Icons.volume_up),
            label: Text('Incorrect Answer: $incorrectWord'),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../utils/google_tts_util.dart';

class IncorrectCardWidget extends StatelessWidget {
  final String? incorrectWord;
  final String correctWord;
  final String voiceType;
  final GoogleTTSUtil googleTTSUtil = GoogleTTSUtil();

  IncorrectCardWidget(
      {Key? key,
      required this.incorrectWord,
      required this.correctWord,
      required this.voiceType})
      : super(key: key);


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
            onPressed: () => googleTTSUtil.playVoice(incorrectWord!, voiceType),
            icon: Icon(Icons.volume_up),
            label: Text('Incorrect Answer: $incorrectWord'),
          ),
        ),
      ],
    );
  }
}
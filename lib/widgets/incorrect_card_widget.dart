import 'package:flutter/material.dart';
import 'package:hearbat/data/answer_pair.dart';
import '../utils/audio_util.dart';

class IncorrectCardWidget extends StatelessWidget {
  final Answer incorrectWord;
  final Answer correctWord;
  final String voiceType;

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
            onPressed: () => AudioUtil.playWordSound(correctWord.path),
            icon: Icon(Icons.volume_up),
            label: Text('Correct Answer: $correctWord'),
          ),
        ),
        // Incorrect word
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => AudioUtil.playWordSound(incorrectWord.path),
            icon: Icon(Icons.volume_up),
            label: Text('Incorrect Answer: $incorrectWord'),
          ),
        ),
      ],
    );
  }
}
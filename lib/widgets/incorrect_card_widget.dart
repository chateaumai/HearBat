import 'package:flutter/material.dart';
import 'package:hearbat/data/answer_pair.dart';
import '../utils/google_tts_util.dart';
import '../utils/audio_util.dart';

class IncorrectCardWidget extends StatefulWidget {
  final Answer incorrectWord;
  final Answer correctWord;
  final String voiceType;
  final bool isWord;

  IncorrectCardWidget({
    Key? key,
    required this.incorrectWord,
    required this.correctWord,
    required this.voiceType,
    required this.isWord,
  }) : super(key: key);

  @override
  IncorrectCardWidgetState createState() => IncorrectCardWidgetState();
}

class IncorrectCardWidgetState extends State<IncorrectCardWidget> {
  GoogleTTSUtil googleTTSUtil = GoogleTTSUtil();

  @override
  void initState() {
    super.initState();
  }

  void playAnswer(Answer answer) {
    if (widget.isWord) {
      googleTTSUtil.speak(answer.answer, widget.voiceType);
    }
    else {
      AudioUtil.playSound(answer.path!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Correct word button
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => playAnswer(widget.correctWord),
            icon: Icon(Icons.volume_up),
            label: Text('Correct Answer: ${widget.correctWord.answer}'),
          ),
        ),
        // Incorrect word button
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => playAnswer(widget.incorrectWord),
            icon: Icon(Icons.volume_up),
            label: Text('Incorrect Answer: ${widget.incorrectWord.answer}'),
          ),
        ),
      ],
    );
  }
}

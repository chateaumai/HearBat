import 'package:flutter/material.dart';
import 'package:hearbat/data/answer_pair.dart';
import '../utils/google_tts_util.dart';

class IncorrectCardWidget extends StatefulWidget {
  final Answer incorrectWord;
  final Answer correctWord;
  final String voiceType;

  IncorrectCardWidget({
    Key? key,
    required this.incorrectWord,
    required this.correctWord,
    required this.voiceType,
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

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Correct word button
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => googleTTSUtil.speak(
                widget.correctWord.answer, widget.voiceType),
            icon: Icon(Icons.volume_up),
            label: Text('Correct Answer: ${widget.correctWord.answer}'),
          ),
        ),
        // Incorrect word button
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => googleTTSUtil.speak(
                widget.incorrectWord.answer, widget.voiceType),
            icon: Icon(Icons.volume_up),
            label: Text('Incorrect Answer: ${widget.incorrectWord.answer}'),
          ),
        ),
      ],
    );
  }
}

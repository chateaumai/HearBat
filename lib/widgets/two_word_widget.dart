/*
import "dart:math";
import 'package:flutter/material.dart';
import 'package:hearbat/models/word_pair.dart';
import '../widgets/word_button_widget.dart';
import '../widgets/check_button_widget.dart';
import '../widgets/incorrect_card_widget.dart';
import 'package:hearbat/utils/google_tts_util.dart';

class TwoWordWidget extends StatefulWidget {
  final GoogleTTSUtil googleTTSUtil;
  final List<WordPair> wordPairs;
  final VoidCallback onCompletion;
  final String voiceType;

  TwoWordWidget({
    Key? key,
    required this.wordPairs,
    required this.onCompletion,
    required this.voiceType,
  })  : googleTTSUtil = GoogleTTSUtil(),
        super(key: key);

  @override
  State<TwoWordWidget> createState() => _TwoWordWidgetState();
}

class _TwoWordWidgetState extends State<TwoWordWidget> {
  late List<WordPair> remainingPairs;
  late WordPair currentPair;
  late String correctWord;
  String? selectedWord;
  bool isCheckingAnswer = true;
  bool isAnswerFalse = false;

  @override
  void initState() {
    super.initState();
    remainingPairs = List<WordPair>.from(widget.wordPairs);
    setNextPair();
  }

  void setNextPair() {
    int index = Random().nextInt(remainingPairs.length);
    currentPair = remainingPairs[index];
    remainingPairs
        .removeAt(index); // So the randomly chosen pair doesn't repeat

    correctWord = Random().nextBool() ? currentPair.wordA : currentPair.wordB;
    selectedWord = null;
    isCheckingAnswer = true;
    isAnswerFalse = false;
  }

  void handleSelection(String word) {
    setState(() {
      selectedWord = word;
    });
  }

  void checkAnswer() {
    if (selectedWord == correctWord) {
      print("Correct");
    } else {
      print("Incorrect");
      isAnswerFalse = true;
    }
    if (remainingPairs.isEmpty) widget.onCompletion();
    isCheckingAnswer = false; // Time to go to the next pair
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () =>
              widget.googleTTSUtil.playVoice(correctWord, widget.voiceType),
          icon: Icon(Icons.volume_up),
          label: Text('Play'),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            WordButton(
              word: currentPair.wordA,
              selectedWord: selectedWord ?? '',
              onSelected: handleSelection,
            ),
            WordButton(
              word: currentPair.wordB,
              selectedWord: selectedWord ?? '',
              onSelected: handleSelection,
            ),
            SizedBox(height: 20),
            if (isAnswerFalse)
              IncorrectCardWidget(
                wordPair: currentPair,
                correctWord: correctWord,
                voiceType: widget.voiceType,
              ),
            CheckButtonWidget(
              isCheckingAnswer: isCheckingAnswer,
              isSelectedWordValid: selectedWord != null,
              onPressed: () {
                if (isCheckingAnswer) {
                  checkAnswer();
                } else {
                  setNextPair();
                }
                setState(() {});
              },
            ),
          ],
        ),
      ],
    );
  }
}
*/
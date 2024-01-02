import "dart:math";
import 'package:flutter/material.dart';
import '../utils/audio_util.dart';
import 'package:hearbat/data/answer_pair.dart';
import '../widgets/word_button_widget.dart';
import '../widgets/check_button_widget.dart';
import '../widgets/incorrect_card_widget.dart';

class TwoWordWidget extends StatefulWidget {
  final List<AnswerGroup> answerGroups;
  final VoidCallback onCompletion;
  final String voiceType;

  TwoWordWidget({
    Key? key,
    required this.answerGroups,
    required this.onCompletion,
    required this.voiceType,
  })  :
        super(key: key);

  @override
  State<TwoWordWidget> createState() => _TwoWordWidgetState();
}

class _TwoWordWidgetState extends State<TwoWordWidget> {
  late List<AnswerGroup> answerGroups;
  late AnswerGroup currentGroup;
  late Answer correctWord;
  String? incorrectWord;
  String? selectedWord;
  bool isCheckingAnswer = true;
  bool isAnswerFalse = false;

  @override
  void initState() {
    super.initState();
    answerGroups = List<AnswerGroup>.from(widget.answerGroups);
    setNextPair();
  }

  void setNextPair() {
    int index = Random().nextInt(answerGroups.length);
    currentGroup = answerGroups[index];
    answerGroups
        .removeAt(index); // So the randomly chosen pair doesn't repeat

    correctWord = currentGroup.getRandomAnswer(currentGroup);
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
    if (selectedWord == correctWord.answer) {
      print("Correct");
    } else {
      print("Incorrect");
      incorrectWord = selectedWord;
      isAnswerFalse = true;
    }
    if (answerGroups.isEmpty) widget.onCompletion();
    isCheckingAnswer = false; // Time to go to the next pair
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () =>
          AudioUtil.playWordSound('audio/words/hi.mp3'),
          icon: Icon(Icons.volume_up),
          label: Text('Play'),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            WordButton(
              word: currentGroup.answer1.answer,
              selectedWord: selectedWord ?? '',
              onSelected: handleSelection,
            ),
            WordButton(
              word: currentGroup.answer2.answer,
              selectedWord: selectedWord ?? '',
              onSelected: handleSelection,
            ),
            WordButton(
              word: currentGroup.answer3.answer,
              selectedWord: selectedWord ?? '',
              onSelected: handleSelection,
            ),
            WordButton(
              word: currentGroup.answer4.answer,
              selectedWord: selectedWord ?? '',
              onSelected: handleSelection,
            ),
            SizedBox(height: 20),
            if (isAnswerFalse)
              IncorrectCardWidget(
                incorrectWord: incorrectWord,
                correctWord: correctWord.answer,
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
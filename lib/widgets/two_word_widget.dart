import "dart:math";
import 'package:flutter/material.dart';
import 'package:hearbat/models/word_pair.dart';
import 'package:hearbat/utils/google_tts.dart';

  class TwoWordWidget extends StatefulWidget {
    final GoogleTTS googleTTS = GoogleTTS();
    final List<WordPair> wordPairs; 
    final VoidCallback onCompletion;

  TwoWordWidget({Key? key, required this.wordPairs, required this.onCompletion}) : super(key: key);

  @override
  State<TwoWordWidget> createState() => _TwoWordWidgetState();
}

class _TwoWordWidgetState extends State<TwoWordWidget> {
  late List<WordPair> remainingPairs;
  late WordPair currentPair;
  late String correctWord;
  String? selectedWord;
  bool isCheckingAnswer = true;

  // choosing random word
  @override
  void initState() {
    super.initState();
    remainingPairs = List<WordPair>.from(widget.wordPairs);
    setNextPair();
  }

  void setNextPair() {
    int index = Random().nextInt(remainingPairs.length);
    currentPair = remainingPairs[index];
    remainingPairs.removeAt(index);  //so the randomly chosen pair doesnt repeat

    correctWord = Random().nextBool() ? currentPair.wordA : currentPair.wordB;
    selectedWord = null;
    isCheckingAnswer = true;
  }

  void checkAnswer() {
    if (remainingPairs.isEmpty) widget.onCompletion();

    if (selectedWord == correctWord) {
      print("Correct");
    } else {
      print("Incorrect");
    }
    isCheckingAnswer = false; // time to go to next pair
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilledButton.icon(
          onPressed: () => widget.googleTTS.playVoice(correctWord, "en-US-Studio-O"),
          icon: Icon(Icons.volume_up),
          label: Text('Play'),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // word A button - these should be abstracted out
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedWord = currentPair.wordA;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor : selectedWord == currentPair.wordA 
                  ? Colors.grey
                  : Colors.white,
              ),
              child: Text(
                currentPair.wordA,
                style: TextStyle(color: Colors.black),
              ),
            ),
            // word B
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedWord = currentPair.wordB;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor : selectedWord == currentPair.wordB 
                  ? Colors.grey
                  : Colors.white,
              ),
              child: Text(
                currentPair.wordB,
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            // can prob refactor this out (this is the check button)
            ElevatedButton(
              onPressed: selectedWord != null ? () {
                if (isCheckingAnswer) {
                  checkAnswer();
                } else {
                  setNextPair();
                }
                setState(() {});
              } : null, // if null then disable
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedWord != null
                ? Colors.lightGreen
                : Colors.grey,
                disabledBackgroundColor: Colors.grey,
              ),
              child: Text(
                isCheckingAnswer ? 'Check' : 'Next',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

import "dart:math";
import 'package:flutter/material.dart';
import 'package:hearbat/data/answer_pair.dart';
import 'word_button_widget.dart';
import 'check_button_widget.dart';
import 'incorrect_card_widget.dart';
import '../../utils/google_tts_util.dart';
import '../../utils/audio_util.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FourAnswerWidget extends StatefulWidget {
  final List<AnswerGroup> answerGroups;
  final VoidCallback onCompletion;
  final String voiceType;
  final bool isWord;
  final Function(int) onProgressUpdate; //for progress bar in parent

  FourAnswerWidget({
    Key? key,
    required this.answerGroups,
    required this.onCompletion,
    required this.voiceType,
    required this.isWord,
    required this.onProgressUpdate,
  }) : super(key: key);

  @override
  State<FourAnswerWidget> createState() => _FourAnswerWidgetState();
}

class _FourAnswerWidgetState extends State<FourAnswerWidget> {
  GoogleTTSUtil googleTTSUtil = GoogleTTSUtil();
  late List<AnswerGroup> answerGroups;
  late AnswerGroup currentGroup;
  late Answer correctWord;
  Answer? incorrectWord;
  Answer? selectedWord;
  bool isCheckingAnswer = true;
  bool isAnswerFalse = false;
  bool isAnswerTrue = false;
  bool readyForCompletion = false;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    answerGroups = List<AnswerGroup>.from(widget.answerGroups);
    setNextPair();
  }

  void setNextPair() {
    if (answerGroups.isNotEmpty) {
      int index = Random().nextInt(answerGroups.length);
      currentGroup = answerGroups[index];
      answerGroups
          .removeAt(index); // So the randomly chosen pair doesn't repeat

      correctWord = currentGroup.getRandomAnswer(currentGroup);
      selectedWord = null;
      isCheckingAnswer = true;
      isAnswerFalse = false;
      isAnswerTrue = false;
      readyForCompletion = false;
    }

    Future.delayed(Duration(seconds: 1), () {
      playAnswer();
    });
  }

  void handleSelection(Answer word) {
    setState(() {
      selectedWord = word;
    });
  }

  void checkAnswer() {
    if (selectedWord!.answer == correctWord.answer) {
      print("Correct");
      isAnswerTrue = true;
    } else {
      print("Incorrect");
      incorrectWord = selectedWord;
      isAnswerFalse = true;
    }
    if (answerGroups.isEmpty) readyForCompletion = true;
    isCheckingAnswer = false; // Time to go to the next pair
    ++currentIndex;
    indexChange();
  }

  void playAnswer() {
    if (widget.isWord) {
      googleTTSUtil.speak(correctWord.answer, widget.voiceType);
    }
    else {
      AudioUtil.playSound(correctWord.path!);
    }
  }

  void indexChange() {
    widget.onProgressUpdate(currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //SizedBox(height: 20),
        // play button
        Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 20.0, 0.0, 20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "What do you hear?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Color.fromARGB(255, 0, 0, 0)
              ),
            ),
          ),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 7, 45, 78),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            minimumSize: Size(355, 90),
          ),
          onPressed: () => playAnswer(),
          icon: Icon(
            Icons.volume_up,
            color: Colors.white,
            size: 50,
          ),
          label: Text(''),
        ),
        // space between play button and 4 cards
        SizedBox(height: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, 
                crossAxisSpacing: 20, // horizontal spacing
                mainAxisSpacing: 15, // vertical spacing 
                childAspectRatio: 150 / 180, 
              ),
              itemCount: 4, 
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                Answer word;
                switch (index) {
                  case 0:
                    word = currentGroup.answer1;
                  case 1:
                    word = currentGroup.answer2;
                  case 2:
                    word = currentGroup.answer3;
                  case 3:
                    word = currentGroup.answer4;
                  default:
                    word = currentGroup.answer1; 
                }
                return WordButton(
                  word: word,
                  isWord: widget.isWord,
                  selectedWord: selectedWord,
                  onSelected: handleSelection,
                );
              },
            ),
          ),
        ),
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            if (isAnswerFalse) 
              Container(
                width: double.infinity,
                height: 250,
                color: Color.fromARGB(255, 255, 255, 255),
                child: Stack(
                  children: [
                    Positioned(
                      top: 92,
                      left: 0,
                      right: 0,
                      // needs to be changed for images
                      child: IncorrectCardWidget(
                        incorrectWord: incorrectWord!,
                        correctWord: correctWord,
                        voiceType: widget.voiceType,
                        isWord: widget.isWord,
                      ),
                    ),
                    Positioned(
                      top: 60,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 30.0),
                            child: Text(
                              "Incorrect",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            "Correct",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ), // .animate().slide(begin: Offset(0, 1)),
                  ],
                ),
              ).animate(onPlay: (controller) => controller.forward()).slide(begin: Offset(0, 1), duration: 300.ms, curve: Curves.easeInOutQuart),
            if (isAnswerTrue)
              Container(
                width: double.infinity,
                height: 150,
                color: Color.fromARGB(255, 255, 255, 255),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 60),
                    child: Text(
                      "Great!",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ).animate(onPlay: (controller) => controller.forward()).slide(begin: Offset(0, 1), duration: 300.ms, curve: Curves.easeInOutQuart),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                width: 350,
                height: 56,
                child: CheckButtonWidget(
                  isCheckingAnswer: isCheckingAnswer,
                  isSelectedWordValid: selectedWord != null,
                  onPressed: () {
                    if (isCheckingAnswer) {
                      checkAnswer();
                    } else if (readyForCompletion) {
                      widget.onCompletion();
                    } else {
                      setNextPair();
                    }
                    setState(() {});
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

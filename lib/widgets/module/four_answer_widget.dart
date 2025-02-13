import "dart:math";
import 'package:flutter/material.dart';
import 'package:hearbat/data/answer_pair.dart';
import 'word_button_widget.dart';
import 'check_button_widget.dart';
import 'incorrect_card_widget.dart';
import '../../utils/google_tts_util.dart';
import '../../utils/audio_util.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FourAnswerWidget extends StatefulWidget {
  final List<AnswerGroup> answerGroups;
  final VoidCallback onCompletion;
  final VoidCallback onCorrectAnswer;
  final void Function(Answer, Answer) onIncorrectAnswer;
  final String voiceType;
  final bool isWord;
  final Function(int) onProgressUpdate; //for progress bar in parent

  FourAnswerWidget({
    super.key,
    required this.answerGroups,
    required this.onCompletion,
    required this.onCorrectAnswer,
    required this.onIncorrectAnswer,
    required this.voiceType,
    required this.isWord,
    required this.onProgressUpdate,
  });

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
  String language = 'English';

  @override
  void initState() {
    super.initState();
    _loadPreference();
    answerGroups = List<AnswerGroup>.from(widget.answerGroups);
    setNextPair();
  }

  Future<void> _loadPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    language = prefs.getString('languagePreference') ?? 'English';
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
      widget.onCorrectAnswer();
      isAnswerTrue = true;
    } else {
      print("Incorrect");
      widget.onIncorrectAnswer(selectedWord!, correctWord);
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
    } else {
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
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                //SizedBox(height: 20),
                // play button
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 20.0, 0.0, 20.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      language == 'English'
                          ? "What do you hear?"
                          : "Bạn nghe chữ gì?",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: Color.fromARGB(255, 7, 45, 78)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: ElevatedButton.icon(
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
                ),
                // space between play button and 4 cards
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: !widget.isWord
                      ? GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: WordButton(
                                word: word,
                                isWord: widget.isWord,
                                selectedWord: selectedWord,
                                onSelected: handleSelection,
                              ),
                            );
                          },
                        )
                      : ListView.builder(
                          shrinkWrap: true,
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
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: WordButton(
                                word: word,
                                isWord: widget.isWord,
                                selectedWord: selectedWord,
                                onSelected: handleSelection,
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            if (isAnswerFalse)
              Container(
                width: double.infinity,
                height: 220,
                color: Color.fromARGB(255, 255, 255, 255),
                child: Stack(
                  children: [
                    Positioned(
                      top: 50,
                      left: 0,
                      right: 0,
                      child: IncorrectCardWidget(
                        incorrectWord: incorrectWord!,
                        correctWord: correctWord,
                        voiceType: widget.voiceType,
                        isWord: widget.isWord,
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 30.0),
                            child: Text(
                              language == 'Vietnamese' ? 'Sai' : 'Incorrect',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 7, 45, 78),
                              ),
                            ),
                          ),
                          Text(
                            language == 'Vietnamese' ? 'Đúng' : 'Correct',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 7, 45, 78),
                            ),
                          ),
                        ],
                      ),
                    ), // .animate().slide(begin: Offset(0, 1)),
                  ],
                ),
              ).animate(onPlay: (controller) => controller.forward()).slide(
                  begin: Offset(0, 1),
                  duration: 300.ms,
                  curve: Curves.easeInOutQuart),
            if (isAnswerTrue)
              Container(
                width: double.infinity,
                height: 150,
                color: Color.fromARGB(255, 255, 255, 255),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 60),
                    child: Text(
                      language == 'Vietnamese' ? 'Xuất Sắc' : 'Great',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ).animate(onPlay: (controller) => controller.forward()).slide(
                  begin: Offset(0, 1),
                  duration: 300.ms,
                  curve: Curves.easeInOutQuart),
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
                  language: language,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

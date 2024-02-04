import 'package:flutter/material.dart';
import 'package:hearbat/data/answer_pair.dart';
import '../../../utils/google_tts_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/top_bar_widget.dart';

class WordsList extends StatefulWidget {
  final Map<String, List<AnswerGroup>> modules;

  WordsList({Key? key, required this.modules}) : super(key: key);

  @override
  State<WordsList> createState() => _WordsListState();
}

class _WordsListState extends State<WordsList> {
  String voiceType = "en-US-Studio-O";

  void getVoiceType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedVoiceType = prefs.getString('voicePreference');
    if (storedVoiceType != null) {
      setState(() {
        voiceType = storedVoiceType;
      });
    }
  }
  
  @override
  void initState() {
    super.initState();
    getVoiceType();
  }

  GoogleTTSUtil googleTTSUtil = GoogleTTSUtil();

  @override
  Widget build(BuildContext context) {
    List<String> allWords = _extractWords();
    int itemCount = (allWords.length + 1) ~/ 2;

    return Scaffold(
      appBar: TopBar(
        title: "WORD LIST",
        leadingIcon: Icons.west,
      ),
      body: ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) {
          int firstWordIndex = index * 2;
          int secondWordIndex = firstWordIndex + 1;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => playAnswer(allWords[firstWordIndex]),
                    icon: Icon(
                      Icons.volume_up,
                      color: Colors.black,
                      size: 20,
                    ), 
                    label: Text(allWords[firstWordIndex]),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: secondWordIndex < allWords.length ? ElevatedButton.icon(
                    onPressed: () => playAnswer(allWords[secondWordIndex]),
                    icon: Icon(
                      Icons.volume_up,
                      color: Colors.black,
                      size: 20,
                    ), 
                    label: Text(allWords[secondWordIndex]),
                  ) : SizedBox(),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  void playAnswer(String answer) {
    googleTTSUtil.speak(answer, voiceType);
  }

  List<String> _extractWords() {
    List<String> words = [];
    widget.modules.forEach((moduleName, answerGroups) {
      for (var group in answerGroups) {
        words.add(group.answer1.answer);
        words.add(group.answer2.answer);
        words.add(group.answer3.answer);
        words.add(group.answer4.answer);
      }
    });
    return words;
  }
}

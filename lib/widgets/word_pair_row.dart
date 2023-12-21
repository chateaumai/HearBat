import 'package:flutter/material.dart';
import 'package:hearbat/models/word_audio_pair.dart';
import 'package:hearbat/utils/audio_util.dart';
import "dart:math";

class WordPairRow extends StatefulWidget {
  final _random = Random();
  final List<WordAudio> wordPairs; // literally a pair {Tim, tim.mp3}, {Tin, tin.mp3}
  late final WordAudio correctPair;

  WordPairRow({Key? key, required this.wordPairs}) : super(key: key) {
    correctPair = wordPairs[_random.nextInt(wordPairs.length)];
  }

  @override
  State<WordPairRow> createState() => _WordPairRowState();
}

class _WordPairRowState extends State<WordPairRow> {
  int? selectedButtonIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilledButton.icon(
          onPressed: () => AudioUtil.playWordSound(widget.correctPair.audioFile),
          icon: Icon(Icons.volume_up),
          label: Text('Play'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(widget.wordPairs.length, (index) {
            return ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedButtonIndex = index;
                });
              }, 
              style: ElevatedButton.styleFrom(
                backgroundColor : selectedButtonIndex == index 
                  ? Colors.grey
                  : Colors.white,
              ),
              child: Text(
                widget.wordPairs[index].word,
                style: TextStyle(color: Colors.black),
              ),
            );
          }),
        ),
        // can prob refactor this out
        ElevatedButton(
          onPressed: selectedButtonIndex != null ? () {
            // only executes if selectedButtonIndex is not null
            if (widget.wordPairs[selectedButtonIndex!].word == widget.correctPair.word) { 
              print("Correct\n");
            } else {
              print("Incorrect\n");
            }
          } : null , // if null then disable
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedButtonIndex != null
            ? Colors.lightGreen
            : Colors.grey,
            disabledBackgroundColor: Colors.grey,
          ),
            child: Text(
              "Check",
              style: TextStyle(color: Colors.black),
            ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class WordButton extends StatelessWidget {
  final String word;
  final String selectedWord;
  final ValueChanged<String> onSelected;

  const WordButton({
    Key? key,
    required this.word,
    required this.selectedWord,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onSelected(word),
      style: ElevatedButton.styleFrom(
        backgroundColor : selectedWord == word
          ? Colors.grey
          : Colors.white,
      ),
      child: Text(
        word,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
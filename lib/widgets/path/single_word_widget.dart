import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class WordCard extends StatefulWidget {
  final String word;
  final Function(String word) onWordTap;

  const WordCard({super.key, required this.word, required this.onWordTap});

  @override
  State<WordCard> createState() => _WordCardState();
}

class _WordCardState extends State<WordCard> {
  double _elevation = 5.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _elevation = 1.0),
      onTapUp: (_) {
        setState(() => _elevation = 5.0);
        widget.onWordTap(widget.word);
      },
      onTapCancel: () => setState(() => _elevation = 5.0),
      child: Card(
        elevation: _elevation,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: AutoSizeText(
                  widget.word,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
              // this is just to push the expanded widget left
              Opacity(
                opacity: 0.0,
                child: Icon(Icons.volume_up, size: 5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

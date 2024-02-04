import 'package:flutter/material.dart';

class ChapterCardWidget extends StatefulWidget {
  final String chapterName;
  final Widget destinationPage;

  const ChapterCardWidget({
    Key? key,
    required this.chapterName,
    required this.destinationPage,
  }) : super(key: key);

  @override
  State<ChapterCardWidget> createState() => _ChapterCardWidgetState();
}

class _ChapterCardWidgetState extends State<ChapterCardWidget> {
  double elevation = 5.0;

  void _navigateToChapter(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget.destinationPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cardWidth = screenSize.width * 0.9;
    final cardHeight = screenSize.height * 0.2; 

    return GestureDetector(
      onTapDown: (_) => setState(() => elevation = 1.0),
      onTapUp: (_) => setState(() {
        elevation = 5.0;
        _navigateToChapter(context);
      }),
      onTapCancel: () => setState(() => elevation = 5.0),
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: Card(
          elevation: elevation,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                widget.chapterName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

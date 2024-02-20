import 'package:flutter/material.dart';

class ChapterCardWidget extends StatefulWidget {
  final String chapterName;
  final int chapterNumber;
  final String image;
  final Widget destinationPage;

  const ChapterCardWidget({
    Key? key,
    required this.chapterName,
    required this.chapterNumber,
    required this.image,
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
    final cardHeight = screenSize.height * 0.28;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: GestureDetector(
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
            // this is for respect to the rounded border of the card
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    // blue box
                    child: Container(
                      height: cardHeight * 0.4, 
                      color: Color.fromARGB(255, 7, 45, 78),
                      padding: EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0), 
                      alignment: Alignment.topLeft, 
                      child: Text(
                        "Chapter ${widget.chapterNumber + 1}\n${widget.chapterName.toUpperCase()}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, 
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

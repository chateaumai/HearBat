import 'package:flutter/material.dart';
import 'dart:math';

class HomeCardWidget extends StatefulWidget {
  final String cardText;
  final String description;
  final Widget destinationPage;

  const HomeCardWidget({
    Key? key,
    required this.cardText,
    required this.description,
    required this.destinationPage,
  }) : super(key: key);

  @override
  State<HomeCardWidget> createState() => _HomeCardWidgetState();
}

class _HomeCardWidgetState extends State<HomeCardWidget> {
  double elevation = 5.0;
  void _navigateToPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget.destinationPage),
    );
  }
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cardWidth = screenSize.width * 0.9;
    final cardHeight = max((screenSize.height * 0.65) / 3, 120.0);

    return GestureDetector(
      onTapDown: (_) => setState(() => elevation = 1.0),
      onTapUp: (_) => setState(() {
        elevation = 5.0;
        _navigateToPage(context);
      }),
      onTapCancel: () => setState(() => elevation = 5.0),
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: Card(
          elevation: elevation,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  widget.cardText,
                  style: TextStyle(
                    fontSize: 20, //
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8), // title and description
                SizedBox(
                  width: cardWidth * 0.65, // for image on right
                  child: Text(
                    widget.description,
                    style: TextStyle(
                      fontSize: 16, 
                    ),
                  ),
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}
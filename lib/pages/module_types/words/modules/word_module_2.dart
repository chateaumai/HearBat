import 'package:flutter/material.dart';
import 'package:hearbat/utils/google_tts.dart';

class WordModule2 extends StatelessWidget {

  final GoogleTTS googleTTS = GoogleTTS();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Module 2'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () =>
                  googleTTS.playVoice("Tim", "en-US-Studio-O"), // First button "en-US-Polyglot-1"
              child: Text('Play "Tim"'),
            ),
            SizedBox(height: 20), // Adds space between the buttons
            ElevatedButton(
              onPressed: () =>
                  googleTTS.playVoice("Tin", "en-US-Studio-Q"), // Second button
              child: Text('Play "Tin"'),
            ),
            // Add more buttons or functionality as needed
          ],
        ),
      ),
    );
  }
}
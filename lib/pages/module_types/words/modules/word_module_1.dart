
import 'package:flutter/material.dart';
import 'package:hearbat/utils/google_tts.dart';

class WordModule1 extends StatelessWidget {

  final GoogleTTS googleTTS = GoogleTTS();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Module 1'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () =>
                  googleTTS.playVoice("Hello", "en-US-Studio-O"), // First button "en-US-Polyglot-1"
              child: Text('Play "Hello"'),
            ),
            SizedBox(height: 20), // Adds space between the buttons
            ElevatedButton(
              onPressed: () =>
                  googleTTS.playVoice("Goodbye", "en-US-Studio-Q"), // Second button
              child: Text('Play "Goodbye"'),
            ),
            // Add more buttons or functionality as needed
          ],
        ),
      ),
    );
  }
}



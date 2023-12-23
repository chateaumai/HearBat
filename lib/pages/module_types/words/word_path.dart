import 'package:flutter/material.dart';
import 'package:hearbat/utils/google_tts.dart';

class WordPath extends StatelessWidget {
  // Instance of GoogleTTS
  final GoogleTTS googleTTS = GoogleTTS();

  Future<void> playVoice(String text, String voiceType) async {
    try {
      await googleTTS.speak(text, voiceType);
      // Add logic or UI update to indicate success if necessary
    } catch (e) {
      print("Error in playVoice: $e");
      // Add logic or UI update to indicate failure if necessary
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Modules'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () =>
                  playVoice("Hello World", "en-US-Studio-O"), // First button
              child: Text('Play "Hello"'),
            ),
            SizedBox(height: 20), // Adds space between the buttons
            ElevatedButton(
              onPressed: () =>
                  playVoice("Goodbye World", "en-US-Studio-Q"), // Second button
              child: Text('Play "Goodbye"'),
            ),
            // Add more buttons or functionality as needed
          ],
        ),
      ),
    );
  }
}

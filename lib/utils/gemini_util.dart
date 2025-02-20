import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:http/http.dart' as http;

import '../utils/text_util.dart';

class GeminiUtil {
  // Generates AI-generated content based on a list of words.
  // It connects to the Google Gemini AI model to generate additional words.
  static Future<String> generateContent(List<String> wordsToBeCompared) async {
    http.Client client = http.Client();
    try {
      // Prepares the user input and determines the number of additional words needed.
      final wordInput = wordsToBeCompared.join(' ');
      final wordsNeeded = 4 - wordsToBeCompared.length;
      final prompt = getPrompt(wordsNeeded, wordInput);

      // Prompt the LLM
      final model =
          FirebaseVertexAI.instance.generativeModel(model: 'gemini-2.0-flash');
      final response = await model.generateContent([Content.text(prompt)]);

      return response.text ?? "";
    } catch (e) {
      print("Error in GeminiUtil.generateContent: $e");
      throw Exception("Error occurred in GeminiUtil.generateContent: $e");
    } finally {
      client.close();
    }
  }
}

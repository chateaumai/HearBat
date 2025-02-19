import 'dart:convert';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';

import '../utils/text_util.dart';
import '../utils/config_util.dart';

class GeminiUtil {
  // Loads the Google Cloud API key from the configuration manager.
  static Future<String> _loadCredentials() async {
    String apiKey = ConfigurationManager().googleCloudAPIKey;
    return apiKey;
  }

  // Generates AI-generated content based on a list of words.
  // It connects to the Google Gemini AI model to generate additional words.
  static Future<String> generateContent(List<String> wordsToBeCompared) async {
    http.Client client = http.Client();
    try {
      // Prepares the user input and determines the number of additional words needed.
      String wordInput = wordsToBeCompared.join(' ');
      int wordsNeeded = 4 - wordsToBeCompared.length;
      String prompt = getPrompt(wordsNeeded, wordInput);
      print(prompt); // for debug

      // Prompt the LLM
      final model = FirebaseVertexAI.instance.generativeModel(model: 'gemini-2.0-flash');
      final response = await model.generateContent([Content.text(prompt)]);
      print(response.text);

      return response?.text ?? "";
    } catch (e) {
      print("Error in GeminiUtil.generateContent: $e");
      throw Exception("Error occurred in GeminiUtil.generateContent: $e");
    } finally {
      client.close();
    }
  }
}

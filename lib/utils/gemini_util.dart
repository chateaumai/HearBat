import 'dart:convert';
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
      String jsonString = await _loadCredentials();
      var jsonCredentials = jsonDecode(jsonString);
      String projectId = jsonCredentials['project_id'];
      print(projectId);

      // Authenticates using Google Service Account credentials.
      final accountCredentials =
          ServiceAccountCredentials.fromJson(jsonCredentials);
      AccessCredentials credentials =
          await obtainAccessCredentialsViaServiceAccount(accountCredentials,
              ['https://www.googleapis.com/auth/cloud-platform'], client);

      String url =
          "https://us-west1-aiplatform.googleapis.com/v1/projects/$projectId/locations/us-west1/publishers/google/models/gemini-pro:streamGenerateContent";

      // Prepares the user input and determines the number of additional words needed.
      String wordInput = wordsToBeCompared.join(' ');
      int wordsNeeded = 4 - wordsToBeCompared.length;
      String prompt = getPrompt(wordsNeeded, wordInput);
      print(prompt);

      // Creates the request payload with AI model parameters.
      var body = json.encode({
        "contents": [
          {
            "role": "USER",
            "parts": [
              {"text": prompt}
            ]
          }
        ],
        "safetySettings": [
          {
            "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
            "threshold": "BLOCK_NONE"
          },
          {"category": "HARM_CATEGORY_HATE_SPEECH", "threshold": "BLOCK_NONE"},
          {"category": "HARM_CATEGORY_HARASSMENT", "threshold": "BLOCK_NONE"},
          {
            "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
            "threshold": "BLOCK_NONE"
          },
        ],
        "generationConfig": {
          "temperature": 0.9,
          "candidateCount": 1,
          "maxOutputTokens": 50,
          "topP": 0.0,
        }
      });
      // print(prompt);
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${credentials.accessToken.data}"
        },
        body: body,
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        List<String> allTexts = [];

        // Extracts text content from the API response.
        for (var candidateData in jsonData) {
          for (var candidate in candidateData['candidates']) {
            for (var part in candidate['content']['parts']) {
              if (part.containsKey('text')) {
                allTexts.add(part['text']);
              }
            }
          }
        }

        // Combines all generated texts into a single string.
        String combinedTexts = allTexts.join(' ');
        return combinedTexts;
      } else {
        throw Exception(
            "Failed to get a valid response from the API: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in GeminiUtil.generateContent: $e");
      throw Exception("Error occurred in GeminiUtil.generateContent: $e");
    } finally {
      client.close();
    }
  }
}

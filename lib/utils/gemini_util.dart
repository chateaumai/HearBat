import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import '../utils/text_util.dart';
import '../utils/config_util.dart';

class GeminiUtil {
  static Future<String> _loadCredentials() async {
    String apiKey = ConfigurationManager().googleCloudAPIKey;
    return apiKey;
  }

  static Future<String> generateContent(List<String> wordsToBeCompared) async {
    http.Client client = http.Client();
    try {
      String jsonString = await _loadCredentials();
      var jsonCredentials = jsonDecode(jsonString);
      String projectId = jsonCredentials['project_id'];
      print(projectId);

      final accountCredentials = ServiceAccountCredentials.fromJson(jsonCredentials);
      AccessCredentials credentials = await obtainAccessCredentialsViaServiceAccount(
          accountCredentials, 
          ['https://www.googleapis.com/auth/cloud-platform'],
          client);

      String url = 
      "https://us-west1-aiplatform.googleapis.com/v1/projects/$projectId/locations/us-west1/publishers/google/models/gemini-pro:streamGenerateContent";

      String wordInput = wordsToBeCompared.join(' ');
      int wordsNeeded = 4 - wordsToBeCompared.length;
      String prompt = getPrompt(wordsNeeded, wordInput);
      print(prompt);
      var body = json.encode({
        "contents": [
          {
            "role": "USER",
            "parts": [
              {
                "text": prompt
              }
            ]
          }
        ],
        "safetySettings": [
          {
            "category" : "HARM_CATEGORY_SEXUALLY_EXPLICIT",
            "threshold" : "BLOCK_NONE"
          },
          {
            "category" : "HARM_CATEGORY_HATE_SPEECH",
            "threshold" : "BLOCK_NONE"
          },
          {
            "category" : "HARM_CATEGORY_HARASSMENT",
            "threshold" : "BLOCK_NONE"
          },
          {
            "category" : "HARM_CATEGORY_DANGEROUS_CONTENT",
            "threshold" : "BLOCK_NONE"
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
        for (var candidateData in jsonData) {
          for (var candidate in candidateData['candidates']) {
            for (var part in candidate['content']['parts']) {
              if (part.containsKey('text')) {
                allTexts.add(part['text']);
              }
            }
          }
        }
        String combinedTexts = allTexts.join(' ');
        // print(combinedTexts); 
        return combinedTexts;
      } else {
        throw Exception("Failed to get a valid response from the API: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in GeminiUtil.generateContent: $e");
      throw Exception("Error occurred in GeminiUtil.generateContent: $e");
    } finally {
      client.close();
    }
  }
}

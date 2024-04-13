import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import '../utils/config_util.dart';

class GoogleSTTUtil {
  final Map<String, String> cache = {};

  Future<String> _loadCredentials() async {
    String apiKey = ConfigurationManager().googleCloudAPIKey;
    return apiKey;
  }

  Future<String> transcribeAudio(String filePath) async {
    File file = File(filePath);
    if (!await file.exists()) {
      throw Exception("Audio file does not exist at the specified path.");
    }

    String? transcript = cache[filePath];
    if (transcript != null) {
      return transcript;
    }

    http.Client client = http.Client();
    try {
      String jsonString = await _loadCredentials();
      var jsonCredentials = jsonDecode(jsonString);

      final accountCredentials =
          ServiceAccountCredentials.fromJson(jsonCredentials);
      AccessCredentials credentials =
          await obtainAccessCredentialsViaServiceAccount(
        accountCredentials,
        ['https://www.googleapis.com/auth/cloud-platform'],
        client,
      );

      String url = "https://speech.googleapis.com/v1/speech:recognize";
      var body = json.encode({
        "config": {
          "encoding": "LINEAR16",
          "sampleRateHertz": 16000,
          "languageCode": "en-US",
          "model": "default",
          "enableAutomaticPunctuation": true,
        },
        "audio": {"content": base64Encode(await file.readAsBytes())},
      });

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
        if (jsonData['results'] != null) {
          transcript = jsonData['results'][0]['alternatives'][0]['transcript'];
          if (transcript != null) {
            cache[filePath] = transcript;
            return transcript;
          } else {
            throw Exception("Transcript is null");
          }
        } else {
          throw Exception("Results field is null");
        }
      } else {
        throw Exception(
            "Failed to get a valid response from the API: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in GoogleSTTUtil.transcribeAudio: $e");
      throw Exception("Error occurred in GoogleSTTUtil.transcribeAudio: $e");
    } finally {
      client.close();
    }
  }
}

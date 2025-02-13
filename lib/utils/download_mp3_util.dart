import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/texttospeech/v1.dart' as tts;
import '../utils/config_util.dart';

// Loads the Google Cloud API key from the configuration manager.
Future<String> loadCredentials() async {
  String apiKey = ConfigurationManager().googleCloudAPIKey;
  return apiKey;
}

// Connects to the Google Text-to-Speech API and synthesizes speech from text.
// Takes the input `text` and `voicetype`, and makes a request using the given `client`.
// Returns the HTTP response containing the synthesized audio.
Future<http.Response> connectAPI(
    String text, String voicetype, http.Client client) async {
  String jsonString = await loadCredentials();
  var jsonCredentials = jsonDecode(jsonString);

  // Loads Google service account credentials.
  final accountCredentials =
      ServiceAccountCredentials.fromJson(jsonCredentials);
  AccessCredentials credentials =
      await obtainAccessCredentialsViaServiceAccount(
    accountCredentials,
    [tts.TexttospeechApi.cloudPlatformScope],
    client,
  );

  String url = "https://texttospeech.googleapis.com/v1/text:synthesize";

  // Configures the request payload for text-to-speech conversion.
  var body = json.encode({
    "audioConfig": {"audioEncoding": "LINEAR16", "pitch": 0, "speakingRate": 1},
    "input": {"text": text},
    "voice": {"languageCode": "en-US", "name": voicetype}
  });

  // Sends a POST request to the Text-to-Speech API.
  final response = await http.post(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${credentials.accessToken.data}"
    },
    body: body,
  );
  return response;
}

// Downloads MP3 audio files for a list of words using Google Text-to-Speech.
// Takes `wordList` (list of words) and `voicetype` as input.
// Each word is sent to the API, and the resulting audio file is saved locally.
Future<void> downloadMP3(List<String> wordList, String voicetype) async {
  http.Client client = http.Client();
  try {
    for (var word in wordList) {
      try {
        // Calls the API to synthesize speech for the word.
        final response = await connectAPI(word, voicetype, client);

        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);
          String audioBase64 = jsonData['audioContent'];
          Uint8List bytes = base64Decode(audioBase64);

          // Defines the directory path to save the MP3 files.
          String dirPath = '..\\..\\assets\\audio\\words\\chap_1_mod_1';
          File file = File(path.join(dirPath, "$word.mp3"));
          await file.writeAsBytes(bytes);
          print("Downloaded $word.mp3 successfully.");
        } else {
          print(
              "Failed to get a valid response from the API: ${response.statusCode}");
        }
      } catch (e) {
        print("Error while processing word $word: $e");
      }
    }
  } catch (e) {
    print("Error occurred in downloadMP3: $e");
  } finally {
    client.close();
  }
}

void main() async {
  List<String> wordList = [
    'Aaron',
    'Daniel',
    'Andy',
  ];

  await downloadMP3(wordList, 'en-US-Studio-O');
}

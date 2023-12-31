import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/texttospeech/v1.dart' as tts;

  Future<String> loadCredentials() async {
    var file = File('..\\..\\hearbat-408909-40d76f6c489d.json');
    return file.readAsString();
  }

  Future<http.Response> connectAPI(String text, String voicetype, http.Client client) async {
    String jsonString = await loadCredentials();
    var jsonCredentials = jsonDecode(jsonString);

    final accountCredentials =
        ServiceAccountCredentials.fromJson(jsonCredentials);
    AccessCredentials credentials =
        await obtainAccessCredentialsViaServiceAccount(accountCredentials,
            [tts.TexttospeechApi.cloudPlatformScope], client);

    String url = "https://texttospeech.googleapis.com/v1/text:synthesize";
    var body = json.encode({
      "audioConfig": {
        "audioEncoding": "LINEAR16",
        "pitch": 0,
        "speakingRate": 1
      },
      "input": {"text": text},
      "voice": {"languageCode": "en-US", "name": voicetype}
    });

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

  Future<void> downloadMP3(List<String> wordList, String voicetype) async {
  http.Client client = http.Client();
  try {
    for (var word in wordList) {
      try {
        final response = await connectAPI(word, voicetype, client);

        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);
          String audioBase64 = jsonData['audioContent'];
          Uint8List bytes = base64Decode(audioBase64);

          String dirPath = '..\\..\\assets\\audio\\words\\chap_1_mod_1';
          File file = File(path.join(dirPath, "$word.mp3"));
          await file.writeAsBytes(bytes);
          print("Downloaded $word.mp3 successfully.");
        } else {
          print("Failed to get a valid response from the API: ${response.statusCode}");
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
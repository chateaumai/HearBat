import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/texttospeech/v1.dart' as tts;

class GoogleTTSUtil {
  final AudioPlayer audioPlayer = AudioPlayer();

  Future<String> _loadCredentials() async {
    return await rootBundle.loadString('hearbat-408909-40d76f6c489d.json');
  }

  Future<void> speak(String text, String voicetype) async {
    http.Client client = http.Client();
    try {
      String jsonString = await _loadCredentials();
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

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        String audioBase64 = jsonData['audioContent'];

        Uint8List bytes = base64Decode(audioBase64);
        String dir = (await getApplicationDocumentsDirectory()).path;
        File file = File("$dir/${DateTime.now().millisecondsSinceEpoch}.mp3");
        await file.writeAsBytes(bytes);

        await audioPlayer.play(DeviceFileSource(file.path));
      } else {
        throw Exception(
            "Failed to get a valid response from the API: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in GoogleTTSUtil.speak: $e");
      throw Exception("Error occurred in GoogleTTSUtil.speak: $e");
    } finally {
      client.close();
    }
  }

  Future<void> playVoice(String text, String voiceType) async {
    try {
      await speak(text, voiceType);
      // Add logic or UI update to indicate success if necessary
    } catch (e) {
      print("Error in playVoice: $e");
      // Add logic or UI update to indicate failure if necessary
    }
  }
}

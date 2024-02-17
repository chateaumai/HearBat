import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/texttospeech/v1.dart' as tts;
import '../utils/config_util.dart';

class GoogleTTSUtil {
  final AudioPlayer audioPlayer = AudioPlayer();
  final Map<String, String> cache = {};

  Future<String> _loadCredentials() async {
    String apiKey = ConfigurationManager().googleCloudAPIKey;
    return apiKey;
  }

  Future<void> speak(String text, String voicetype) async {
    String? audioPath = cache["${text}_$voicetype"];

    if (audioPath != null && await File(audioPath).exists()) {
      await audioPlayer.play(DeviceFileSource(audioPath));
    } else {
      await downloadMP3(text, voicetype);

      audioPath = cache["${text}_$voicetype"];
      if (audioPath != null) {
        await audioPlayer.play(DeviceFileSource(audioPath));
      } else {
        throw Exception("Failed to download MP3 for: $text");
      }
    }
  }

  Future<void> downloadMP3(String text, String voicetype) async {
    String dir = (await getTemporaryDirectory()).path;
    String filePath = "$dir/${text}_$voicetype.mp3";
    File file = File(filePath);

    if (await file.exists()) {
      cache["${text}_$voicetype"] = filePath;
      return;
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
        [tts.TexttospeechApi.cloudPlatformScope],
        http.Client(),
      );

      String url = "https://texttospeech.googleapis.com/v1/text:synthesize";
      var body = json.encode({
        "audioConfig": {"audioEncoding": "MP3", "pitch": 0, "speakingRate": 1},
        "input": {"text": text},
        "voice": {"languageCode": voicetype.substring(0, 5), "name": voicetype}
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
        await file.writeAsBytes(bytes);

        cache["${text}_$voicetype"] = filePath;
      } else {
        throw Exception(
            "Failed to get a valid response from the API: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in GoogleTTSUtil.downloadMP3: $e");
      throw Exception("Error occurred in GoogleTTSUtil.downloadMP3: $e");
    } finally {
      client.close();
    }
  }
}

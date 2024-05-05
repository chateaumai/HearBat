import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/texttospeech/v1.dart' as tts;
import '../utils/config_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleTTSUtil {
  final AudioPlayer audioPlayer = AudioPlayer();
  final Map<String, String> cache = {};

  String _difficulty = 'Normal';

  GoogleTTSUtil() {
    _loadDifficultyPreference();
  }

  Future<void> _loadDifficultyPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _difficulty = prefs.getString('difficultyPreference') ?? 'Normal';
  }

  Future<String> _loadCredentials() async {
    String apiKey = ConfigurationManager().googleCloudAPIKey;
    return apiKey;
  }

  Future<void> speak(String text, String voicetype) async {
    // Determine the text to speak based on difficulty
    String textToSpeak = (_difficulty == 'Hard' &&
            text != "Hello this is how I sound" &&
            text.length < 15)
        ? "Please select $text as the answer"
        : text;

    String? audioPath = cache["${text}_$voicetype"];

    if (audioPath != null && await File(audioPath).exists()) {
      await audioPlayer.play(DeviceFileSource(audioPath));
    } else {
      await downloadMP3(textToSpeak, voicetype);

      // Update the cache after downloading
      audioPath = cache["${text}_$voicetype"];

      if (audioPath != null && await File(audioPath).exists()) {
        await audioPlayer.play(DeviceFileSource(audioPath));
      } else {
        throw Exception("Failed to download MP3 for: $textToSpeak");
      }
    }
  }

  Future<void> downloadMP3(String text, String voicetype) async {
    String dir = (await getTemporaryDirectory()).path;

    List<String> textsToDownload;
    if (_difficulty == 'Hard') {
      textsToDownload = [text, "Please select $text as the answer"];
    } else {
      textsToDownload = [text];
    }

    for (String textToDownload in textsToDownload) {
      String safeText =
          textToDownload.replaceAll(RegExp(r'\s+'), '').toLowerCase();
      String filePath = "$dir/${safeText}_$voicetype.mp3";
      File file = File(filePath);

      if (await file.exists()) {
        cache["${safeText}_$voicetype"] = filePath;
        continue;
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
          "audioConfig": {
            "audioEncoding": "MP3",
            "pitch": 0,
            "speakingRate": 1
          },
          "input": {"text": textToDownload},
          "voice": {
            "languageCode": voicetype.substring(0, 5),
            "name": voicetype
          }
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

          cache["${textToDownload}_$voicetype"] = filePath;
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
}

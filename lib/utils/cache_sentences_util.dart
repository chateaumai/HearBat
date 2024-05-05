import 'package:hearbat/utils/google_tts_util.dart';
import 'dart:async';

class CacheSentencesUtil {
  final GoogleTTSUtil googleTTSUtil = GoogleTTSUtil();

  Future<void> cacheSentences(List<String> sentences, String voiceType) async {
    // Create a list to hold all the futures for the concurrent downloads
    List<Future> downloadFutures = [];

    for (var sentence in sentences) {
      // Instead of awaiting each download, add it to the list
      downloadFutures
          .add(googleTTSUtil.downloadMP3(sentence, voiceType).catchError((e) {
        print("Error downloading $sentence: $e");
      }));
    }

    // Wait for all downloads to complete
    await Future.wait(downloadFutures);
  }
}

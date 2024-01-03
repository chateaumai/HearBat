import 'package:hearbat/utils/google_tts_util.dart';
import 'package:hearbat/data/answer_pair.dart';
import 'dart:async';

class CacheWordsUtil {
  final GoogleTTSUtil googleTTSUtil = GoogleTTSUtil();

  Future<void> cacheModuleWords(
      List<AnswerGroup> module, String voiceType) async {
    // Create a list to hold all the futures for the concurrent downloads
    List<Future> downloadFutures = [];

    for (var group in module) {
      List<Answer> answers = [
        group.answer1,
        group.answer2,
        group.answer3,
        group.answer4
      ];
      for (var answer in answers) {
        // Instead of awaiting each download, add it to the list
        downloadFutures.add(
            googleTTSUtil.downloadMP3(answer.answer, voiceType).catchError((e) {
          print("Error downloading ${answer.answer}: $e");
        }));
      }
    }

    // Wait for all downloads to complete
    await Future.wait(downloadFutures);
  }
}

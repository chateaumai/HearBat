import '../data/answer_pair.dart';
import '../data/word_modules_data.dart';
import '../data/sound_modules_data.dart';
import '../data/speech_modules_data.dart';

Map<String, List<AnswerGroup>> getModulesForChapter(String chapter) {
  switch (chapter) {
    case "Beginner Foundations":
      return chapter1wordModules;
    case "Intermediate Progress":
      return chapter2wordModules;
    case "Advanced Exploration":
      return chapter3wordModules;
    case "Proficient Application":
      return chapter4wordModules;
    case "Expert Mastery":
      return chapter5wordModules;
    case "Từ Dễ":
      return chapter1wordModulesVn;

    // Sound Chapters
    case "Home Sounds":
      return chapter1soundModules;
    case "Music Sounds":
      return chapter2soundModules;
    case "Nature Sounds":
      return chapter3soundModules;

    default:
      return {}; // Return an empty map if none of the cases match
  }
}

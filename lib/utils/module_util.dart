import '../data/answer_pair.dart';
import '../data/word_modules_data.dart';
import '../data/sound_modules_data.dart';

Map<String, List<AnswerGroup>> getModulesForChapter(String chapter) {
  switch (chapter) {
    case "Short 'a' Sound":
      return chapter1wordModules;
    case "Short 'e' Sound":
      return chapter2wordModules;
    case "Short 'i' Sound":
      return chapter3wordModules;
    case "Short 'o' Sound":
      return chapter4wordModules;
    case "Short 'u' Sound":
      return chapter5wordModules;
    case "Buzzing and Hissing Sound":
      return chapter6wordModules;
    case "Vowel Slides (Diphthongs)":
      return chapter7wordModules;
    case "Nose Sounds (Nasals)":
      return chapter8wordModules;
    case "Throaty Sounds (Gutturals)":
      return chapter9wordModules;
    case "Tongue-Tip Sounds (Alveolars)":
      return chapter10wordModules;

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

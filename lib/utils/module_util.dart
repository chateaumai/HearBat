import '../data/answer_pair.dart';
import '../data/word_modules_data.dart';

Map<String, List<AnswerGroup>> getModulesForChapter(String chapter) {
  if (chapter == "Short 'a' Sound") {
    return chapter1wordModules;
  } else if (chapter == "Short 'e' Sound") {
    return chapter2wordModules;
  } else if (chapter == "Short 'i' Sound") {
    return chapter3wordModules;
  } else if (chapter == "Short 'o' Sound") {
    return chapter4wordModules;
  } else if (chapter == "Short 'u' Sound") {
    return chapter5wordModules;
  } else if (chapter == "Buzzing and Hissing Sound") {
    return chapter6wordModules;
  } else if (chapter == "Vowel Slides (Diphthongs)") {
    return chapter7wordModules;
  } else if (chapter == "Nose Sounds (Nasals)") {
    return chapter8wordModules;
  } else if (chapter == "Throaty Sounds (Gutturals)") {
    return chapter9wordModules;
  } else if (chapter == "Tongue-Tip Sounds (Alveolars)") {
    return chapter10wordModules;
  }
  return {};
}

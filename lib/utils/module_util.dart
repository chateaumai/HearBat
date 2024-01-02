import '../data/answer_pair.dart';
import '../data/word_modules_data.dart';

Map<String, List<AnswerGroup>> getModulesForChapter(String chapter) {
  if (chapter == "Chapter 1") {
    return chapter1wordModules;
  } else if (chapter == "Chapter 2") {
    return chapter2wordModules;
  }
  return {}; 
}
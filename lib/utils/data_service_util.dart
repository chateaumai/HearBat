import 'dart:convert';
import 'package:flutter/services.dart';
import '../data/answer_pair.dart';

class DataService {
  static final DataService _instance = DataService._internal();

  factory DataService() {
    return _instance;
  }

  DataService._internal();

  Map<String, Chapter> _speechChapters = {};
  Map<String, Chapter> _soundChapters = {};
  Map<String, Chapter> _wordChapters = {};

  Future<void> loadJson() async {

    if(_soundChapters.isEmpty) {
      String jsonString = await rootBundle.loadString('lib/data/sound_modules_data.json');
      Map<String, dynamic> jsonData = json.decode(jsonString);
      _soundChapters = {for (var chapter in jsonData['chapters']) chapter['name'] : Chapter.fromJson(chapter)};
    }

    if(_wordChapters.isEmpty) {
      String jsonString = await rootBundle.loadString('lib/data/word_modules_data.json');
      Map<String, dynamic> jsonData = json.decode(jsonString);
      _wordChapters = {for (var chapter in jsonData['chapters']) chapter['name'] : Chapter.fromJson(chapter)};
    }

  }

  Chapter getSoundChapter(String chapter) => _soundChapters[chapter] ?? Chapter.empty();
  Chapter getWordChapter(String chapter) => _wordChapters[chapter] ?? Chapter.empty();
}
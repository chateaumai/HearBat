import 'package:flutter/material.dart';
import '../pages/module_types/words/modules/word_module_1.dart';
class WordModule {
  final String title;
  final Widget page;

  WordModule(this.title, this.page);
}

class SoundModule {
  final String title;
  final Widget page;
  SoundModule(this.title, this.page);
}

class PitchModule {
  final String title;
  final Widget page;
  PitchModule(this.title, this.page);
}

List<WordModule> wordModules = [
  WordModule('Module 1', WordModule1()),
];

import 'package:flutter/material.dart';
import '../pages/module_types/words/modules/word_modules.dart';

abstract class Module {
  String get title;
  Widget get page;
}

class WordModule implements Module {
  @override
  final String title;
  @override
  final Widget page;

  WordModule(this.title, this.page);
}

class SoundModule implements Module {
  @override
  final String title;
  @override
  final Widget page;

  SoundModule(this.title, this.page);
}

class PitchModule implements Module {
  @override
  final String title;
  @override
  final Widget page;

  PitchModule(this.title, this.page);
}

List<WordModule> wordModules = [
  WordModule('Module 1 (Hello)', WordModule1()),
  WordModule('Module 2 (Tim & Tin)', WordModule2()),
];

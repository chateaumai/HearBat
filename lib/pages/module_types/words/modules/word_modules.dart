import 'package:flutter/material.dart';
import '../../../../data/word_modules_data.dart';
import '../../../../widgets/word_module_widget.dart';
import '../../../../pages/module_types/custom/modules/display_module_screen.dart';

class WordModule1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WordModuleWidget(
      title: 'Word Module 1',
      wordPairs: wordModules['Module1'] ?? [],
    );
  }
}

class WordModule2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WordModuleWidget(
      title: 'Word Module 2',
      wordPairs: wordModules['Module2'] ?? [],
    );
  }
}




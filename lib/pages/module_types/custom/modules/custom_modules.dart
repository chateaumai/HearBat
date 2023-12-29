import 'package:flutter/material.dart';
import 'package:hearbat/models/word_pair.dart';
import '../../../../widgets/word_module_widget.dart';

class CustomModule extends StatelessWidget {
  final String moduleName;
  final List<WordPair> wordPairs;

  CustomModule({required this.moduleName, required this.wordPairs});

  @override
  Widget build(BuildContext context) {
    return WordModuleWidget(
      title: moduleName,
      wordPairs: wordPairs,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hearbat/models/word_pair.dart';

class DisplayModuleScreen extends StatelessWidget {
  final String moduleName;
  final List<WordPair> wordPairs;

  DisplayModuleScreen({required this.moduleName, required this.wordPairs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(moduleName), // Display the module name
      ),
      body: ListView.builder(
        itemCount: wordPairs.length,
        itemBuilder: (context, index) {
          return ListTile(
            title:
                Text('${wordPairs[index].wordA} - ${wordPairs[index].wordB}'),
          );
        },
      ),
    );
  }
}

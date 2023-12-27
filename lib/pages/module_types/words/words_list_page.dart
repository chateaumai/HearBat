import 'package:flutter/material.dart';
import '../../../../data/word_modules_data.dart';
class WordsList extends StatelessWidget {
  WordsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word List'),
      ),
    );
  }
}
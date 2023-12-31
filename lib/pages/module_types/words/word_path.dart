import 'package:flutter/material.dart';
import 'package:hearbat/data/answer_pair.dart';
import '../../../data/word_modules_data.dart';

class WordPath extends StatelessWidget {
  final String chapter;

  WordPath({Key? key, required this.chapter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<AnswerGroup> wordGroups = getWordGroupsForChapter(chapter);

    return Scaffold(
      appBar: AppBar(
        title: Text('Word Modules - $chapter'),
      ),
      body: ListView.builder(
        itemCount: wordGroups.length,
        itemBuilder: (context, index) {
          AnswerGroup group = wordGroups[index];
          return Card(
            child: ListTile(
              title: Text('Word Group'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Word 1: ${group.answer1.answer} (${group.answer1.path})'),
                  Text(
                      'Word 2: ${group.answer2.answer} (${group.answer2.path})'),
                  Text(
                      'Word 3: ${group.answer3.answer} (${group.answer3.path})'),
                  Text(
                      'Word 4: ${group.answer4.answer} (${group.answer4.path})'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<AnswerGroup> getWordGroupsForChapter(String chapter) {
    if (chapter == "Chapter 1") {
      return chapter1module1WordGroups + chapter1module2WordGroups;
    } else if (chapter == "Chapter 2") {
      return chapter1module2WordGroups;
    }
    return [];
  }
}

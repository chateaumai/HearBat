import 'package:flutter/material.dart';
import 'package:hearbat/utils/user_module_util.dart';
import 'package:hearbat/data/answer_pair.dart';
import '../utils/gemini_util.dart';
import '../utils/text_util.dart';

class CustomUtil extends StatefulWidget {
  final Function(String) onModuleSaved;

  CustomUtil({required this.onModuleSaved});

  @override
  CustomUtilState createState() => CustomUtilState();
}

class CustomUtilState extends State<CustomUtil> {
  List<TextEditingController> _controllers = [
    TextEditingController(), // Initial Word A1
    TextEditingController(), // Initial Word A2
    TextEditingController(), // Initial Word A3
    TextEditingController(), // Initial Word A4
  ];
  TextEditingController _moduleNameController = TextEditingController();

  void _addNewPair() {
    if (_controllers.length < 40) {
      setState(() {
        _controllers.addAll([
          TextEditingController(),
          TextEditingController(),
          TextEditingController(),
          TextEditingController(),
        ]);
      });
    }
  }

  void _removePair(int index) {
    if (_controllers.length > 4) {
      setState(() {
        _controllers.removeRange(index, index + 4);
      });
    }
  }

  void _saveModule() async {
    List<AnswerGroup> answerGroups = [];
    for (int i = 0; i < _controllers.length; i += 4) {
      String answer1 = _controllers[i].text.trim();
      String answer2 = _controllers[i + 1].text.trim();
      String answer3 = _controllers[i + 2].text.trim();
      String answer4 = _controllers[i + 3].text.trim();
      
      if (answer1.isNotEmpty &&
          answer2.isNotEmpty &&
          answer3.isNotEmpty &&
          answer4.isNotEmpty) {
        AnswerGroup group = AnswerGroup(
          Answer(answer1, "", ""),
          Answer(answer2, "", ""),
          Answer(answer3, "", ""),
          Answer(answer4, "", ""),
        );
        answerGroups.add(group);
      } else if (answer1.isNotEmpty ||
          answer2.isNotEmpty ||
          answer3.isNotEmpty ||
          answer4.isNotEmpty) {

        List<String> wordsToBeCompared = [];
        if (answer1.isNotEmpty) {
          wordsToBeCompared.add(answer1);
        }
        if (answer2.isNotEmpty) {
          wordsToBeCompared.add(answer2);
        }
        if (answer3.isNotEmpty) {
          wordsToBeCompared.add(answer3);
        }
        if (answer4.isNotEmpty) {
          wordsToBeCompared.add(answer4);
        }

        String llmOutput = await GeminiUtil.generateContent(wordsToBeCompared);
        List<String> words = llmOutput.split('\n');

        for (String word in words) {
          String trimmedWord = word.trim();
          trimmedWord = stripNonAlphaCharacters(trimmedWord);
          if (trimmedWord.isNotEmpty) {
            wordsToBeCompared.add(trimmedWord); 
          }
        }
        if (wordsToBeCompared.length == 4) {
          AnswerGroup group = AnswerGroup(
            Answer(wordsToBeCompared[0], "", ""),
            Answer(wordsToBeCompared[1], "", ""),
            Answer(wordsToBeCompared[2], "", ""),
            Answer(wordsToBeCompared[3], "", ""),
          );
          answerGroups.add(group);
        }
        else {
          print("Not enough words");
        }
      }
    }

    String moduleName = _moduleNameController.text.trim();
    if (moduleName.isNotEmpty && answerGroups.isNotEmpty) {
      try {
        await UserModuleUtil.saveCustomModule(moduleName, answerGroups);
        if (!mounted) return;
        widget.onModuleSaved(moduleName);
        print("Module saved successfully!");
      } catch (e) {
        print("Failed to save module: $e");
      }
    } else {
      print("Incomplete input. Ensure all fields are filled and try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Custom Module"),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _moduleNameController,
              decoration: InputDecoration(
                labelText: 'Module Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ...List.generate(
            _controllers.length ~/ 4,
            (index) => Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _controllers[index * 4],
                          decoration: InputDecoration(
                            labelText: '${index + 1}A',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _controllers[index * 4 + 1],
                          decoration: InputDecoration(
                            labelText: '${index + 1}B',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _controllers[index * 4 + 2],
                          decoration: InputDecoration(
                            labelText: '${index + 1}C',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _controllers[index * 4 + 3],
                          decoration: InputDecoration(
                            labelText: '${index + 1}D',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_controllers.length > 4)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _removePair(index * 4),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          if (_controllers.length < 40)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: _addNewPair,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(40, 40),
                  backgroundColor: Colors.green,
                ),
                child: Icon(Icons.add),
            ),
          ),
          ElevatedButton(
            onPressed: _saveModule,
            child: Text("Save Module"),
          ),
        ],
      ),
    );
  }
}

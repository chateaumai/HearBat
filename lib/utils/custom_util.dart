import 'package:flutter/material.dart';
import 'package:hearbat/utils/user_module_util.dart';
import 'package:hearbat/models/word_pair.dart';

class CustomUtil extends StatefulWidget {
  final Function(String) onModuleSaved;

  CustomUtil({required this.onModuleSaved});

  @override
  CustomUtilState createState() => CustomUtilState();
}

class CustomUtilState extends State<CustomUtil> {
  List<TextEditingController> _controllers =
      List.generate(4, (index) => TextEditingController());
  TextEditingController _moduleNameController = TextEditingController();

  void _saveModule() async {
    List<WordPair> wordPairs = [];
    for (int i = 0; i < _controllers.length; i += 2) {
      String wordA = _controllers[i].text.trim();
      String wordB = _controllers[i + 1].text.trim();
      if (wordA.isNotEmpty && wordB.isNotEmpty) {
        wordPairs.add(WordPair(wordA, wordB));
      }
    }

    if (wordPairs.length == 2 && _moduleNameController.text.trim().isNotEmpty) {
      await UserModuleUtil.saveCustomModule(
          _moduleNameController.text.trim(), wordPairs);
      widget.onModuleSaved(_moduleNameController.text.trim());
    } else {
      // Handle error or notify the user
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
              2,
              (index) => Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _controllers[index * 2],
                            decoration: InputDecoration(
                                labelText: 'Word ${index + 1}A',
                                border: OutlineInputBorder()),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _controllers[index * 2 + 1],
                            decoration: InputDecoration(
                                labelText: 'Word ${index + 1}B',
                                border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                  )),
          ElevatedButton(
            onPressed: _saveModule,
            child: Text("Save Module"),
          ),
        ],
      ),
    );
  }
}

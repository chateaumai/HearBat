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
  List<TextEditingController> _controllers = [
    TextEditingController(), // Word A
    TextEditingController(), // Word B
  ];
  TextEditingController _moduleNameController =
      TextEditingController(); // Controller for module name

  void _addNewPair() {
    setState(() {
      _controllers.addAll([TextEditingController(), TextEditingController()]);
    });
  }

  void _removePair(int index) {
    if (_controllers.length > 2) {
      setState(() {
        _controllers.removeAt(index + 1); // Remove Word B
        _controllers.removeAt(index); // Remove Word A
      });
    }
  }

  void _saveModule() async {
    List<WordPair> wordPairs = [];
    for (int i = 0; i < _controllers.length; i += 2) {
      String wordA = _controllers[i].text.trim();
      String wordB = _controllers[i + 1].text.trim();
      if (wordA.isNotEmpty && wordB.isNotEmpty) {
        wordPairs.add(WordPair(wordA, wordB));
      }
    }

    String moduleName = _moduleNameController.text.trim();
    if (moduleName.isNotEmpty &&
        wordPairs.isNotEmpty &&
        wordPairs.length % 2 == 0) {
      await UserModuleUtil.saveCustomModule(moduleName, wordPairs);
      widget.onModuleSaved(moduleName);
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
          for (int i = 0; i < _controllers.length; i += 2)
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _controllers[i],
                      decoration: InputDecoration(
                        labelText: 'Word ${i ~/ 2 + 1}A',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _controllers[i + 1],
                      decoration: InputDecoration(
                        labelText: 'Word ${i ~/ 2 + 1}B',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _removePair(i),
                  ),
                ],
              ),
            ),
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

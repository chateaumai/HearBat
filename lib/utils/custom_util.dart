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
    TextEditingController(), // Initial Word A
    TextEditingController(), // Initial Word B
  ];
  TextEditingController _moduleNameController =
      TextEditingController(); // Controller for module name

  // Function to add a new word pair
  void _addNewPair() {
    setState(() {
      _controllers.addAll([TextEditingController(), TextEditingController()]);
    });
  }

  // Function to remove a specific word pair
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
    if (moduleName.isNotEmpty && wordPairs.isNotEmpty) {
      try {
        await UserModuleUtil.saveCustomModule(moduleName, wordPairs);
        if (!mounted) return;
        // Trigger the parent's callback logic, potentially handling navigation
        widget.onModuleSaved(moduleName);
      } catch (e) {
        // Log or handle the error
        print("Failed to save module: $e");
      }
    } else {
      // Show an error message or alert dialog here
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
              _controllers.length ~/ 2,
              (index) => Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _controllers[index * 2],
                            decoration: InputDecoration(
                              labelText: 'Word ${index + 1}A',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _controllers[index * 2 + 1],
                            decoration: InputDecoration(
                              labelText: 'Word ${index + 1}B',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        if (_controllers.length >
                            2) // Allow deletion if more than one pair exists
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _removePair(index * 2),
                          ),
                      ],
                    ),
                  )),
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

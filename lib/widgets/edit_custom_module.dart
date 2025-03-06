import 'package:flutter/material.dart';
import 'package:hearbat/data/answer_pair.dart';
import 'package:hearbat/utils/user_module_util.dart';

class EditModuleScreen extends StatefulWidget {
  final String moduleName;

  const EditModuleScreen({
    super.key,
    required this.moduleName,
  });

  @override
  State<EditModuleScreen> createState() => _EditModuleScreenState();
}

class _EditModuleScreenState extends State<EditModuleScreen> {
  List<AnswerGroup> answerGroups = [];
  bool isLoading = true;
  bool hasEmptyFields = false;

  @override
  void initState() {
    super.initState();
    _loadAnswerGroups();
  }

  Future<void> _loadAnswerGroups() async {
    setState(() {
      isLoading = true;
    });

    List<AnswerGroup> groups =
        await UserModuleUtil.getCustomModuleAnswerGroups(widget.moduleName);

    setState(() {
      answerGroups = groups;
      isLoading = false;
      _checkForEmptyFields();
    });
  }

  void _checkForEmptyFields() {
    bool isEmpty = false;

    for (var group in answerGroups) {
      if (group.answer1.answer.trim().isEmpty ||
          group.answer2.answer.trim().isEmpty ||
          group.answer3.answer.trim().isEmpty ||
          group.answer4.answer.trim().isEmpty) {
        isEmpty = true;
        break;
      }
    }

    setState(() {
      hasEmptyFields = isEmpty;
    });
  }

  Future<void> _saveModule() async {
    // First check if there are any empty fields
    _checkForEmptyFields();

    if (hasEmptyFields) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all answer fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    await UserModuleUtil.saveCustomModule(widget.moduleName, answerGroups);

    if (mounted) {
      setState(() {
        isLoading = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Module saved successfully')),
      );

      // Return to previous screen
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.moduleName}'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveModule,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : answerGroups.isEmpty
              ? Center(child: Text('No answer groups found for this module'))
              : Column(
                  children: [
                    if (hasEmptyFields)
                      Container(
                        color: Colors.red.shade100,
                        padding: EdgeInsets.all(8),
                        width: double.infinity,
                        child: Text(
                          'All answer fields must be filled',
                          style: TextStyle(
                            color: Colors.red.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: answerGroups.length,
                        itemBuilder: (context, index) {
                          return _buildAnswerGroupCard(
                              answerGroups[index], index);
                        },
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildAnswerGroupCard(AnswerGroup group, int groupIndex) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Answer Group ${groupIndex + 1}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildAnswerField(group.answer1, 'Answer 1', (value) {
              final updatedAnswer = Answer(
                value,
                group.answer1.path,
                group.answer1.image,
              );

              final updatedGroup = AnswerGroup(
                updatedAnswer,
                group.answer2,
                group.answer3,
                group.answer4,
              );

              setState(() {
                answerGroups[groupIndex] = updatedGroup;
                _checkForEmptyFields();
              });
            }),
            _buildAnswerField(group.answer2, 'Answer 2', (value) {
              final updatedAnswer = Answer(
                value,
                group.answer2.path,
                group.answer2.image,
              );

              final updatedGroup = AnswerGroup(
                group.answer1,
                updatedAnswer,
                group.answer3,
                group.answer4,
              );

              setState(() {
                answerGroups[groupIndex] = updatedGroup;
                _checkForEmptyFields();
              });
            }),
            _buildAnswerField(group.answer3, 'Answer 3', (value) {
              final updatedAnswer = Answer(
                value,
                group.answer3.path,
                group.answer3.image,
              );

              final updatedGroup = AnswerGroup(
                group.answer1,
                group.answer2,
                updatedAnswer,
                group.answer4,
              );

              setState(() {
                answerGroups[groupIndex] = updatedGroup;
                _checkForEmptyFields();
              });
            }),
            _buildAnswerField(group.answer4, 'Answer 4', (value) {
              final updatedAnswer = Answer(
                value,
                group.answer4.path,
                group.answer4.image,
              );

              final updatedGroup = AnswerGroup(
                group.answer1,
                group.answer2,
                group.answer3,
                updatedAnswer,
              );

              setState(() {
                answerGroups[groupIndex] = updatedGroup;
                _checkForEmptyFields();
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerField(
      Answer answer, String label, Function(String) onChanged) {
    bool isEmpty = answer.answer.trim().isEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: TextEditingController(text: answer.answer),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          errorText: isEmpty ? 'This field cannot be empty' : null,
          errorBorder: isEmpty
              ? OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                )
              : null,
        ),
        onChanged: (value) {
          onChanged(value);
        },
      ),
    );
  }
}

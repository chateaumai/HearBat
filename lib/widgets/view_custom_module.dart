import 'package:flutter/material.dart';
import 'package:hearbat/data/answer_pair.dart';
import 'package:hearbat/utils/user_module_util.dart';
import '../utils/text_util.dart';

class ViewModuleScreen extends StatefulWidget {
  final String moduleName;
  final Function? onModuleDeleted;

  const ViewModuleScreen({
    super.key,
    required this.moduleName,
    this.onModuleDeleted,
  });

  @override
  State<ViewModuleScreen> createState() => _ViewModuleScreenState();
}

class _ViewModuleScreenState extends State<ViewModuleScreen> {
  List<AnswerGroup> answerGroups = [];
  bool isLoading = true;
  bool hasEmptyFields = false;
  bool hasUnsavedChanges = false;

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

    // Debug the loaded groups
    print('===== LOADED GROUPS =====');
    for (int i = 0; i < groups.length; i++) {
      print('Group $i: ${groups[i].answer1.answer}');
    }

    setState(() {
      answerGroups = groups;
      isLoading = false;
      hasUnsavedChanges = false;
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

  void _updateAnswerField(int groupIndex, int answerIndex, String value) {
    AnswerGroup currentGroup = answerGroups[groupIndex];

    Answer currentAnswer;
    switch (answerIndex) {
      case 1:
        currentAnswer = currentGroup.answer1;
      case 2:
        currentAnswer = currentGroup.answer2;
      case 3:
        currentAnswer = currentGroup.answer3;
      case 4:
        currentAnswer = currentGroup.answer4;
      default:
        return;
    }

    String capitalizedValue = capitalizeWord(value);
    Answer updatedAnswer = Answer(
      capitalizedValue,
      currentAnswer.path,
      currentAnswer.image,
    );

    AnswerGroup updatedGroup;
    switch (answerIndex) {
      case 1:
        updatedGroup = AnswerGroup(
          updatedAnswer,
          currentGroup.answer2,
          currentGroup.answer3,
          currentGroup.answer4,
        );
      case 2:
        updatedGroup = AnswerGroup(
          currentGroup.answer1,
          updatedAnswer,
          currentGroup.answer3,
          currentGroup.answer4,
        );
      case 3:
        updatedGroup = AnswerGroup(
          currentGroup.answer1,
          currentGroup.answer2,
          updatedAnswer,
          currentGroup.answer4,
        );
      case 4:
        updatedGroup = AnswerGroup(
          currentGroup.answer1,
          currentGroup.answer2,
          currentGroup.answer3,
          updatedAnswer,
        );
      default:
        return;
    }

    // Update the state
    setState(() {
      List<AnswerGroup> newList = List<AnswerGroup>.from(answerGroups);
      newList[groupIndex] = updatedGroup;
      answerGroups = newList;
      hasUnsavedChanges = true;
      _checkForEmptyFields();
    });
  }

  Future<void> _deleteAnswerGroup(int visualIndex) async {
    print('Visual index requested to delete: $visualIndex');
    print('Total groups in list: ${answerGroups.length}');

    // Debug all groups
    for (int i = 0; i < answerGroups.length; i++) {
      print('Group $i in array: ${answerGroups[i].answer1.answer}');
    }

    if (visualIndex < 0 || visualIndex >= answerGroups.length) {
      print('ERROR: Visual index out of bounds');
      return;
    }

    AnswerGroup groupToDelete = answerGroups[visualIndex];
    print('Deleting group: ${groupToDelete.answer1.answer}');

    if (answerGroups.length == 1) {
      bool confirmed = await _showDeleteConfirmationDialog("Delete Module",
          "This is the last answer group. Deleting it will remove the entire module. Continue?");

      if (confirmed) {
        setState(() {
          isLoading = true;
        });

        setState(() {
          answerGroups = [];
          hasUnsavedChanges = true;
        });

        await UserModuleUtil.deleteCustomModule(widget.moduleName);

        if (mounted) {
          if (widget.onModuleDeleted != null) {
            widget.onModuleDeleted!();
          }
          Navigator.of(context).pop();
        }
      }
    } else {
      bool confirmed = await _showDeleteConfirmationDialog(
          "Delete Group", "Are you sure you want to delete this answer group?");

      if (confirmed) {
        List<AnswerGroup> newList = [];

        for (int i = 0; i < answerGroups.length; i++) {
          if (i != visualIndex) {
            newList.add(answerGroups[i]);
          }
        }

        print('After deletion:');
        for (int i = 0; i < newList.length; i++) {
          print('Group $i in new array: ${newList[i].answer1.answer}');
        }

        setState(() {
          answerGroups = newList;
          hasUnsavedChanges = true;
          _checkForEmptyFields();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Group deleted (unsaved)')),
        );
      }
    }
  }

  Future<bool> _showDeleteConfirmationDialog(
      String title, String message) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  child: Text('Delete'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<void> _saveModule() async {
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
        hasUnsavedChanges = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Module saved successfully')),
      );
    }
  }

  Future<bool> _onWillPop() async {
    if (hasUnsavedChanges) {
      return await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Discard changes?'),
              content: Text(
                  'You have unsaved changes. Are you sure you want to exit?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Discard'),
                ),
                TextButton(
                  onPressed: () async {
                    await _saveModule();
                    if (mounted) Navigator.of(context).pop(true);
                  },
                  child: Text('Save and Exit'),
                ),
              ],
            ),
          ) ??
          false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    print('===== BUILDING UI =====');
    print('Groups in state: ${answerGroups.length}');
    for (int i = 0; i < answerGroups.length; i++) {
      print('Building - Group $i: ${answerGroups[i].answer1.answer}');
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.moduleName),
          actions: [
            if (hasUnsavedChanges)
              Padding(
                padding: EdgeInsets.only(right: 8),
                child: Center(
                  child: Text(
                    'Unsaved changes',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
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
                          final group = answerGroups[index];
                          final uniqueId =
                              '${group.answer1.answer}_${group.answer2.answer}';

                          print(
                              'Building ListView item at index $index: ${group.answer1.answer}');
                          return _buildAnswerGroupCard(group, index,
                              key: ValueKey(uniqueId));
                        },
                      )),
                    ],
                  ),
      ),
    );
  }

  Widget _buildAnswerGroupCard(AnswerGroup group, int groupIndex, {Key? key}) {
    return Card(
      key: key,
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Answer Group ${groupIndex + 1}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteAnswerGroup(groupIndex),
                  tooltip: 'Delete this group',
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildAnswerField(group, 1, groupIndex),
            _buildAnswerField(group, 2, groupIndex),
            _buildAnswerField(group, 3, groupIndex),
            _buildAnswerField(group, 4, groupIndex),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerField(AnswerGroup group, int answerIndex, int groupIndex) {
    Answer answer;
    switch (answerIndex) {
      case 1:
        answer = group.answer1;
      case 2:
        answer = group.answer2;
      case 3:
        answer = group.answer3;
      case 4:
        answer = group.answer4;
      default:
        answer = group.answer1;
    }

    bool isEmpty = answer.answer.trim().isEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        key: ValueKey('group_${groupIndex}_answer_$answerIndex'),
        initialValue: answer.answer,
        decoration: InputDecoration(
          labelText: 'Answer $answerIndex',
          border: OutlineInputBorder(),
          errorText: isEmpty ? 'This field cannot be empty' : null,
          errorBorder: isEmpty
              ? OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                )
              : null,
        ),
        onChanged: (value) {
          _updateAnswerField(groupIndex, answerIndex, value);
        },
      ),
    );
  }
}

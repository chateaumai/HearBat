import 'package:flutter/material.dart';
import 'package:hearbat/widgets/module_list_widget.dart';
import 'package:hearbat/models/modules.dart';

class WordPath extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Modules'),
      ),
      body: ModuleListWidget(modules: wordModules)
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hearbat/models/modules.dart';
class ModuleListWidget extends StatelessWidget {

  final List<Module> modules;

  ModuleListWidget({Key? key, required this.modules}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: modules.length,
      itemBuilder: (context, index) {
        final module = modules[index];
        return Card (
          child: ListTile(
            title: Text(module.title),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => module.page),
            ),
          ),
        );
      }
    );
  }
}
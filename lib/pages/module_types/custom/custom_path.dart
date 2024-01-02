import 'package:flutter/material.dart';
import 'package:hearbat/utils/custom_util.dart';
import 'package:hearbat/utils/user_module_util.dart';
import 'modules/custom_modules.dart';

class CustomPath extends StatefulWidget {
  @override
  CustomPathState createState() => CustomPathState();
}

class CustomPathState extends State<CustomPath> {
  List<String> moduleNames = [];

  @override
  void initState() {
    super.initState();
    _loadModules();
  }

  void _loadModules() async {
    var modules = await UserModuleUtil.getAllCustomModules();
    if (!mounted) return;
    setState(() {
      moduleNames = modules.keys.toList();
    });
  }

  void _addModuleAndPop(String moduleName) async {
    await UserModuleUtil.getAllCustomModules();
    if (!mounted) return;
    _loadModules();
    Navigator.of(context).pop();
  }

  void _navigateToCreateModule() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CustomUtil(onModuleSaved: _addModuleAndPop)),
    );
  }

  void _deleteModule(String moduleName) async {
    await UserModuleUtil.deleteCustomModule(moduleName);
    if (!mounted) return;
    _loadModules();
  }

  void _showModule(String moduleName) async {
    var modules = await UserModuleUtil.getAllCustomModules();
    if (!mounted) return;
    var answerGroups = modules[moduleName] ?? [];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomModule(
          moduleName: moduleName,
          answerGroups: answerGroups,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Custom Modules"),
      ),
      body: ListView.builder(
        itemCount: moduleNames.length + 1,
        itemBuilder: (context, index) {
          if (index < moduleNames.length) {
            String moduleName = moduleNames[index];
            return ListTile(
              title: Text(moduleName),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _deleteModule(moduleName),
              ),
              onTap: () => _showModule(moduleName),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _navigateToCreateModule,
                child: Text("Create Custom Module"),
              ),
            );
          }
        },
      ),
    );
  }
}

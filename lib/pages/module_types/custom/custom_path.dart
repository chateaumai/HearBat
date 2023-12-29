import 'package:flutter/material.dart';
import 'modules/custom_module_screen.dart';
import 'package:hearbat/widgets/user_module_manager.dart';
import 'modules/display_module_screen.dart';

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
    var modules = await UserModuleManager.getAllCustomModules();
    if (!mounted) return;
    setState(() {
      moduleNames = modules.keys.toList();
    });
  }

  void _addModuleAndPop(String moduleName) async {
    await UserModuleManager.getAllCustomModules();
    if (!mounted) return;
    _loadModules(); // Refresh the module list immediately after adding
    Navigator.of(context).pop();
  }

  void _navigateToCreateModule() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              CustomModuleScreen(onModuleSaved: _addModuleAndPop)),
    );
  }

  void _deleteModule(String moduleName) async {
    await UserModuleManager.deleteCustomModule(moduleName);
    if (!mounted) return;
    _loadModules(); // Refresh the module list
  }

  void _showModule(String moduleName) async {
    var modules = await UserModuleManager.getAllCustomModules();
    if (!mounted) return;
    var wordPairs = modules[moduleName] ?? [];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DisplayModuleScreen(
          moduleName: moduleName,
          wordPairs: wordPairs,
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
        itemCount: moduleNames.length + 1, // Module names + create button
        itemBuilder: (context, index) {
          if (index < moduleNames.length) {
            String moduleName = moduleNames[index];
            return ListTile(
              title: Text(moduleName),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _deleteModule(moduleName),
              ),
              onTap: () =>
                  _showModule(moduleName), // Navigate to show module details
            );
          } else {
            // The last item is the "Create Custom Module" button
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

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hearbat/utils/custom_util.dart';
import 'package:hearbat/utils/user_module_util.dart';
import '../../../utils/custom_modules_util.dart';

class CustomPath extends StatefulWidget {
  @override
  CustomPathState createState() => CustomPathState();
}

class CustomPathState extends State<CustomPath> {
  List<String> moduleNames = [];
  String? _voiceType;

  @override
  void initState() {
    super.initState();
    _loadModules();
    _loadVoiceType();
  }

  void _loadModules() async {
    var modules = await UserModuleUtil.getAllCustomModules();
    if (!mounted) return;
    setState(() {
      moduleNames = modules.keys.toList();
    });
  }

  void _loadVoiceType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _voiceType = prefs.getString('voicePreference') ??
          "en-US-Studio-O"; // Default voice type
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

    if (_voiceType != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CustomModule(
            moduleName: moduleName,
            answerGroups: answerGroups,
            voiceType: _voiceType!,
          ),
        ),
      );
    } else {
      print("Voice type is not loaded yet");
    }
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

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hearbat/data/answer_pair.dart';

class UserModuleUtil {
  static const String _storageKey = 'userCustomModules';

  // Save a new custom module
  static Future<void> saveCustomModule(
      String moduleName, List<AnswerGroup> answerGroups) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? currentModulesJson = prefs.getString(_storageKey);
    Map<String, dynamic> currentModules =
        currentModulesJson != null ? json.decode(currentModulesJson) : {};

    List<Map> savableAnswerGroups =
        answerGroups.map((ag) => ag.toJson()).toList();

    currentModules[moduleName] = savableAnswerGroups;

    await prefs.setString(_storageKey, json.encode(currentModules));
  }

  // Retrieve all custom modules
  static Future<Map<String, List<AnswerGroup>>> getAllCustomModules() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? modulesJson = prefs.getString(_storageKey);
    if (modulesJson == null) {
      return {}; // Return an empty map when data is null
    }

    try {
      Map<String, dynamic> modulesData = json.decode(modulesJson);

      Map<String, List<AnswerGroup>> modules = {};

      modulesData.forEach((key, value) {
        if (value is List<dynamic>) {
          List<AnswerGroup> answerGroups = value
              .map((agData) =>
                  AnswerGroup.fromJson(Map<String, dynamic>.from(agData)))
              .toList();
          modules[key] = answerGroups;
        } else {
          // Handle unexpected data format here
          print('Unexpected data format for module: $key');
        }
      });

      return modules;
    } catch (e) {
      // Handle JSON decoding error
      print('Error decoding JSON data: $e');
      return {};
    }
  }

  static Future<List<AnswerGroup>> getCustomModuleAnswerGroups(String moduleName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? modulesJson = prefs.getString(_storageKey);
    
    if (modulesJson == null) {
      return []; 
    }
    
    try {
      Map<String, dynamic> modulesData = json.decode(modulesJson);
      
      if (!modulesData.containsKey(moduleName)) {
        return [];
      }
      
      var moduleData = modulesData[moduleName];
      if (moduleData is List<dynamic>) {
        return moduleData
            .map((agData) => AnswerGroup.fromJson(Map<String, dynamic>.from(agData)))
            .toList();
      } else {
        print('Unexpected data format for module: $moduleName');
        return [];
      }
    } catch (e) {
      print('Error retrieving module data: $e');
      return [];
    }
  }

  // Delete a custom module
  static Future<void> deleteCustomModule(String moduleName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? modulesJson = prefs.getString(_storageKey);
    if (modulesJson != null) {
      Map<String, dynamic> modules = json.decode(modulesJson);
      modules.remove(moduleName); // Remove the module
      await prefs.setString(
          _storageKey, json.encode(modules)); // Save the updated modules
    }
  }
}

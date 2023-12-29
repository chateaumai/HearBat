import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hearbat/models/word_pair.dart';

class UserModuleManager {
  static const String _storageKey = 'userCustomModules';

  // Save a new custom module
  static Future<void> saveCustomModule(
      String moduleName, List<WordPair> wordPairs) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? currentModulesJson = prefs.getString(_storageKey);
    Map<String, dynamic> currentModules =
        currentModulesJson != null ? json.decode(currentModulesJson) : {};

    List<Map> savableWordPairs = wordPairs.map((wp) => wp.toJson()).toList();

    currentModules[moduleName] = savableWordPairs;

    await prefs.setString(_storageKey, json.encode(currentModules));
  }

  // Retrieve all custom modules
  static Future<Map<String, List<WordPair>>> getAllCustomModules() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? modulesJson = prefs.getString(_storageKey);
    if (modulesJson == null) return {};

    Map<String, dynamic> modulesData = json.decode(modulesJson);
    Map<String, List<WordPair>> modules = {};

    modulesData.forEach((key, value) {
      List<dynamic> wordPairsData = value;
      List<WordPair> wordPairs = wordPairsData
          .map((wpData) => WordPair.fromJson(Map<String, dynamic>.from(wpData)))
          .toList();
      modules[key] = wordPairs;
    });

    return modules;
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

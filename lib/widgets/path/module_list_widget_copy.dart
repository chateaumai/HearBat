import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hearbat/data/answer_pair.dart';
import '../module/module_widget.dart';
import 'package:hearbat/utils/cache_words_util.dart';
import 'trangular_path_layout_widget.dart';
import 'animated_button_widget.dart';

class ModuleListWidget extends StatefulWidget {
  final Map<String, List<AnswerGroup>> modules;
  final String chapter;

  ModuleListWidget({Key? key, required this.modules, required this.chapter}) : super(key: key);

  @override
  ModuleListWidgetState createState() => ModuleListWidgetState();
}

class ModuleListWidgetState extends State<ModuleListWidget> with TickerProviderStateMixin {
  String? _voiceType;
  final CacheWordsUtil cacheUtil = CacheWordsUtil();

  @override
  void initState() {
    super.initState();
    _loadVoiceType();

  }

  void _loadVoiceType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _voiceType = prefs.getString('voicePreference') ??
          "en-US-Studio-O"; // Default voice type
    });
  }

  Future<void> _cacheAndNavigate(
      String moduleName, List<AnswerGroup> answerGroups) async {
    if (_voiceType == null) {
      print("Voice type not set. Unable to cache module words.");
      return;
    }

    // Show loading indicator while caching
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 10),
              Text("Loading..."),
            ],
          ),
        );
      },
    );

    // Caching all words
    await cacheUtil.cacheModuleWords(answerGroups, _voiceType!);

    // Check if the widget is still in the tree (mounted) after the async operation
    if (!mounted) return; // Early return if not mounted

    Navigator.pop(context); // Close the loading dialog if still mounted
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModuleWidget(
          title: moduleName,
          answerGroups: answerGroups,
          isWord: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var moduleList = widget.modules.entries.toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: TriangularPathLayout(
          itemCount: moduleList.length,
          itemBuilder: (context, index) {
            final module = moduleList[index];
            return Stack(
              children: <Widget> [
                Container(
                  margin: EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 34, 38, 110),
                  ),
                  width: 100.0,
                  height: 100.0,
                ),
                AnimatedButton(
                  moduleName: module.key,
                  answerGroups: module.value,
                  onButtonPressed: (String moduleName, List<AnswerGroup> answerGroups) {
                    _cacheAndNavigate(moduleName, answerGroups);
                  },
                ),
              ],
            );
          },
          itemSize: 120.0,
          spacing: 80.0,
          chapter: widget.chapter,
        ),
      ),
    );
  }
}
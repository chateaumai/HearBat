// this is for the module cards when you click on view words in the path
// holding the respective words that are in the modules
import 'package:flutter/material.dart';
import 'package:hearbat/data/answer_pair.dart';
import '../../pages/module_types/words/module_words_page.dart';
import 'package:hearbat/utils/cache_words_util.dart';

class ModuleCard extends StatefulWidget {
  final String moduleName;
  final List<AnswerGroup> answerGroups;
  final String voiceType;

  const ModuleCard({
    Key? key,
    required this.moduleName,
    required this.answerGroups,
    required this.voiceType,
  }) : super(key: key);

  @override
  State<ModuleCard> createState() => _ModuleCardState();
}

class _ModuleCardState extends State<ModuleCard> {
  final CacheWordsUtil cacheUtil = CacheWordsUtil();
  double elevation = 5.0; 

  Future<void> _cacheAndNavigate() async {
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

    await cacheUtil.cacheModuleWords(widget.answerGroups, widget.voiceType);

    if (!mounted) return; 

    Navigator.pop(context); // Close the loading dialog
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModuleWordsPage(
          moduleName: widget.moduleName,
          answerGroups: widget.answerGroups,
          voiceType: widget.voiceType,
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cardWidth = screenSize.width * 0.5;
    final cardHeight = screenSize.height * 0.18;

    return GestureDetector(
      onTapDown: (_) => setState(() => elevation = 2.0), 
      onTapUp: (_) {
        setState(() => elevation = 5.0); 
        _cacheAndNavigate();
      },
      onTapCancel: () => setState(() => elevation = 5.0), 
      child: Container(
        width: cardWidth,
        height: cardHeight,
        margin: EdgeInsets.all(8),
        child: Card(
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10), 
            child: Stack(
              children: [
                // Blue top bar
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: cardHeight * 0.35, 
                    color: Color.fromARGB(255, 7, 45, 78), 
                  ),
                ),
                // Text positioned over the blue bar
                Positioned(
                  top: 16, 
                  left: 16,
                  right: 16,
                  child: Text(
                    widget.moduleName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, 
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Positioned.fill(
                  top: 50.0,
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 7, 45, 78), // Same blue color
                        borderRadius: BorderRadius.circular(40), // Rounded corners for the button
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                      child: Text(
                        "HEAR WORDS",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

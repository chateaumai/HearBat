import 'package:flutter/material.dart';
import '../module/speech_module_widget.dart';
import 'sound_trangular_path_layout_widget.dart';
import 'animated_button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hearbat/utils/cache_sentences_util.dart';

class SpeechModuleListWidget extends StatelessWidget {
  final Map<String, List<String>> modules;

  SpeechModuleListWidget({Key? key, required this.modules}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var moduleList = modules.entries.toList();
    String voiceType = '';

    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      voiceType = prefs.getString('voiceType') ?? 'en-US-Wavenet-D';
    });

    void navigate(String moduleName, List<String> sentences) {
      // Show a loading dialog while caching
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

      // Use CacheSentencesUtil to cache all the sentences
      CacheSentencesUtil().cacheSentences(sentences, voiceType).then((_) {
        // Dismiss the loading dialog
        Navigator.pop(context);

        // Navigate to the SpeechModuleWidget
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpeechModuleWidget(
              chapter: moduleName,
              sentences: sentences,
              voiceType: voiceType,
            ),
          ),
        );
      }).catchError((error) {
        // Dismiss the loading dialog
        Navigator.pop(context);

        // Handle any errors that occurred during the downloads
        print('Failed to download all sentences: $error');
      });
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SoundTriangularPathLayout(
          itemCount: moduleList.length,
          itemBuilder: (context, index) {
            final module = moduleList[index];
            return Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50 * 1.2,
                    width: 100 * 1.5,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 7, 45, 78),
                      borderRadius: BorderRadius.all(
                          Radius.elliptical(100 * 1.5, 50 * 1.5)),
                    ),
                  ),
                ),
                AnimatedButton(
                  moduleName: module.key,
                  answerGroups: module.value,
                  onButtonPressed: (String key, List<dynamic> value) {
                    navigate(module.key, module.value);
                  },
                ),
              ],
            );
          },
          itemSize: 120.0,
          spacing: 80.0,
        ),
      ),
    );
  }
}

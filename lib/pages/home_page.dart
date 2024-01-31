import 'package:flutter/material.dart';
import 'module_types/words/word_chapters.dart';
import 'module_types/sound/sound_chapters.dart';
import 'module_types/custom/custom_path.dart';
import '../widgets/home_card_widget.dart';
import '../utils/text_util.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                  width: 200, height: 200, 'assets/visuals/HB_Default.png'),
              HomeCardWidget(
                  cardText: 'Train Words',
                  description: wordDesc,
                  destinationPage: WordChapters()),
              HomeCardWidget(
                  cardText: 'Train Sounds',
                  description: soundDesc,
                  destinationPage: SoundChapters()),
              HomeCardWidget(
                  cardText: 'Custom Module Builder',
                  description: customDesc,
                  destinationPage: CustomPath()),
            ],
          ),
        ),
      ),
    );
  }
}

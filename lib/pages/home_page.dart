import 'package:flutter/material.dart';
import 'module_types/words/word_chapters.dart';
import 'module_types/sound/sound_chapters.dart';
import 'module_types/custom/custom_path.dart';
import '../widgets/home_card_widget.dart';
import '../utils/text_util.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            HomeCardWidget(cardText: 'Train Words', description: lorem, destinationPage: WordChapters()),
            HomeCardWidget(cardText: 'Train Sounds', description: lorem, destinationPage: SoundChapters()),
            HomeCardWidget(cardText: 'Custom Module Builder', description: lorem, destinationPage: CustomPath()),
          ],
        ),
      ),
    );
  }
}

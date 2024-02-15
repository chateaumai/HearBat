import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'navigation_bar.dart';

class SoundAdjustmentPage extends StatefulWidget {
  @override
  SoundAdjustmentPageState createState() => SoundAdjustmentPageState();
}

class SoundAdjustmentPageState extends State<SoundAdjustmentPage> {
  final AudioPlayer audioPlayer = AudioPlayer();
  final String audioPath = 'audio/background/jazz.mp3';

  @override
  void initState() {
    super.initState();
    playSound();
  }

  @override
  void dispose() {
    audioPlayer.stop();
    audioPlayer.dispose();
    super.dispose();
  }

  void playSound() async {
    await audioPlayer.play(AssetSource(audioPath));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adjust Sound'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Please adjust your sound settings.'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => MyNavBar()));
              },
              child: Text('Proceed to App'),
            ),
          ],
        ),
      ),
    );
  }
}

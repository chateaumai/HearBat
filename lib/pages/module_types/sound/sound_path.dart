import 'package:flutter/material.dart';

class SoundPath extends StatelessWidget {
  final String chapter; // Accepts a chapter identifier

  SoundPath({Key? key, required this.chapter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sound Modules - $chapter'),
      ),
      body: Center(
        child: Text("Content for Sound Modules - $chapter"),
      ),
    );
  }
}

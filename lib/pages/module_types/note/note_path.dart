import 'package:flutter/material.dart';

class NotePath extends StatelessWidget {
  const NotePath({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note Path'),
      ),
      body: Center(
        child: Text('Note Path'),
      ),
    );
  }
}
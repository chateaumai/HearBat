import 'package:flutter/material.dart';
import 'package:hearbat/pages/module_types/matching/memory_match_page.dart';
import 'package:hearbat/widgets/game_button.dart';

class MemoryMatchPath extends StatelessWidget {
  const MemoryMatchPath({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Mode'),
      ),
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  'MEMORY MATCH',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              GameButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (BuildContext context) {
                    return const MemoryMatchPage();
                  }));
                },
                title: 'START',
              ),
            ]),
      ),
    );
  }
}

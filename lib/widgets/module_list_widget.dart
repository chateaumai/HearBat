import 'package:flutter/material.dart';
import 'package:hearbat/models/modules.dart';
class ModuleListWidget extends StatelessWidget {

  final List<Module> modules;

  ModuleListWidget({Key? key, required this.modules}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: modules.length,
      itemBuilder: (context, index) {
        final module = modules[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => module.page),
          ),
          child: Container(
            width: 150, // Circle diameter
            height: 150, // Circle diameter
            margin: EdgeInsets.symmetric(vertical: 20), // Space between circles
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue, // Change as needed
            ),
            child: Center(
              child: Text(
                module.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ), // Text color
              ),
            ),
          ),
        );
      }
    );
  }
}
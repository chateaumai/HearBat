import 'package:flutter/material.dart';

class CustomModuleCard extends StatelessWidget {
  final String moduleName;
  final VoidCallback onStart;
  final VoidCallback onDelete;

  const CustomModuleCard({
    super.key,
    required this.moduleName,
    required this.onStart,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 7, 45, 78),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 15),
              Text(
                moduleName,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 22),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: onStart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 154, 107, 187),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Start', style: TextStyle(fontSize: 16)),
                    ),
                    SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: onDelete,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 214, 214, 214),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Icon(Icons.delete,
                          color: Color.fromARGB(255, 100, 100, 100), size: 24),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

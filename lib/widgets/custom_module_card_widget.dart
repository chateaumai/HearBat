import 'package:flutter/material.dart';

class CustomModuleCard extends StatelessWidget {
  final String moduleName;
  final VoidCallback onStart; 
  final VoidCallback onDelete; 

  const CustomModuleCard({
    Key? key,
    required this.moduleName,
    required this.onStart,
    required this.onDelete,
  }) : super(key: key);

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
              SizedBox(height: 40), 
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: onStart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 0, 136, 255),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), 
                        ),
                      ),
                      child: Text('Start', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 5),
                    IconButton(
                      onPressed: onDelete,
                      icon: Icon(Icons.delete, color: Color.fromARGB(255, 95, 95, 95)),
                      iconSize: 35,
                    ),
                    /*ElevatedButton(
                      onPressed: onDelete,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 255, 0, 0),
                        foregroundColor: Color.fromARGB(255, 0, 0, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), 
                        ),
                      ),
                      child: Text('Delete'),
                    ), */
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
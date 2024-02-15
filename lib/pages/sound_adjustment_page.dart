import 'package:flutter/material.dart';
import 'navigation_bar.dart';

class SoundAdjustmentPage extends StatelessWidget {
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

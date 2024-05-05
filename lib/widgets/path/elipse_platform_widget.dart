import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      home: Scaffold(body: Center(child: FloatingPlatformButton()))));
}

class FloatingPlatformButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: EllipsePainter(),
      child: Container(
        width: 200,
        height: 100,
        alignment: Alignment.center,
        child: ElevatedButton(
          onPressed: () {
            // Button tap logic
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent, // Use a transparent background
            shadowColor: Colors.transparent, // No shadow for the button itself
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(50), // Rounded edges for the button
            ),
            padding: EdgeInsets.symmetric(horizontal: 48, vertical: 20),
          ),
          child: Icon(Icons.menu_book, color: Colors.white, size: 60),
        ),
      ),
    );
  }
}

class EllipsePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();

    // Create an oval based on the container size
    Rect oval = Rect.fromLTWH(0, 0, size.width, size.height);
    path.addOval(oval);

    // Draw the shadow first
    canvas.drawShadow(path, Colors.grey.withAlpha(150), 10, false);

    // Apply a gradient to simulate the 3D effect
    paint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white,
        Colors.purple.shade300,
      ],
      stops: [0.1, 1.0],
    ).createShader(oval);

    // Draw the gradient oval
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

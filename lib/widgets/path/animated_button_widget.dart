import 'package:flutter/material.dart';
import 'package:hearbat/data/answer_pair.dart';

class AnimatedButton extends StatefulWidget {
  final String moduleName;
  final List<AnswerGroup> answerGroups;
  final Function(String moduleName, List<AnswerGroup> answerGroups) onButtonPressed;

  AnimatedButton({
    Key? key,
    required this.moduleName,
    required this.answerGroups,
    required this.onButtonPressed,
  }) : super(key: key);

  @override
  AnimatedButtonState createState() => AnimatedButtonState();
}

class AnimatedButtonState extends State<AnimatedButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<EdgeInsets> _buttonMarginAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 20),
      vsync: this,
    );

    _buttonMarginAnimation = Tween<EdgeInsets>(
      begin: EdgeInsets.only(top: 0),
      end: EdgeInsets.only(top: 8),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.reverse().then((_) {
      widget.onButtonPressed(widget.moduleName, widget.answerGroups);
    });
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _buttonMarginAnimation,
      builder: (context, child) {
        return Container(
          margin: _buttonMarginAnimation.value,
          child: ElevatedButton(
            onPressed: () {}, // The actual functionality is handled by GestureDetector
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(20),
              //backgroundColor: const Color.fromARGB(255, 81, 87, 240),
              backgroundColor: const Color.fromARGB(255, 154, 107, 187),
              elevation: 0,
            ),
            child: GestureDetector(
              onTapDown: _handleTapDown,
              onTapUp: _handleTapUp,
              onTapCancel: _handleTapCancel, 
              child: Icon(Icons.menu_book, color: Colors.white, size: 60),
            ),
          ),
        );
      },
    );
  }
}

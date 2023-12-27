import 'package:flutter/material.dart';

class CheckButtonWidget extends StatelessWidget {
  final bool isCheckingAnswer;
  final bool isSelectedWordValid;
  final VoidCallback onPressed;

  CheckButtonWidget({
    Key? key,
    required this.isCheckingAnswer,
    required this.isSelectedWordValid,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isSelectedWordValid ? onPressed : null, 
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelectedWordValid
        ? Colors.lightGreen
        : Colors.grey,
        disabledBackgroundColor: Colors.grey,
      ),
      child: Text(
        isCheckingAnswer ? 'Check' : 'Next',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
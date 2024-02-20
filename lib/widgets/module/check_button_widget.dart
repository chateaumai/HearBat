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
        backgroundColor: !isCheckingAnswer
        ? Color.fromARGB(255, 7, 45, 78)
        : isSelectedWordValid
          ? Color.fromARGB(255, 94, 224, 82)
          : Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        disabledBackgroundColor: Colors.grey,
        minimumSize: Size(350, 50),
        elevation: 5,
      ),
      child: Text(
        isCheckingAnswer ? 'CHECK' : 'CONTINUE',
        style: TextStyle(
          color: const Color.fromARGB(255, 255, 255, 255),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
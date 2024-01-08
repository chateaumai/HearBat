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
        ? const Color.fromARGB(255, 136, 255, 0)
        : Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        disabledBackgroundColor: Colors.grey,
        minimumSize: Size(350, 50),
        elevation: 5,
      ),
      child: Text(
        isCheckingAnswer ? 'CHECK' : 'NEXT',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
    );
  }
}
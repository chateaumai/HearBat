import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class AnswerButton extends StatelessWidget {
  final String answer;
  final VoidCallback onPressed;
  final String headerText;
  final Color color;

  const AnswerButton({
    Key? key,
    required this.answer,
    required this.onPressed,
    required this.headerText,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Button(
          onPressed: onPressed,
          answer: answer,
          color: color,
          header: headerText),
    );
  }
}

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.onPressed,
    required this.answer,
    required this.color,
    required this.header,
  });

  final VoidCallback onPressed;
  final String answer;
  final Color color;
  final String header;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              header,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              elevation: 3,
              shadowColor: Colors.grey[900],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.volume_up,
                    color: Color.fromARGB(255, 7, 45, 78), size: 24),
                SizedBox(width: 10),
                Expanded(
                  child: AutoSizeText(
                    answer,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

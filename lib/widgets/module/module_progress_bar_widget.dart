import 'package:flutter/material.dart';

class ModuleProgressBarWidget extends StatefulWidget {
  final int currentIndex;
  final int total;

  const ModuleProgressBarWidget({
    Key? key,
    required this.currentIndex,
    required this.total,
  }) : super(key: key);

  @override
  State<ModuleProgressBarWidget> createState() => _ModuleProgressBarWidgetState();
}

class _ModuleProgressBarWidgetState extends State<ModuleProgressBarWidget> {
   
  @override
  Widget build(BuildContext context) {
    double progress = (widget.currentIndex / widget.total);
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      tween: Tween<double>(
        begin: 0,
        end: progress,
      ),
      builder: (context, value, _) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: MediaQuery.of(context).size.width * 0.85,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Color.fromARGB(255, 41, 41, 41),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            //            borderRadius: BorderRadius.circular(20),
              minHeight: 26,
            ),
          ),
        );
      }
    );
  }
}
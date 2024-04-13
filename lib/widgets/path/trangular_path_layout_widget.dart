import 'package:flutter/material.dart';
import '../../pages/module_types/words/words_list_page.dart';
import '../../../utils/module_util.dart';
import 'package:hearbat/data/answer_pair.dart';

class TriangularPathLayout extends StatefulWidget {
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final double itemSize;
  final double spacing;
  final String chapter;

  const TriangularPathLayout({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
    required this.itemSize,
    required this.spacing,
    required this.chapter,
  }) : super(key: key);

  @override
  State<TriangularPathLayout> createState() => _TriangularPathLayoutState();
}

class _TriangularPathLayoutState extends State<TriangularPathLayout> {
  double elevation = 5.0;

  void _navigateToWordsList(BuildContext context,
      Map<String, List<AnswerGroup>> modules, String chapterName) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              WordsList(modules: modules, chapterName: chapterName)),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<AnswerGroup>> modules =
        getModulesForChapter(widget.chapter);
    List<Widget> positionedItems = [];

    // Calculate the total width of the layout
    double layoutWidth = MediaQuery.of(context).size.width;
    // Calculate the initial horizontal offset to center the triangles
    double initialXOffset = (layoutWidth - 300) / 2;

    double xOffset = initialXOffset;
    double yOffset = widget.spacing - 15;

    // Create triangles
    for (int i = 0; i < widget.itemCount; i += 3) {
      // Calculate the position for the top circle of the triangle
      positionedItems.add(_buildPositionedItem(context, widget.itemBuilder,
          xOffset + (widget.itemSize + widget.spacing) / 2, yOffset, i));

      // Calculate the positions for the bottom two circles of the triangle
      if (i + 1 < widget.itemCount) {
        positionedItems.add(_buildPositionedItem(context, widget.itemBuilder,
            xOffset, yOffset + widget.itemSize + (widget.spacing / 2), i + 1));
      }
      if (i + 2 < widget.itemCount) {
        positionedItems.add(_buildPositionedItem(
            context,
            widget.itemBuilder,
            xOffset + widget.itemSize + widget.spacing,
            yOffset + widget.itemSize + (widget.spacing / 2),
            i + 2));
      }

      xOffset = initialXOffset;
      yOffset += 330;
    }
    double totalHeight = yOffset;

    return SingleChildScrollView(
      child: Column(
        children: [
          GestureDetector(
            onTapDown: (_) => setState(() => elevation = 1.0),
            onTapUp: (_) => setState(() {
              elevation = 5.0;
              _navigateToWordsList(
                  context, modules, widget.chapter.toUpperCase());
            }),
            onTapCancel: () => setState(() => elevation = 5.0),
            child: Container(
              margin: EdgeInsets.all(20),
              child: Material(
                color: Colors.white,
                elevation: elevation,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    'View Chapter Words',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
              height: totalHeight, child: Stack(children: positionedItems)),
        ],
      ),
    );
  }

  Positioned _buildPositionedItem(BuildContext context,
      IndexedWidgetBuilder itemBuilder, double left, double top, int index) {
    return Positioned(
      left: left,
      top: top,
      child: SizedBox(
        width: widget.itemSize,
        height: widget.itemSize,
        child: itemBuilder(context, index),
      ),
    );
  }
}

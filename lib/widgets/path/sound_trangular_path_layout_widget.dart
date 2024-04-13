import 'package:flutter/material.dart';

class SoundTriangularPathLayout extends StatefulWidget {
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final double itemSize;
  final double spacing;

  const SoundTriangularPathLayout({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
    required this.itemSize,
    required this.spacing,
  }) : super(key: key);

  @override
  State<SoundTriangularPathLayout> createState() =>
      _SoundTriangularPathLayoutState();
}

class _SoundTriangularPathLayoutState extends State<SoundTriangularPathLayout> {
  @override
  Widget build(BuildContext context) {
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
      child: SizedBox(
          height: totalHeight, child: Stack(children: positionedItems)),
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

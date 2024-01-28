import 'package:flutter/material.dart';

class TriangularPathLayout extends StatelessWidget {
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final double itemSize;
  final double spacing;

  const TriangularPathLayout({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
    required this.itemSize,
    required this.spacing,
  }) : super(key: key);

@override
  Widget build(BuildContext context) {
    List<Widget> positionedItems = [];

    // Calculate the total width of the layout
    double layoutWidth = MediaQuery.of(context).size.width;
    // Calculate the initial horizontal offset to center the triangles
    double initialXOffset = (layoutWidth - 300) / 2;
    
    double xOffset = initialXOffset;
    double yOffset = spacing;

    // Create triangles
    for (int i = 0; i < itemCount; i += 3) {
      // Calculate the position for the top circle of the triangle
      positionedItems.add(
        _buildPositionedItem(context, itemBuilder, xOffset + (itemSize + spacing) / 2, yOffset, i)
      );

      // Calculate the positions for the bottom two circles of the triangle
      if (i + 1 < itemCount) {
        positionedItems.add(
          _buildPositionedItem(context, itemBuilder, xOffset, yOffset + itemSize + (spacing / 2), i + 1)
        );
      }
      if (i + 2 < itemCount) {
        positionedItems.add(
          _buildPositionedItem(context, itemBuilder, xOffset + itemSize + spacing, yOffset + itemSize + (spacing / 2), i + 2)
        );
      }

      xOffset = initialXOffset;
      yOffset += 330;
    }

    return Stack(children: positionedItems);
  }

  Positioned _buildPositionedItem(BuildContext context, IndexedWidgetBuilder itemBuilder, double left, double top, int index) {
    return Positioned(
      left: left,
      top: top,
      child: SizedBox(
        width: itemSize,
        height: itemSize,
        child: itemBuilder(context, index),
      ),
    );
  }
}
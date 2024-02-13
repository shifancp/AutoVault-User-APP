import 'package:flutter/material.dart';

class CustomTextWidget extends StatelessWidget {
  // Constructor for CustomTextWidget
  const CustomTextWidget({
    Key? key,
    required this.text,
    required this.color,
    required this.textSize,
    this.isTitle = false,
    this.maxLines = 1,
    this.fulldesc = false,
  }) : super(key: key);

  // Properties
  final String text;
  final Color color;
  final double textSize;
  final bool isTitle;
  final int maxLines;
  final bool fulldesc;

  @override
  Widget build(BuildContext context) {
    // Return a Text widget with specified properties
    return Text(
      text,
      // Handle overflow based on the 'fulldesc' property
      overflow: fulldesc ? TextOverflow.fade : TextOverflow.ellipsis,
      style: TextStyle(
        color: color,
        fontSize: textSize,
        // Set font weight to bold if it's a title, otherwise normal
        fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}

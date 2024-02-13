import 'package:flutter/material.dart';

class IconAndText extends StatelessWidget {
  // Constructor for IconAndText widget
  const IconAndText({
    Key? key,
    required this.text,
    required this.iconData,
    required this.onTap,
  }) : super(key: key);

  // Properties
  final String text;
  final IconData iconData;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    // Return a ListTile widget with specified properties
    return ListTile(
      onTap: onTap, // Execute onTap function when ListTile is tapped
      leading: Icon(
        iconData, // Display the specified icon
      ),
      title: Text(
        text,
        style: const TextStyle(color: Colors.black), // Set text color to black
      ),
      trailing:
          const Icon(Icons.navigate_next_outlined), // Display navigation icon
    );
  }
}

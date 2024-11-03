import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final double iconSize;
  final Color buttonColor;
  final Color iconColor;
  final double padding;

  const CustomIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.iconSize = 32, // Default icon size
    this.buttonColor = Colors.blue, // Default button background color
    this.iconColor = Colors.white, // Default icon color
    this.padding = 12.0, // Default padding
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        padding: EdgeInsets.all(padding),
        shape: const CircleBorder(), // Make the button circular
      ),
      child: Icon(
        icon,
        size: iconSize,
        color: iconColor,
      ),
    );
  }
}

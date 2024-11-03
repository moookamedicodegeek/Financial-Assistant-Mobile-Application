import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final double fontSize;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = Colors.blue, // Default color
    this.textColor = Colors.white, // Default text color
    this.fontSize = 18.0, // Default font size
    this.borderRadius = 8.0, // Default border radius
  });

  @override

  /// Builds a custom elevated button with the provided properties.
  ///
  /// The button built by this method has a rounded rectangle shape with a
  /// border radius equal to [borderRadius], and a background color of
  /// [color]. The text of the button is [text], with a font size of [fontSize]
  /// and a color of [textColor].
  ///
  /// When the button is pressed, the [onPressed] callback is called.
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(
          15,
        ),
        backgroundColor: color,
        foregroundColor: textColor,
        textStyle: TextStyle(fontSize: fontSize),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Text(text),
    );
  }
}

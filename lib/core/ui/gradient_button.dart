import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Gradient gradient;
  final TextStyle? textStyle;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double minHeight;

  const GradientButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.gradient,
    this.textStyle,
    this.borderRadius = 100.0,
    this.padding = const EdgeInsets.fromLTRB(80, 0, 80, 0),
    this.minHeight = 44.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
        child: Container(
          padding: padding,
          constraints: BoxConstraints(minHeight: minHeight),
          alignment: Alignment.center,
          child: Text(
            text,
            style: textStyle?.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

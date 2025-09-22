import 'package:flutter/material.dart';

class StatProgressBar extends StatelessWidget {
  final double value;
  final Color color;
  final Color? backgroundColor;
  final double height;
  final BorderRadius? borderRadius;

  const StatProgressBar({
    super.key,
    required this.value,
    required this.color,
    this.backgroundColor,
    this.height = 8.0,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? color.withValues(alpha: 0.2),
        borderRadius: borderRadius ?? BorderRadius.circular(height / 2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: value.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: borderRadius ?? BorderRadius.circular(height / 2),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void navigationWithoutAnimation(BuildContext context, Widget screen) {
  HapticFeedback.lightImpact();
  Navigator.of(context).pushReplacement(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ),
  );
}

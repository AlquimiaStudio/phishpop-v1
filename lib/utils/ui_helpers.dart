import 'package:flutter/material.dart';

BoxDecoration getAppBackground(BuildContext context) => BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Theme.of(context).primaryColor,
      Theme.of(context).primaryColor.withValues(alpha: 0.8),
      Theme.of(context).scaffoldBackgroundColor,
    ],
    stops: const [0.0, 0.15, 0.3],
  ),
);

BoxDecoration getBordersScreen(BuildContext context) => BoxDecoration(
  color: Theme.of(context).scaffoldBackgroundColor,
  borderRadius: const BorderRadius.only(
    topLeft: Radius.circular(30),
    topRight: Radius.circular(30),
  ),
);

BoxDecoration getTabBarShadow(BuildContext context) => BoxDecoration(
  color: Theme.of(context).cardColor,
  boxShadow: [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 20,
      offset: const Offset(0, -10),
    ),
  ],
);

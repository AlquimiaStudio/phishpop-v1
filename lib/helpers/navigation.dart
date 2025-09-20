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

bool isUrl(String text) {
  Uri? uri = Uri.tryParse(text);
  if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
    return true;
  }

  if (text.toLowerCase().startsWith('www.')) {
    uri = Uri.tryParse('https://$text');
    if (uri != null && uri.hasAuthority && uri.host.contains('.')) {
      return true;
    }
  }

  if (!text.contains(' ') && text.contains('.')) {
    final domainRegex = RegExp(
      r'^[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?)*\.[a-zA-Z]{2,}$',
    );
    if (domainRegex.hasMatch(text)) {
      return true;
    }
  }

  return false;
}

bool isWifi(String text) {
  return text.toUpperCase().startsWith('WIFI:');
}

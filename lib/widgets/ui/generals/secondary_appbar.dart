import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../helpers/helpers.dart';
import '../../../screens/screens.dart';

class SecondaryAppbar extends StatelessWidget implements PreferredSizeWidget {
  final IconData icon;
  final String title;
  final Widget? returnScreen;
  final bool useNavigatorPop;

  const SecondaryAppbar({
    super.key,
    required this.icon,
    required this.title,
    this.returnScreen,
    this.useNavigatorPop = false,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  if (useNavigatorPop && Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    navigationWithoutAnimation(
                      context,
                      returnScreen ?? HomeScreen(),
                    );
                  }
                },
                icon: Icon(Icons.arrow_back_ios_new),
                color: Colors.white,
              ).animate().scale(delay: 200.ms, duration: 400.ms).fadeIn(),
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.2, end: 0),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(icon, color: Colors.white, size: 22),
                  ).animate().scale(delay: 300.ms, duration: 400.ms).fadeIn(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(Platform.isIOS ? 80 : 95);
}

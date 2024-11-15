// lib/responsive/responsive_layout_screen.dart

import 'package:flutter/material.dart';
import 'package:petstagram/responsive/mobile_screen_layout.dart';
import 'package:petstagram/responsive/web_screen_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileScreenLayout;
  final Widget webScreenLayout;

  const ResponsiveLayout({
    Key? key,
    required this.mobileScreenLayout,
    required this.webScreenLayout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          // Web screen
          return webScreenLayout;
        }
        // Mobile screen
        return mobileScreenLayout;
      },
    );
  }
}

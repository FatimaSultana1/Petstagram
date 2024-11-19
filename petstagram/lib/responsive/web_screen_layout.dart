// lib/responsive/web_screen_layout.dart

import 'package:flutter/material.dart';
import 'package:petstagram/screens/feed_screen.dart';
import 'package:petstagram/screens/search_screen.dart';
import 'package:petstagram/screens/add_post_screen.dart';
import 'package:petstagram/screens/profile_screen.dart';

class WebScreenLayout extends StatelessWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Web Layout")),
      // Replace with actual web layout implementation
    );
  }
}

// lib/utils/global_variables.dart

import 'package:flutter/material.dart';
import 'package:petstagram/screens/add_post_screen.dart';
import 'package:petstagram/screens/feed_screen.dart';
import 'package:petstagram/screens/profile_screen.dart';
import 'package:petstagram/screens/search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Center(child: Text('Notifications')),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];

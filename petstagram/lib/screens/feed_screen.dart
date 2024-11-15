// lib/screens/feed_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petstagram/utils/colors.dart';
import 'package:petstagram/widgets/post_card.dart';
import 'package:petstagram/utils/global_variables.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    // Get screen width
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:
          width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text(
          'Petstagram',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Error handling
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Data loaded
          // return ListView(
          //   children: snapshot.data!.docs.map((DocumentSnapshot document) {
          //     Map<String, dynamic> data =
          //         document.data()! as Map<String, dynamic>;
          //     return PostCard(
          //       snap: data,
          //     );
          //   }).toList(),
          // );
          return ListView(
            children: snapshot.data!.docs.map<Widget>((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return PostCard(snap: data);
            }).toList(),
          );

        },
      ),
    );
  }
}

// lib/widgets/post_grid.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostGrid extends StatelessWidget {
  final String uid;

  const PostGrid({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: uid)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return GridView.builder(
          itemCount: snapshot.data!.docs.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (context, index) {
            var post = snapshot.data!.docs[index];
            return Image.network(
              post['postUrl'],
              fit: BoxFit.cover,
            );
          },
        );
      },
    );
  }
}

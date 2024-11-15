// lib/resources/firestore_methods.dart

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petstagram/models/post.dart';
import 'package:petstagram/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Existing methods...

  // Post Comment
  Future<void> postComment(
    String postId,
    String text,
    String uid,
    String name,
    String profilePic,
  ) async {
    try {
      if (text.isNotEmpty) {
        String commentId = Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'datePublished': Timestamp.now(),
        });

        // Optionally, update comments count
        await _firestore.collection('posts').doc(postId).update({
          'commentsCount': FieldValue.increment(1),
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }

  // Delete Post (Existing method)
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
      // Optionally, delete associated comments
      var comments = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .get();

      for (var doc in comments.docs) {
        await doc.reference.delete();
      }
    } catch (err) {
      print(err.toString());
    }
  }
}

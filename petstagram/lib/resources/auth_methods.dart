// lib/resources/auth_methods.dart

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petstagram/models/user.dart' as model;
import 'package:petstagram/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get User Details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  // Sign Up User
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file, // Profile image
  }) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty &&
          file != null) {
        // Register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        // Upload profile image to Firebase Storage
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        // Create user model
        model.User user = model.User(
          email: email,
          uid: cred.user!.uid,
          username: username,
          bio: bio,
          photoUrl: photoUrl,
          followers: [],
          following: [],
        );

        // Save user data to Firestore
        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());

        res = "success";
      } else {
        res = "Please fill all fields";
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  // Login User
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // Login user
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
      } else {
        res = "Please enter email and password";
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

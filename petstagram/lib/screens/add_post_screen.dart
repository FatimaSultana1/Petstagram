// lib/screens/add_post_screen.dart

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petstagram/models/user.dart';
import 'package:petstagram/providers/user_provider.dart';
import 'package:petstagram/resources/firestore_methods.dart';
import 'package:petstagram/utils/colors.dart';
import 'package:petstagram/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();

  bool isLoading = false;

  // Select Image
  _selectImage(BuildContext context) async {
    Uint8List file = await pickImage(ImageSource.gallery);
    setState(() {
      _file = file;
    });
  }

  // Post Image
  void postImage(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    // Upload image and save post data
    try {
      String res = await FirestoreMethods().uploadPost(
          _descriptionController.text, _file!, uid, username, profImage);
      setState(() {
        isLoading = false;
      });
      if (res == "success") {
        showSnackBar(context, 'Posted!');
        clearImage();
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, err.toString());
    }
  }

  // Clear Image
  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return _file == null
        ? Center(
            child: IconButton(
              icon: Icon(Icons.upload),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: Text('Post to'),
              actions: [
                TextButton(
                  onPressed: () => postImage(
                    user.uid,
                    user.username,
                    user.photoUrl,
                  ),
                  child: Text(
                    'Post',
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                )
              ],
            ),
            body: Column(
              children: [
                isLoading ? LinearProgressIndicator() : Container(),
                Divider(),
                // Build UI similar to AddPostScreen in Wondershare
              ],
            ),
          );
  }
}

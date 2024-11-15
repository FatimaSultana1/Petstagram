// lib/widgets/post_card.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petstagram/models/user.dart';
import 'package:petstagram/providers/user_provider.dart';
import 'package:petstagram/resources/firestore_methods.dart';
import 'package:petstagram/screens/comments_screen.dart';
import 'package:petstagram/utils/colors.dart';
import 'package:petstagram/utils/global_variables.dart';
// import 'package:petstagram/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final Map<String, dynamic> snap;

  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLen = 0;
  bool isLikeAnimating = false;

  @override
  void initState() {
    super.initState();
    fetchCommentLen();
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (err) {
      print(err.toString());
    }
    setState(() {});
  }

  deletePost(String postId) async {
    try {
      await FirestoreMethods().deletePost(postId);
    } catch (err) {
      print(err.toString());
    }
  }

  @override
  // Widget build(BuildContext context) {
  //   final User user = Provider.of<UserProvider>(context).getUser;
  //   final width = MediaQuery.of(context).size.width;

  //   return Container(
  //     // ... Implement the UI similar to the original PostCard in Wondersahre
  //     // Please refer to the code you have from the Wondershare project and adapt it for Petstagram
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;

    return Container(
      // Add padding and decoration as needed
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          // Header with user info
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.snap['profImage']),
              radius: 18,
            ),
            title: Text(widget.snap['username']),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                // Show options like delete post if the user is the author
              },
            ),
          ),
          // Post image
          GestureDetector(
            onDoubleTap: () {
              // Implement like animation
            },
            child: Image.network(
              widget.snap['postUrl'],
              fit: BoxFit.cover,
              width: double.infinity,
              height: 300,
            ),
          ),
          // Like, comment, share icons
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.favorite_border,
                ),
                onPressed: () {
                  // Implement like functionality
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.comment_outlined,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          CommentsScreen(postId: widget.snap['postId']),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.share,
                ),
                onPressed: () {
                  // Implement share functionality
                },
              ),
            ],
          ),
          // Description and comments count
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.snap['likes'].length} likes',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: widget.snap['username'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: ' ${widget.snap['description']}',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            CommentsScreen(postId: widget.snap['postId']),
                      ),
                    );
                  },
                  child: Text(
                    'View all $commentLen comments',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.snap['datePublished'].toDate()}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

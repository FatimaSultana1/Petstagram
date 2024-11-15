// lib/screens/comments_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petstagram/models/user.dart';
import 'package:petstagram/providers/user_provider.dart';
import 'package:petstagram/resources/firestore_methods.dart';
import 'package:petstagram/utils/colors.dart';
import 'package:petstagram/widgets/comment_card.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final String postId;

  const CommentsScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool isPosting = false;

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.postId)
                  .collection('comments')
                  .orderBy('datePublished', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var comment = snapshot.data!.docs[index];
                    return CommentCard(
                      snap: comment.data()! as Map<String, dynamic>,
                    );
                  },
                );
              },
            ),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.photoUrl),
                  radius: 18,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                isPosting
                    ? CircularProgressIndicator()
                    : InkWell(
                        onTap: () async {
                          setState(() {
                            isPosting = true;
                          });
                          await FirestoreMethods().postComment(
                            widget.postId,
                            _commentController.text.trim(),
                            user.uid,
                            user.username,
                            user.photoUrl,
                          );
                          setState(() {
                            isPosting = false;
                          });
                          _commentController.clear();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: Text(
                            'Post',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

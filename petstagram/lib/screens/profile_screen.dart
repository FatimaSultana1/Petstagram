// lib/screens/profile_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petstagram/models/user.dart';
import 'package:petstagram/providers/user_provider.dart';
import 'package:petstagram/widgets/follow_button.dart';
import 'package:petstagram/widgets/post_grid.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();

      setState(() {
        userData = userSnap.data()!;
        postLen = postSnap.docs.length;
        followers = userSnap.data()!['followers'].length;
        following = userSnap.data()!['following'].length;
        // Check if current user follows this profile
        var currentUser = Provider.of<UserProvider>(context, listen: false).getUser;
        isFollowing = userSnap.data()!['followers'].contains(currentUser.uid);
      });
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  void followUser() async {
    var currentUser = Provider.of<UserProvider>(context, listen: false).getUser;
    setState(() {
      isFollowing = !isFollowing;
      isLoading = true;
    });
    try {
      if (isFollowing) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .update({
          'followers': FieldValue.arrayUnion([currentUser.uid])
        });

        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({
          'following': FieldValue.arrayUnion([widget.uid])
        });
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .update({
          'followers': FieldValue.arrayRemove([currentUser.uid])
        });

        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({
          'following': FieldValue.arrayRemove([widget.uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).getUser;

    bool isMyProfile = currentUser.uid == widget.uid;

    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: Text(userData['username']),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(userData['photoUrl']),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColumn(postLen, "Posts"),
                                    buildStatColumn(followers, "Followers"),
                                    buildStatColumn(following, "Following"),
                                  ],
                                ),
                                SizedBox(height: 8),
                                isMyProfile
                                    ? OutlinedButton(
                                        onPressed: () {
                                          // Navigate to Edit Profile Screen
                                        },
                                        child: Text('Edit Profile'),
                                      )
                                    : FollowButton(
                                        text: isFollowing ? 'Unfollow' : 'Follow',
                                        function: followUser,
                                        isLoading: isLoading,
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 12),
                        child: Text(
                          userData['username'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 4),
                        child: Text(userData['bio']),
                      ),
                    ],
                  ),
                ),
                Divider(),
                PostGrid(uid: widget.uid),
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label),
      ],
    );
  }
}

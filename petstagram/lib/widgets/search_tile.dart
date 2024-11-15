// lib/widgets/search_tile.dart

import 'package:flutter/material.dart';
import 'package:petstagram/screens/profile_screen.dart';

class SearchTile extends StatelessWidget {
  final String username;
  final String photoUrl;
  final String uid;

  const SearchTile({
    Key? key,
    required this.username,
    required this.photoUrl,
    required this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(photoUrl),
        radius: 18,
      ),
      title: Text(username),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProfileScreen(uid: uid),
          ),
        );
      },
    );
  }
}

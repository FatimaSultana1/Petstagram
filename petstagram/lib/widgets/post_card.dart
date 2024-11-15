import 'package:petstagram/screens/comments_screen.dart';

class PostCard extends StatefulWidget {
  final Map<String, dynamic> snap;

  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  // ... Existing code

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;

    return Container(
      // Add padding and decoration as needed
      padding: EdgeInsets.symmetric(vertical: 10),
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
              icon: Icon(Icons.more_vert),
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
                icon: Icon(
                  Icons.favorite_border,
                ),
                onPressed: () {
                  // Implement like functionality
                },
              ),
              IconButton(
                icon: Icon(
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
                icon: Icon(
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
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.snap['likes'].length} likes',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: widget.snap['username'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: ' ${widget.snap['description']}',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
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
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${widget.snap['datePublished'].toDate()}',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

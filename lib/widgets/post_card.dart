import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instakilo/resources/firestore_methods.dart';
import 'package:instakilo/screens/comment_screen.dart';
import 'package:instakilo/utils/colors.dart';
import 'package:instakilo/utils/utils.dart';
import 'package:instakilo/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:instakilo/models/user_model.dart';
import 'package:instakilo/provider/user_provider.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  const PostCard({super.key, required this.snap});
  final snap;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;

  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();

      setState(() {
        commentLen = snap.docs.length;
      });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  deletePost(String postId) async {
    try {
      await FirestoreMethods().deletePost(postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.only(top: 10),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4)
              .copyWith(right: 0),
          child: Row(children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(widget.snap['profImage'], scale: 1),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.snap['username'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ))
                  ],
                ),
              ),
            ),
            widget.snap['uid'].toString() == user!.uid ? 
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                showDialog(
                    context: context,
                    useRootNavigator: false,
                    builder: (context) {
                      return Dialog(
                        child: ListView(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shrinkWrap: true,
                            children: ['Delete']
                                .map((e) => InkWell(
                                      onTap: () {
                                        deletePost(widget.snap['postId'].toString());
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 16),
                                        child: Text(e),
                                      ),
                                    ))
                                .toList()),
                      );
                    });
              },
            ) : Container()
          ]),
        ),

        // Image Post Section

        GestureDetector(
          onDoubleTap: () async {
            await FirestoreMethods().likePost(
                widget.snap['postId'], user.uid, widget.snap['likes']);
            setState(() {
              isLikeAnimating = true;
            });
          },
          child: Stack(alignment: Alignment.center, children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              child: Image.network(
                widget.snap['postUrl'],
                fit: BoxFit.cover,
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isLikeAnimating ? 1 : 0,
              child: LikeAnimation(
                isAnimating: isLikeAnimating,
                duration: const Duration(microseconds: 400),
                onEnd: () {
                  setState(() {
                    isLikeAnimating = false;
                  });
                },
                child:
                    const Icon(Icons.favorite, color: Colors.white, size: 120),
              ),
            )
          ]),
        ),

        // Like, Comment, Share Section

        Row(
          children: [
            LikeAnimation(
              isAnimating: widget.snap['likes'].contains(user.uid),
              smallLike: true,
              child: IconButton(
                onPressed: () async {
                  await FirestoreMethods().likePost(
                      widget.snap['postId'], user.uid, widget.snap['likes']);
                },
                icon: widget.snap['likes'].contains(user.uid)
                    ? const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : const Icon(
                        Icons.favorite_border_outlined,
                      ),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CommentScreen(
                          postId: widget.snap['postId'],
                        )));
              },
              icon: const Icon(Icons.comment_outlined),
            ),
            Transform.rotate(
              angle: -35 * 3.1415926535 / 180,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.send),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                    icon: const Icon(Icons.bookmark_border), onPressed: () {}),
              ),
            )
          ],
        ),

        // Description Section

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    '${widget.snap['likes'].length} likes',
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 8),
                child: RichText(
                    text: TextSpan(
                        style: const TextStyle(color: primaryColor),
                        children: [
                      TextSpan(
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        text: widget.snap['username'],
                      ),
                      TextSpan(
                        text: '   ${widget.snap['description']}',
                      ),
                    ])),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'View all $commentLen comments',
                    style: const TextStyle(fontSize: 15, color: secondaryColor),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  DateFormat.yMMMd()
                      .format(widget.snap['datePublished'].toDate()),
                  style: const TextStyle(fontSize: 12, color: secondaryColor),
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}

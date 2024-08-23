import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instakilo/screens/menu_screen.dart';
import 'package:instakilo/utils/colors.dart';
import 'package:instakilo/utils/utils.dart';
import 'package:instakilo/widgets/add_post.dart';
import 'package:instakilo/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.uid});
  final String uid;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var usersnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen = postSnap.docs.length;
      userData = usersnap.data()!;
      followers = usersnap.data()!['followers'].length;
      following = usersnap.data()!['following'].length;
      isFollowing = usersnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);

      setState(() {});
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userData['username']),
              centerTitle: false,
              actions: const [
                AddPost(),
                MenuBottomSheet(),
              ],
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(userData['photoUrl']),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                buildStateColumn(postLen, "Posts"),
                                buildStateColumn(followers, "Followers"),
                                buildStateColumn(following, "Followings"),
                              ],
                            ),
                          )
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 8, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 5.0),
                              child: Text('Vicky Jaiswal'),
                            ),
                            SizedBox(
                              width: 200,
                              child: Text(userData['bio']),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            FirebaseAuth.instance.currentUser!.uid == widget.uid
                                ? FollowButton(
                                    text: 'Edit Profile',
                                    backgroundColor: Colors.grey,
                                    textColor: primaryColor,
                                    borderColor: Colors.grey,
                                    function: () {},
                                  )
                                : isFollowing
                                    ? FollowButton(
                                        text: 'Unfollow',
                                        backgroundColor: mobileBackgroundColor,
                                        textColor: primaryColor,
                                        borderColor: Colors.grey,
                                        function: () {},
                                      )
                                    : FollowButton(
                                        text: 'Follow',
                                        backgroundColor: Colors.blueAccent,
                                        textColor: primaryColor,
                                        borderColor: Colors.blueAccent,
                                        function: () {},
                                      ),
                            FollowButton(
                              text: 'Share Profile',
                              backgroundColor: Colors.grey,
                              textColor: primaryColor,
                              borderColor: Colors.grey,
                              function: () {},
                            ),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: 35,
                                height: 35,
                                child: const Icon(
                                  Icons.person_add,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(),
                
              ],
            ),
          );
  }

  Column buildStateColumn(int num, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(num.toString(),
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.white)),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instakilo/utils/colors.dart';
import 'package:instakilo/widgets/add_post.dart';
import 'package:instakilo/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: Image.asset('assets/images/ik.png', width: 150,) ,
        // title: const Text('Instakilo', style: TextStyle(
        //   fontSize: 40,
        //   fontWeight: FontWeight.bold
        // ),),
        actions: const [
          AddPost(),
        ],
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
         builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index)=> PostCard(
                snap : snapshot.data!.docs[index].data()
,              ),
            );
         })
      
    );

  }
}
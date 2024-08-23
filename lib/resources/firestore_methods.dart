import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instakilo/models/post_model.dart';
import 'package:instakilo/resources/storage_method.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // upload a post

  Future<String> uploadPost(
    String description,
    Uint8List image,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = "Some error occured";
    try {
      String photoUrl = await StorageMethods()
          .uploadImageToStorage('Post_Images', image, true);

      String postId = const Uuid().v1();
      Post post = Post(
          description: description,
          uid: uid,
          username: username,
          likes: [],
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          profImage: profImage);
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> addComment(String postId, String text, String uid, String name,
      String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid' : uid,
          'text' : text,
          'commentId': commentId,
          'datePublished' : DateTime.now(), 
        });
      }else{
        res = "Text is empty";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> deletePost(String postId) async{
    try{
      await _firestore.collection('posts').doc(postId).delete();
    }
    catch(e){
      e.toString();
    }
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instakilo/models/user_model.dart';
import 'package:instakilo/provider/user_provider.dart';
import 'package:instakilo/resources/firestore_methods.dart';
import 'package:instakilo/utils/colors.dart';
import 'package:instakilo/utils/utils.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AddPostScreen extends StatefulWidget {
  AddPostScreen({super.key, required this.file});
  Uint8List? file;

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _cationController = TextEditingController();
  bool isLoading = false;

  void postImage(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
          _cationController.text, widget.file!, uid, username, profImage);

      if (res == 'success') {
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, 'Posted!');
        Navigator.pop(context);
      } else {
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, res);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    _cationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Post to'),
        centerTitle: false,
        actions: [
          TextButton(
            child: const Text(
              'Post',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            onPressed: () => postImage(user!.uid, user.username, user.photoUrl),
          )
        ],
      ),
      body: Column(
        children: [
          isLoading
              ? const LinearProgressIndicator()
              : const Padding(
                  padding: EdgeInsets.only(top: 0),
                ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user!.photoUrl, scale: 1),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: TextField(
                  controller: _cationController,
                  decoration: const InputDecoration(
                    hintText: 'Write a caption',
                    border: InputBorder.none,
                  ),
                  maxLines: 8,
                ),
              ),
              SizedBox(
                height: 45,
                width: 45,
                child: AspectRatio(
                  aspectRatio: 487 / 451,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: MemoryImage(widget.file!),
                            fit: BoxFit.fill,
                            alignment: FractionalOffset.topCenter)),
                  ),
                ),
              ),
              const Divider()
            ],
          )
        ],
      ),
    );
  }
}

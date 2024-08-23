import 'package:flutter/material.dart';
import 'package:instakilo/resources/auth_method.dart';
import 'package:instakilo/screens/login_screen.dart';

class MenuBottomSheet extends StatelessWidget {
  const MenuBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        icon: const Icon(
          Icons.menu,
        ),
        iconSize: 30,
        // onPressed: () => _selectImage(context),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30))),
              builder: (context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: const Text('Setting'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.bookmark_border),
                        title: const Text('Saved'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.mobile_friendly),
                        title: const Text('Close Friends'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.favorite),
                        title: const Text('Favioutes'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text('Sign Out'),
                        onTap: () async {
                          await AuthMethods().signOut();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const LoginScreen())
                          );
                        },
                      ),
                    ],
                  ));
        },
      ),
    );
  }
}

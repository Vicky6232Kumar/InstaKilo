import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instakilo/resources/auth_method.dart';
import 'package:instakilo/responsive/mobile_screen_layout.dart';
import 'package:instakilo/responsive/responsive_layout_screen.dart';
import 'package:instakilo/responsive/web_screen_layout.dart';
import 'package:instakilo/screens/login_screen.dart';
import 'package:instakilo/utils/colors.dart';
import 'package:instakilo/utils/utils.dart';
import 'package:instakilo/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _profilePic;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);

    setState(() {
      _profilePic = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        profilePic: _profilePic!);

    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
              mobileview: MobileScreen(),
              webview: WebScreen(),
            ),
          ),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      if (context.mounted) {
        showSnackBar(context, res);
      }
    }
  }

  void navigatetoLogIn() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Container(),
              ),
              const Image(
                image: AssetImage('assets/images/ik.png'),
                width: 150,
              ),
              const SizedBox(
                height: 25,
              ),
              Stack(
                children: [
                  _profilePic != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(
                            _profilePic!,
                            scale: 1,
                          ),
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'https://cdn2.iconfinder.com/data/icons/website-icons/512/User_Avatar-512.png',
                              scale: 1),
                        ),
                  Positioned(
                    bottom: -10,
                    right: 2,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.camera_alt),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              TextFieldInput(
                textEditingController: _usernameController,
                hintText: 'Enter you username',
                textInputType: TextInputType.text,
              ),
              const SizedBox(
                height: 25,
              ),
              TextFieldInput(
                  textEditingController: _emailController,
                  hintText: 'Enter you email',
                  textInputType: TextInputType.emailAddress),
              const SizedBox(
                height: 25,
              ),
              TextFieldInput(
                  textEditingController: _passwordController,
                  hintText: 'Enter you password',
                  textInputType: TextInputType.text,
                  isPass: true),
              const SizedBox(
                height: 25,
              ),
              TextFieldInput(
                textEditingController: _bioController,
                hintText: 'Enter you bio',
                textInputType: TextInputType.text,
              ),
              const SizedBox(
                height: 25,
              ),
              //Button for login
              InkWell(
                onTap: signUpUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      color: blueColor),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : const Text('Sign up'),
                ),
              ),
              const SizedBox(height: 12),

              Flexible(flex: 2, child: Container()),

              // Transition to sign up screen
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text('Have an account?'),
                  ),
                  GestureDetector(
                    onTap: navigatetoLogIn,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        '   Log In',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              )

              //
            ],
          ),
        )));
  }
}

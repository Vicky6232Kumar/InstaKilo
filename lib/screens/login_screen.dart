import 'package:flutter/material.dart';
import 'package:instakilo/resources/auth_method.dart';
import 'package:instakilo/responsive/mobile_screen_layout.dart';
import 'package:instakilo/responsive/responsive_layout_screen.dart';
import 'package:instakilo/responsive/web_screen_layout.dart';
import 'package:instakilo/screens/signup_screen.dart';
import 'package:instakilo/utils/colors.dart';
import 'package:instakilo/utils/utils.dart';
import 'package:instakilo/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void logIn() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);

    if (res == 'success') {
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) =>const ResponsiveLayout(
                mobileview: MobileScreen(),
                webview: WebScreen()
              ),
            ),
            (route) => false);

        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      if (context.mounted) {
        showSnackBar(context, res);
      }
    }
  }

  void navigateToSignup() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignupScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            height: 40,
          ),
          //TextField input for email
          TextFieldInput(
              textEditingController: _emailController,
              hintText: 'Enter you email',
              textInputType: TextInputType.emailAddress),
          const SizedBox(
            height: 25,
          ),
          //TextField input for password
          TextFieldInput(
              textEditingController: _passwordController,
              hintText: 'Enter you password',
              textInputType: TextInputType.text,
              isPass: true),
          const SizedBox(
            height: 25,
          ),
          //Button for login
          InkWell(
            onTap: logIn,
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
                  : const Text('Log in'),
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
                child: const Text('Don\'t have an account?'),
              ),
              GestureDetector(
                onTap: navigateToSignup,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text(
                    '   Sign up',
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

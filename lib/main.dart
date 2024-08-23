import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instakilo/provider/user_provider.dart';
import 'package:instakilo/responsive/mobile_screen_layout.dart';
import 'package:instakilo/responsive/responsive_layout_screen.dart';
import 'package:instakilo/responsive/web_screen_layout.dart';
import 'package:instakilo/screens/login_screen.dart';
import 'package:instakilo/utils/colors.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instakilo',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        // home:const ResponsiveLayout(mobileview: MobileScreen() , webview: WebScreen() ,)
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder:(context, snapshot) {
            if(snapshot.connectionState == ConnectionState.active){
              if(snapshot.hasData){
                return const ResponsiveLayout(
                  mobileview: MobileScreen(),
                  webview: WebScreen());
              }else if(snapshot.hasError){
                return Center(
                  child: Text('${snapshot.error}'),
                );
    
              }
            }
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }
            return const LoginScreen();
          },
        )
      ),
    );
  }
}

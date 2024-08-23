import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instakilo/screens/chat_screen.dart';
import 'package:instakilo/screens/feed_screen.dart';
import 'package:instakilo/screens/notification_screen.dart';
import 'package:instakilo/screens/profile_screen.dart';
import 'package:instakilo/screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const ChatScreen(),
  const NotificationScreen(),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];

import 'package:flutter/material.dart';
import 'package:instakilo/provider/user_provider.dart';
import 'package:instakilo/utils/global_variables.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  const ResponsiveLayout({super.key, required this.mobileview, required this.webview});
  final Widget mobileview;
  final Widget webview;

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {

  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context,listen: false);
    await _userProvider.refreshUser();

  }
  @override
  Widget build(BuildContext context) {


    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >webScreenSize) {
        return widget.webview;
      } 
      return widget.mobileview;
    });
  }
}

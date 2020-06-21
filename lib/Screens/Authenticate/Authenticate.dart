import 'package:esgarden/Screens/Authenticate/Register.dart';
import 'package:esgarden/Screens/Authenticate/SignIn.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignInForm = true;

  void toggleView() {
    setState(() {
      showSignInForm = !showSignInForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignInForm) {
      return SignIn(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}

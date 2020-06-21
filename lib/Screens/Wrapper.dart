import 'package:esgarden/Library/Globals.dart' as globals;
import 'package:esgarden/Models/User.dart';
import 'package:esgarden/Screens/Authenticate/Authenticate.dart';
import 'package:esgarden/Screens/Home/Home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      return Authenticate();
    } else {
      globals.isAdmin = !user.isAnon;
      return Home();
    }
  }
}

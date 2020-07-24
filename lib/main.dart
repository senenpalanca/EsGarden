import 'package:esgarden/Models/User.dart';
import 'package:esgarden/Screens/Wrapper.dart';
import 'package:esgarden/Services/Auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/core.dart';

void main() {
  SyncfusionLicense.registerLicense("YOUR LICENSE KEY");
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(
          value: AuthService().user,
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: Wrapper(),
      ),
    );
  }
}

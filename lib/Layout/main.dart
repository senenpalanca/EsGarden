import 'dart:ui';

import 'package:esgarden/Layout/Panel.dart';
import 'package:esgarden/Library/Globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../UI/InputField.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESGardenApp',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // ignore: non_constant_identifier_names

  @override
  Widget build(BuildContext context) {
    globals.isAdmin = true;
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Login"),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.green,
          child: Center(
              child: Container(
                  width: 400,
                  height: 400,
                  child: ListView(
                    children: <Widget>[
                      Container(
                        height: 400,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Image.asset(
                                'images/icon.png',
                                width: 300.0,
                              ),
                              InputField(Icon(Icons.email, color: Colors.white),
                                  "EmailAddress", false),
                              InputField(
                                  Icon(Icons.person, color: Colors.white),
                                  "Password",
                                  true),
                              Container(
                                  width: 150,
                                  height: 50,
                                  child: RaisedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Panel()),
                                        );
                                      },
                                      color: Colors.deepOrange,
                                      textColor: Colors.white,
                                      child: Text(
                                        'login',
                                        style: TextStyle(
                                          fontSize: 30.0,
                                        ),
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30.0)))))
                            ]),
                      ),
                    ],
                  )))), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

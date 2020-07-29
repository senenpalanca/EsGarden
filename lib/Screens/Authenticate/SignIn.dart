/*
 * // Copyright <2020> <Universitat Politència de València>
 * // Permission is hereby granted, free of charge, to any person obtaining a copy of this
 * // software and associated documentation files (the "Software"), to deal in the Software
 * // without restriction, including without limitation the rights to use, copy, modify, merge,
 * // publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
 * // to whom the Software is furnished to do so, subject to the following conditions:
 * //
 * //The above copyright notice and this permission notice shall be included in all copies or
 * // substantial portions of the Software.
 * // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * // EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
 * // OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 * // AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * // THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * //
 * // This version was built by senenpalanca@gmail.com in ${DATE}
 * // Updates available in github/senenpalanca/esgarden
 * //
 * //
 */

import 'package:esgarden/Library/Globals.dart' as globals;
import 'package:esgarden/Services/Auth.dart';
import 'package:esgarden/UI/InputField.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();

  final userContoller = TextEditingController();
  final passContoller = TextEditingController();
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0.0,
        // title: Text("Sign In to ESGarden"),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            label: Text(
              "Register",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              widget.toggleView();
            },
          )
        ],
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.green,
          child: Form(
            key: _formKey,
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
                                InputField(
                                    userContoller,
                                    Icon(Icons.email, color: Colors.white),
                                    "EmailAddress",
                                    false),
                                InputField(
                                    passContoller,
                                    Icon(Icons.person, color: Colors.white),
                                    "Password",
                                    true),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, left: 40.0, right: 40.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                          width: 150,
                                          height: 50,
                                          child: RaisedButton(
                                              onPressed: () async {
                                                //_ValidateFields();
                                                if (userContoller.text != "") {
                                                  dynamic result = await _auth
                                                      .signInWithEmailAndPass(
                                                      userContoller.text,
                                                      passContoller.text);
                                                  if (result == null) {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            content: Text(
                                                                "Error signin in"),
                                                          );
                                                        });
                                                    print("error signing in");
                                                  } else {
                                                    print("signed in");
                                                    print(result.uid);
                                                  }
                                                } else {
                                                  dynamic result =
                                                  await _auth.signInAnon();
                                                  if (result == null) {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            content: Text(
                                                                "Error signin in"),
                                                          );
                                                        });
                                                    print("error signing in");
                                                  } else {
                                                    print(
                                                        "signed in anonymously");
                                                    print(result.uid);
                                                  }
                                                }
                                              },
                                              color: Colors.deepOrange,
                                              textColor: Colors.white,
                                              child: Text(
                                                'Sign in',
                                                style: TextStyle(
                                                  fontSize: 30.0,
                                                ),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(
                                                          30.0))))),
                                    ],
                                  ),
                                )
                              ]),
                        ),
                      ],
                    ))),
          )),
    );
  }

  _isAnon() {
    String user = userContoller.text;
    String pass = passContoller.text;
    if (user == "profe") {
      if (pass == "profe") {
        globals.isAdmin = true;
      } else {
        globals.isAdmin = false;
      }
    } else {
      globals.isAdmin = false;
    }
  }
}

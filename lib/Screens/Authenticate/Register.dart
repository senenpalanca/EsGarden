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

import 'package:esgarden/Services/Auth.dart';
import 'package:esgarden/UI/InputField.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final regContoller = TextEditingController();
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
              "Sing In",
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
            child: Center(
                child: Container(
                    width: 400,
                    height: 500,
                    child: ListView(
                      children: <Widget>[
                        Container(
                          height: 480,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Image.asset(
                                  'images/icon.png',
                                  width: 300.0,
                                ),
                                InputField(
                                  regContoller,
                                  Icon(Icons.email, color: Colors.white),
                                  "Teacher Code",
                                  false,
                                ),
                                InputField(
                                  userContoller,
                                  Icon(Icons.email, color: Colors.white),
                                  "Email Address",
                                  false,
                                ),
                                InputField(
                                    passContoller,
                                    Icon(Icons.person, color: Colors.white),
                                    "Password",
                                    true),
                                Container(
                                    width: 150,
                                    height: 50,
                                    child: RaisedButton(
                                        onPressed: () async {
                                          //widget.toggleView();
                                          if (_validateFields()) {
                                            dynamic result = await _auth
                                                .registerWithEmailAndPass(
                                                userContoller.text,
                                                passContoller.text);
                                            if (result == null) {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      content: Text(
                                                          "Please, supply a valid email"),
                                                    );
                                                  });
                                            }
                                          }
                                        },
                                        color: Colors.deepOrange,
                                        textColor: Colors.white,
                                        child: Text(
                                          'Register',
                                          style: TextStyle(
                                            fontSize: 30.0,
                                          ),
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30.0))))),
                              ]),
                        ),
                      ],
                    ))),
          )),
    );
  }

  bool _validateFields() {
    String reg = regContoller.text;
    String user = userContoller.text;
    String pass = passContoller.text;
    if (reg == "PQ7h99#7163@") {
      if (user != "") {
        if (pass != "") {
          return true;
        }
      }
    }
    return false;
  }
}

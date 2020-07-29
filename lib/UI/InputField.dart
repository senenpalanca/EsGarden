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

import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  Icon fieldIcon;
  String hintText;
  bool obscureText;
  final controller;

  InputField(this.controller, this.fieldIcon, this.hintText, this.obscureText);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 310,
      child: Material(
          elevation: 5.0,
          color: Colors.deepOrange,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: this.fieldIcon,
              ),
              Container(
                width: 270,
                child: TextFormField(
                  controller: controller,
                  obscureText: this.obscureText,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0))),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: this.hintText,
                  ),
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class CustomInputField extends StatefulWidget {
  @override
  CustomInputFieldState createState() => new CustomInputFieldState();
}

class CustomInputFieldState extends State<CustomInputField> {
  Icon fieldIcon;
  String hintText;
  bool obscureText;

  String result;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 310,
      child: Material(
          elevation: 5.0,
          color: Colors.deepOrange,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: this.fieldIcon,
              ),
              Container(
                width: 270,
                child: TextField(
                  obscureText: this.obscureText,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0))),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: this.hintText,
                  ),
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

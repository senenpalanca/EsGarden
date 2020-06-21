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

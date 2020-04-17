import 'package:flutter/material.dart';

class PersonalizedField extends StatelessWidget {
  TextEditingController controller;
  String hintText;
  bool obscureText;
  Icon fieldIcon;

  PersonalizedField(
      this.controller, this.hintText, this.obscureText, this.fieldIcon);

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

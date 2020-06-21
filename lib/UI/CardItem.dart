import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  double pad;
  Function tapFunction;
  String caption;
  Color color;
  IconData icon;

  CardItem({this.pad, this.caption, this.color, this.icon, this.tapFunction});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(pad),
        //Card Upper Humidity
        child: GestureDetector(
          onTap: () {
            tapFunction();
          },
          child: Card(
            elevation: 3.0,
            shape: Border(
                right: BorderSide(
              color: color,
              width: 15,
            )),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        icon,
                        size: 27,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, top: 35, bottom: 35),
                        child: Text(
                          caption,
                          style: TextStyle(fontSize: 25.0),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

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

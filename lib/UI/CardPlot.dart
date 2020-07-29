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

import 'package:badges/badges.dart';
import 'package:esgarden/Models/Plot.dart';
import 'package:esgarden/Screens/Home/Items.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CardPlot extends StatelessWidget {
  String Title;
  String ImgTitle;
  String Vegetable;
  String Location;
  Plot PlotKey;
  Map<dynamic, dynamic> alerts;
  int alertsNo;

  CardPlot(this.PlotKey);

  @override
  Widget build(BuildContext context) {
    this.Title = PlotKey.Name;
    this.Vegetable = PlotKey.Vegetable;

    this.ImgTitle = PlotKey.img;
    this.Location = PlotKey.City;
    this.alertsNo =
    0; //alerts["H1"].length + alerts["T1"].length + alerts["C1"].length - 3;

    if (this.PlotKey.Name == "General") {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: new Card(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoadItems(PlotKey: this.PlotKey)));
                  /* MaterialPageRoute(
                     builder: (context) => MainPlotItems(PlotKey: PlotKey))
              );*/
                },
                child: Material(
                    color: Colors.white,
                    elevation: 5.0,
                    shadowColor: Color(0x802196F3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: myDetailsContainer(),
                          ),
                        ),
                        createBadges(context),
                      ],
                    )),
              )),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: new Card(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
//formChartHistograms
                      // MaterialPageRoute(builder: (context) => formChartHistograms(PlotKey:PlotKey)));
                      MaterialPageRoute(
                          builder: (context) => LoadItems(PlotKey: PlotKey)));
                  //MaterialPageRoute(builder: (context) => Calendar(PlotKey:PlotKey)),
                },
                child: Material(
                    color: Colors.white,
                    elevation: 5.0,
                    shadowColor: Color(0x802196F3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: myDetailsContainer(),
                          ),
                        ),
                        createBadges(context),
                      ],
                    )),
              )),
        ),
      );
    }
  }

  createBadges(BuildContext context) {
    if (alerts != null) {
      int alertNo =
      0; //alerts["H1"].length + alerts["T1"].length + alerts["C1"].length - 3; //3 por las cabeceras de 'No Notifications
      if (alertNo > 0) {
        return new Badge(
          badgeContent: Text(
            (alertNo).toString(),
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          child: createPhoto(context),
          toAnimate: true,
        );
      } else
        return createPhoto(context);
    } else {
      return createPhoto(context);
    }
  }

  createPhoto(BuildContext context) {
    return new Container(
      width: 100,
      height: 100,
      child: FittedBox(
        fit: BoxFit.fill,
        child: Image(
          image: NetworkImage(ImgTitle),
        ),
      ),
    );
  }

  Widget myDetailsContainer() {
    return Padding(
      padding: const EdgeInsets.only(right: 1.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(
                child: Text(
                  Title,
                  style: TextStyle(
                      color: Color(0xffe6020a),
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                        child: Text(
                          "No Alerts ",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 18.0,
                          ),
                        )),
                    Container(
                        child: Text(
                          "(0) \u00B7 Sunny",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 18.0,
                          ),
                        )),
                  ],
                )),
          ),
          Container(
              child: Text(
                Vegetable + " \u00B7 " + Location,
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }
}

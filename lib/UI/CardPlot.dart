import 'package:badges/badges.dart';
import 'package:esgarden/Layout/Items.dart';
import 'package:esgarden/Structure/Plot.dart';
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
    this.alerts = PlotKey.alerts;
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
                  //MaterialPageRoute(builder: (context) => MainPlot(PlotKey: this.PlotKey)),
                  MaterialPageRoute(
                      builder: (context) => MainPlotItems(PlotKey: PlotKey)));
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
                      builder: (context) => MainPlotItems(PlotKey: PlotKey)));
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

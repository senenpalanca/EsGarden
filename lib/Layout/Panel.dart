import 'package:esgarden/Layout/Home.dart';
import 'package:esgarden/Library/Globals.dart' as Globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Panel extends StatelessWidget {
  List orchards = Globals.orchards;
  List catalog = Globals.catalog;

  Panel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Main Panel"),
          backgroundColor: Colors.green,
        ),
        body: Container(
          color: Colors.white,
          child: ListView(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(10.0),
            children: <Widget>[
              _buildOrchardCard(context),
              //_buildCatalogCard(context),
            ],
          ),
        ));
  }

  Widget _buildOrchardCard(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          child: Container(
            child: Card(
                elevation: 5.0,
                borderOnForeground: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      height: 80,
                      color: Colors.redAccent,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          "Gardens",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 35.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 80,
                      color: Colors.white,
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0, left: 40),
                            child: Text(
                              "2" + " Garden(s)",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 35.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 185.0),
                            child: Icon(Icons.apps),
                          )
                        ],
                      ),
                    )
                  ],
                )),
          ),
        ),
      ),
    ));
  }

  Widget _buildCatalogCard(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: () {},
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          child: Container(
            child: Card(
                elevation: 5.0,
                borderOnForeground: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      height: 80,
                      color: Colors.blue,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          "Catalog",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 35.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 80,
                      color: Colors.white,
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0, left: 20),
                            child: Text(
                              catalog.length.toString() + " Vegetables",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 35.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 235.0),
                            child: Icon(Icons.category),
                          )
                        ],
                      ),
                    )
                  ],
                )),
          ),
        ),
      ),
    ));
  }
}

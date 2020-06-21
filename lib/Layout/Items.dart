import 'dart:math';

import 'package:esgarden/Layout/FormChartHistograms.dart';
import 'package:esgarden/Layout/FormVegetable.dart';
import 'package:esgarden/Layout/Home.dart';
import 'package:esgarden/Library/Globals.dart' as globals;
import 'package:esgarden/Models/Plot.dart';
import 'package:esgarden/Screens/Graphs/MainScreen.dart';
import 'package:esgarden/Screens/Graphs/Wind/FormWind.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// MyApp is a StatefulWidget. This allows updating the state of the
// widget when an item is removed.
class MainPlotItems extends StatefulWidget {
  Plot PlotKey;
  List items;
  List LVItems;

  MainPlotItems({Key key, @required this.PlotKey}) : super(key: key);

  @override
  MainPlotItemsState createState() {
    final _database = FirebaseDatabase.instance.reference();
    final databaseReference = _database
        .child("Gardens")
        .child(PlotKey.parent)
        .child("sensorData")
        .child(PlotKey.key)
        .child("Items")
        .onChildAdded
        .listen(_obtenerItems);
    items = new List();
    LVItems = List<Dismissible>();
    return MainPlotItemsState();
  }

  _obtenerItems(Event event) {
    if (!items.contains(event.snapshot.value)) {
      items.add(event.snapshot.value);
    }
  }
}

class MainPlotItemsState extends State<MainPlotItems> {
  bool firstTime = true;
  String textToAdd = "";
  String textToView = "";

  final _database = FirebaseDatabase.instance.reference();
  List<String> allItems = new List<String>();
  List itemsListView = new List<
      Dismissible>(); //["Humidity","Temperature","Vegetable","ElectroValve"]
  List<String> totalItems = [
    //"Soil Humidity",
    //"Soil Temperature",
    //"Vegetable",
    //"ElectroValve",
    //"Ambient Humidity",
    //"Air Quality",
    //"Ambient Temperature",
    //"Luminosity",
    //"GeoLocalization"
  ];

  Future<String> getDataFromFuture() async {
    return new Future.delayed(Duration(milliseconds: 1000), () => "WaitFinish");
  }

  void _showDeleteDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Delete Plot " + widget.PlotKey.Name),
          content: new Text("Are you sure you want to delete this plot?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                final _database = FirebaseDatabase.instance.reference();
                final databaseReference = _database
                    .child("Gardens")
                    .child(widget.PlotKey.parent)
                    .child("sensorData")
                    .child(widget.PlotKey.key)
                    .remove();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showChangeNameDialog(BuildContext context) {
    String plotName = '';
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('Enter current team'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Plot Name', hintText: 'eg. Tomatoes from UPV'),
                onChanged: (value) {
                  plotName = value;
                },
              ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                if (plotName.length > 0) {
                  final _database = FirebaseDatabase.instance.reference();
                  final databaseReference = _database
                      .child("Gardens")
                      .child(widget.PlotKey.parent)
                      .child("sensorData")
                      .child(widget.PlotKey.key)
                      .child("Name")
                      .set(plotName);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _chargePopUpItemsList() {
    if (widget.PlotKey.key == "General") {
      totalItems.clear();
      totalItems.add("GeoLocalization");
      totalItems.add("Ambient Humidity");
      totalItems.add("Air Quality");
      totalItems.add("Ambient Temperature");
      totalItems.add("Brightness");
      totalItems.add("Wind");
    } else if (widget.PlotKey.key == "Nursery") {
      totalItems.clear();
      //totalItems.add("Soil Humidity");
      //totalItems.add("Soil Temperature");
      totalItems.add("Brightness");
    } else if (widget.PlotKey.key == "Compost") {
      totalItems.clear();
      totalItems.add("Compost Humidity");
      totalItems.add("Air Quality");
      totalItems.add("Historic Data");
      totalItems.add("Compost Temperature");
      totalItems.add("Brightness");
    } else {
      totalItems.clear();
      totalItems.add("Vegetable");
      totalItems.add("Soil Humidity");
      totalItems.add("PH");
      totalItems.add("Soil Temperature");
      totalItems.add("Air Quality");
      totalItems.add("Brightness");
      totalItems.add("ElectroValve");
      totalItems.add("Noise Detection");
    }
  }

  @override
  Widget build(BuildContext context) {
    _chargePopUpItemsList();
    print(globals.isAdmin);
    final title = 'Items of ' + widget.PlotKey.Name;
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
          appBar: AppBar(
            leading: new IconButton(
                icon: new Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                }),
            actions: <Widget>[
              PopupMenuButton<Choizable>(
                icon: Icon(Icons.add),
                onSelected: choiceAction,
                itemBuilder: (BuildContext context) {
                  setState(() {
                    if (textToAdd == "") {
                      allItems.clear();
                    } else {
                      allItems.clear();
                      allItems.add(textToAdd);
                      textToAdd = "";
                    }

                    for (int i = 0; i < totalItems.length; i++) {
                      if (!widget.items.contains(totalItems[i])) {
                        allItems.add(totalItems[i]);
                      }
                    }
                    ////print("Creating PopUpMenu...");
                    //print("items:"+widget.items.toString());
                    //print("allItems:"+allItems.toString());
                    //print("LVItems:"+widget.LVItems.toString());
                  });
                  return allItems.map((String itemNow) {
                    return PopupMenuItem<Choizable>(
                      value: Choizable(
                        name: itemNow,
                      ),
                      child: Choizable(
                        name: itemNow,
                      ),
                    );
                  }).toList();
                },
              ),
              PopupMenuButton<int>(
                  enabled: globals.isAdmin,
                  itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          enabled: false,
                          value: 1,
                          child: Text(
                            "Options",
                            style:
                                TextStyle(color: Colors.green, fontSize: 16.0),
                          ),
                        ),
                        PopupMenuItem(
                          value: 2,
                          enabled: globals.isAdmin,
                          child: FlatButton(
                            onPressed: () {
                              _showChangeNameDialog(context);
                            },
                            child: Text(
                              "Change name",
                              style: TextStyle(
                                  color: Colors.black45, fontSize: 18.0),
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          enabled: false, //Sig. version
                          value: 2,
                          child: FlatButton(
                            onPressed: () {
                              /* Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Calendar(
                                          PlotKey: widget.PlotKey,
                                        )),
                              );*/
                            },
                            child: Text(
                              "Calendar",
                              style: TextStyle(
                                  color: Colors.black45, fontSize: 18.0),
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          enabled: globals.isAdmin,
                          value: 2,
                          child: FlatButton(
                            onPressed: () {
                              _showDeleteDialog(context);
                            },
                            child: Text(
                              "Delete Plot",
                              style: TextStyle(
                                  color: Colors.black45, fontSize: 18.0),
                            ),
                          ),
                        ),
                      ]),
            ],
            title: Text(title),
          ),
          body: FutureBuilder(
            future: getDataFromFuture(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                //print("Building ListView...");
                if (firstTime) {
                  for (int i = 0; i < widget.items.length; i++) {
                    widget.LVItems.add(_createDismissible(widget.items[i], i));
                  }
                  firstTime = false;
                }
                //print("items:"+widget.items.toString());
                //print("allItems:"+allItems.toString());
                //print("LVItems:"+widget.LVItems.toString());

                return ListView.builder(
                  itemCount: widget.LVItems == null ? 0 : widget.LVItems.length,
                  itemBuilder: (context, index) {
                    return widget.LVItems[index];
                  },
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          )),
    );
  }

  void choiceAction(Choizable choice) {
    setState(() {
      widget.items.add(choice.name);
      widget.LVItems.add(
          _createDismissible(choice.name, widget.LVItems.length));
      //print("Selecting a choice from PopUpMenu...");
      //print("items:"+widget.items.toString());
      //print("allItems:"+allItems.toString());
      //print("LVItems:"+widget.LVItems.toString());
    });

    final databaseReference = _database
        .child("Gardens")
        .child(widget.PlotKey.parent)
        .child("sensorData")
        .child(widget.PlotKey.key)
        .child("Items")
        .set(widget.items);
  }

  int _removeDimissible(itemTitle) {
    for (int i = 0; i < widget.LVItems.length; i++) {
      if (widget.LVItems[i].toString().substring(15).startsWith(itemTitle)) {
        return i;
      }
    }
    return -1;
  }

  Widget _createDismissible(String itemTitle, int index) {
    return Dismissible(
        key: Key(itemTitle),
        onDismissed: (direction) {
          setState(() {
            //SE ELIMINA DEL VISOR, AÑADIRLO AL MENU QUITANDOLO DE WIDGET
            widget.items.remove(itemTitle);
            textToAdd = itemTitle;
            widget.LVItems.removeAt(_removeDimissible(itemTitle));

            //se quita de la BD
          });
          //print("Dimissing element...");
          //print("items:"+widget.items.toString());
          //print("allItems:"+allItems.toString());
          //print("LVItems:"+widget.LVItems.toString());

          final databaseReference = _database
              .child("Gardens")
              .child(widget.PlotKey.parent)
              .child("sensorData")
              .child(widget.PlotKey.key)
              .child("Items")
              .set(widget.items);
          // Scaffold.of(context)
          // .showSnackBar(SnackBar(content: Text("$itemTitle hided")));
        },
        // Show a red background as the item is swiped away.
        background: Container(color: Colors.red),
        child: _createTab('$itemTitle'));
  }

  Widget _createTab(String itemTitle) {
    var pad = const EdgeInsets.all(8);

    switch (itemTitle) {
      case "Compost Humidity":
        return Padding(
            padding: pad,
            //Card Upper Humidity
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => formChart(
                          PlotKey: widget.PlotKey,
                          color: Colors.blue,
                          type: "ambienthumidity")),
                );
              },
              child: Card(
                elevation: 3.0,
                shape: Border(
                    right: BorderSide(
                  color: Colors.cyan,
                  width: 15,
                )),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.cloud_queue,
                            size: 27,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 35, bottom: 35),
                            child: Text(
                              "Compost Humidity",
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
        break;
      case "Historic Data":
        return Padding(
            padding: pad,
            //Card Upper Humidity
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          formChartHistograms(PlotKey: widget.PlotKey)),
                );
              },
              child: Card(
                elevation: 3.0,
                shape: Border(
                    right: BorderSide(
                  color: Colors.red,
                  width: 15,
                )),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.graphic_eq,
                            size: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 35, bottom: 35),
                            child: Text(
                              "Historic Data",
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
        break;
      case "Compost Temperature":
        return Padding(
            padding: pad,
            //Card Upper Humidity
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => formChart(
                          PlotKey: widget.PlotKey,
                          color: Colors.red,
                          type: "soiltemperature")),
                );
              },
              child: Card(
                elevation: 3.0,
                shape: Border(
                    right: BorderSide(
                  color: Colors.red,
                  width: 15,
                )),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.ac_unit,
                            size: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 35, bottom: 35),
                            child: Text(
                              "Compost Temperature",
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
        break;
      case "PH":
        return Padding(
            padding: pad,
            //Card Upper Humidity
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => formChart(
                          PlotKey: widget.PlotKey,
                          color: Colors.blue,
                          type: "ph")

                      /* (context) =>SelectionCallbackExample.withSampleData() formChart(
                          PlotKey: widget.PlotKey,
                          color: Colors.blue,
                          type: "ph")*/
                      ),
                );
              },
              child: Card(
                elevation: 3.0,
                shape: Border(
                    right: BorderSide(
                  color: Colors.blue,
                  width: 15,
                )),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.scatter_plot,
                            size: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 35, bottom: 35),
                            child: Text(
                              "PH",
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
        break;
      case "Soil Humidity":
        return Padding(
            padding: pad,
            //Card Upper Humidity
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => formChart(
                          PlotKey: widget.PlotKey,
                          color: Colors.blue,
                          type: "soilhumidity")),
                );
              },
              child: Card(
                elevation: 3.0,
                shape: Border(
                    right: BorderSide(
                  color: Colors.blue,
                  width: 15,
                )),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.scatter_plot,
                            size: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 35, bottom: 35),
                            child: Text(
                              "Soil Humidity",
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
        break;
      case "Soil Temperature":
        return Padding(
            padding: pad,
            //Card Upper Humidity
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => formChart(
                          PlotKey: widget.PlotKey,
                          color: Colors.red,
                          type: "soiltemperature")),
                );
              },
              child: Card(
                elevation: 3.0,
                shape: Border(
                    right: BorderSide(
                  color: Colors.red,
                  width: 15,
                )),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.ac_unit,
                            size: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 35, bottom: 35),
                            child: Text(
                              "Soil Temperature",
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
        break;
      case "Vegetable":
        return Padding(
            padding: pad,
            //Card Upper Humidity
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          formVegetable(PlotKey: widget.PlotKey)),
                );
              },
              child: Card(
                elevation: 3.0,
                shape: Border(
                    right: BorderSide(
                  color: Colors.green,
                  width: 15,
                )),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.list,
                            size: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 35, bottom: 35),
                            child: Text(
                              "Vegetable",
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
        break;
      case "ElectroValve":
        return Padding(
            padding: pad,
            //Card Upper Humidity
            child: GestureDetector(
              onTap: () {},
              child: Card(
                elevation: 3.0,
                shape: Border(
                    right: BorderSide(
                  color: Colors.cyan,
                  width: 15,
                )),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.vertical_align_center,
                            size: 27,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 35, bottom: 35),
                            child: Text(
                              "ElectroValve",
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
        break;
      case "GeoLocalization":
        return Padding(
            padding: pad,
            //Card Upper Humidity
            child: GestureDetector(
              onTap: () {
                _throwNotImplemented(context);
              },
              child: Card(
                elevation: 3.0,
                shape: Border(
                    right: BorderSide(
                  color: Colors.green,
                  width: 15,
                )),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.gps_fixed,
                            size: 27,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 35, bottom: 35),
                            child: Text(
                              "GeoLocalization",
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
        break;
      case "Air Quality":
        return Padding(
            padding: pad,
            //Card Upper Humidity
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => formChart(
                          PlotKey: widget.PlotKey,
                          color: Colors.green,
                          type: "co2")),
                );
              },
              child: Card(
                elevation: 3.0,
                shape: Border(
                    right: BorderSide(
                  color: Colors.green,
                  width: 15,
                )),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.scatter_plot,
                            size: 27,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 35, bottom: 35),
                            child: Text(
                              "Air Quality",
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
        break;
      case "Ambient Temperature":
        return Padding(
            padding: pad,
            //Card Upper Humidity
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => formChart(
                          PlotKey: widget.PlotKey,
                          color: Colors.red,
                          type: "ambienttemperature")),
                );
              },
              child: Card(
                elevation: 3.0,
                shape: Border(
                    right: BorderSide(
                  color: Colors.red,
                  width: 15,
                )),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.ac_unit,
                            size: 27,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 35, bottom: 35),
                            child: Text(
                              "Ambient Temperature",
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
        break;
      case "Ambient Humidity":
        return Padding(
            padding: pad,
            //Card Upper Humidity
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => formChart(
                          PlotKey: widget.PlotKey,
                          color: Colors.blue,
                          type: "ambienthumidity")),
                );
              },
              child: Card(
                elevation: 3.0,
                shape: Border(
                    right: BorderSide(
                  color: Colors.cyan,
                  width: 15,
                )),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.cloud_queue,
                            size: 27,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 35, bottom: 35),
                            child: Text(
                              "Ambient Humidity",
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
        break;
      case "Brightness":
        return Padding(
            padding: pad,
            //Card Upper Humidity
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => formChart(
                          PlotKey: widget.PlotKey,
                          color: Colors.orange,
                          type: "brightness")),
                );
              },
              child: Card(
                elevation: 3.0,
                shape: Border(
                    right: BorderSide(
                  color: Colors.yellowAccent,
                  width: 15,
                )),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.lightbulb_outline,
                            size: 27,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 35, bottom: 35),
                            child: Text(
                              "Brightness",
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
        break;
      case "Wind":
        return Padding(
            padding: pad,
            //Card Upper Humidity
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => formWind(PlotKey: widget.PlotKey)),
                );
              },
              child: Card(
                elevation: 3.0,
                shape: Border(
                    right: BorderSide(
                  color: Colors.yellowAccent,
                  width: 15,
                )),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.lightbulb_outline,
                            size: 27,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 35, bottom: 35),
                            child: Text(
                              "Wind",
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
        break;
      case "Noise Detection":
        return Padding(
            padding: pad,
            //Card Upper Humidity
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => formChart(
                          PlotKey: widget.PlotKey,
                          color: Colors.red,
                          type: "relativenoise")),
                );
              },
              child: Card(
                elevation: 3.0,
                shape: Border(
                    right: BorderSide(
                  color: Colors.redAccent,
                  width: 15,
                )),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.surround_sound,
                            size: 27,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 35, bottom: 35),
                            child: Text(
                              "Noise Detection",
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
        break;
      default:
        return Padding(
            padding: pad,
            //Card Upper Humidity
            child: GestureDetector(
              child: Card(
                elevation: 3.0,
                shape: Border(
                    right: BorderSide(
                  color: Colors.black,
                  width: 15,
                )),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.scatter_plot,
                            size: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 35, bottom: 35),
                            child: Text(
                              itemTitle,
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
        break;
    }
  }

  _throwNotImplemented(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Not Implemented"),
            content: Text("Not implemented yet."),
          );
        });
  }
}

class Choizable extends StatelessWidget {
  String name;

  Choizable({Key key, @required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List colors = [
      Colors.pinkAccent,
      Colors.purpleAccent,
      Colors.green,
      Colors.blue,
      Colors.yellowAccent,
      Colors.deepOrange,
      Colors.cyan,
      Colors.deepPurple
    ];
    Random random = new Random();
    int index = random.nextInt(8);
    return Card(
      elevation: 3.0,
      shape: Border(
          right: BorderSide(
        color: colors[index],
        width: 5,
      )),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.scatter_plot,
                  size: 30,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 0.0, top: 20, bottom: 20),
                  child: Text(
                    name,
                    style: TextStyle(fontSize: 18.0),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

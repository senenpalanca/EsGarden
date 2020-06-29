import 'package:esgarden/Library/Globals.dart' as Globals;
import 'package:esgarden/Models/Orchard.dart';
import 'package:esgarden/Models/Plot.dart';
import 'package:esgarden/Screens/Create/createPlot.dart';
import 'package:esgarden/Services/Auth.dart';
import 'package:esgarden/UI/CardPlot.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlotsOfGarden extends StatefulWidget {
  Orchard OrchardKey;

  PlotsOfGarden({this.OrchardKey});

  @override
  _PlotsState createState() => _PlotsState();
}

class _PlotsState extends State<PlotsOfGarden> {
  List plots = new List();
  final AuthService _auth = AuthService();
  bool isTeacher = false;
  DatabaseReference plotsref;

  @override
  void initState() {
    super.initState();
    final FirebaseDatabase _database = FirebaseDatabase.instance;
    plotsref = _database
        .reference()
        .child('Gardens')
        .child(widget.OrchardKey.key)
        .child('sensorData');
    plotsref.reference().onChildAdded.listen(_onChildAdded);
    plotsref.reference().onChildChanged.listen(_onChildChanged);
    plotsref.reference().onChildRemoved.listen(_onChildChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.OrchardKey.key),
          actions: <Widget>[
            PopupMenuButton<int>(
                onSelected: _manageMenuOptions,
                enabled: true,
                itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        enabled: false,
                        value: 1,
                        child: Text(
                          "Options",
                          style: TextStyle(color: Colors.green, fontSize: 16.0),
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        enabled: Globals.isAdmin,
                        child: FlatButton(
                          onPressed: () {
                            _showDeleteDialog(context);
                          },
                          child: Text(
                            "Delete Garden",
                            style: TextStyle(
                                color: Colors.black45, fontSize: 18.0),
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FormPlot(
                                        OrchardKey: widget.OrchardKey,
                                      )),
                            );
                          },
                          child: Text(
                            "Create Plot",
                            style: TextStyle(
                                color: Colors.black45, fontSize: 18.0),
                          ),
                        ),
                      ),
                    ]),

            /*IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FormPlot(OrchardKey: OrchardKey,)),
                );
              },
            ),*/
          ],
          backgroundColor: Colors.green,
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              child: FirebaseAnimatedList(
                query: plotsref,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  return new CardPlot(plots[index]);
                },
              ),
            ),
          ],
        ));
  }

  void _onChildAdded(Event event) {
    setState(() {
      plots.add(Plot.fromSnapshot(event.snapshot));
    });
  }

  void _onChildChanged(Event event) {
    var old = plots.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      plots[plots.indexOf(old)] = Plot.fromSnapshot(event.snapshot);
    });
  }

  void _manageMenuOptions(int value) {
    if (value == 2) {
      // _showDialog();
    }
  }

  void _showDeleteDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Delete Garden " + widget.OrchardKey.key),
          content: new Text("Are you sure you want to delete this garden?"),
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
                    .child(widget.OrchardKey.key)
                    .remove();
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

/*
class PlotsOfGarden extends StatelessWidget {
  final FirebaseDatabase _databasePlots = FirebaseDatabase.instance;
  List plots = new List();
  Orchard OrchardKey;

  PlotsOfGarden({Key key, @required this.OrchardKey}) : super(key: key);

  Future<String> getDataFromFuture() async {
    return new Future.delayed(Duration(milliseconds: 500), () => "WaitFinish");
  }

  void _manageMenuOptions(int value) {
    if (value == 2) {
      // _showDialog();
    }
  }

  void _showDeleteDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Delete Garden " + OrchardKey.key),
          content: new Text("Are you sure you want to delete this garden?"),
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
                final databaseReference =
                    _database.child("Gardens").child(OrchardKey.key).remove();
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);



              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("build_plots");
    _handleData();

    return Scaffold(
        appBar: AppBar(
          title: Text(OrchardKey.key),
          actions: <Widget>[
            PopupMenuButton<int>(
                onSelected: _manageMenuOptions,
                enabled: true,
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    enabled: false,
                    value: 1,
                    child: Text(
                      "Options",
                      style: TextStyle(color: Colors.green, fontSize: 16.0),
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    enabled: Globals.isAdmin,
                    child: FlatButton(
                      onPressed: () {
                        _showDeleteDialog(context);
                      },
                      child: Text(
                        "Delete Garden",
                        style: TextStyle(
                            color: Colors.black45, fontSize: 18.0),
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FormPlot(
                                OrchardKey: OrchardKey,
                              )),
                        );
                      },
                      child: Text(
                        "Create Plot",
                        style: TextStyle(
                            color: Colors.black45, fontSize: 18.0),
                      ),
                    ),
                  ),
                ]),

            /*IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FormPlot(OrchardKey: OrchardKey,)),
                );
              },
            ),*/
          ],
          backgroundColor: Colors.green,
        ),
        body: FutureBuilder(
          future: getDataFromFuture(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Container(
                color: Colors.white,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(10.0),
                  children:
                  plots.map<Widget>((data) => _buildItem(data)).toList(),
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ));
  }

  _handleData() {
    DatabaseReference Gardens = _databasePlots.reference().child('Gardens');
    DatabaseReference usuario = Gardens.reference().child(OrchardKey.key);
    usuario.reference().child('sensorData').onChildAdded.listen(_onNewPlot);
  }

  _onNewPlot(Event event) {
    Plot n = Plot.fromSnapshot(event.snapshot);
    plots.add(n);
  }

  Widget _buildItem(Plot target) {
    if (target != null) {
      return CardPlot(target);
    }
    return Container();
  }
}
*/
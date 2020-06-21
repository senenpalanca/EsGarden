import 'package:esgarden/Layout/Home.dart';
import 'package:esgarden/Models/Orchard.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Panel extends StatelessWidget {
  List<Orchard> orchards = [];
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Panel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HandleData();
    return Scaffold(
        appBar: AppBar(
          title: Text("Main Board"),
          backgroundColor: Colors.green,
        ),
        body: FutureBuilder(
          future: getDataFromFuture(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return formUI(context);
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  HandleData() {
    orchards.clear();
    _database.reference().child('Gardens').onChildAdded.listen(_onNewVegetable);
  }

  Widget formUI(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(10.0),
        children: <Widget>[
          _buildOrchardCard(context),
          //_buildCatalogCard(context),
        ],
      ),
    );
  }

  void _onNewVegetable(Event event) {
    Orchard n = Orchard.fromSnapshot(event.snapshot);
    orchards.add(n);
  }

  Future<String> getDataFromFuture() async {
    return new Future.delayed(Duration(milliseconds: 2000), () => "WaitFinish");
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
                              orchards.length.toString() + " Garden(s)",
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
/*
  DEPRECATED
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
*/

}

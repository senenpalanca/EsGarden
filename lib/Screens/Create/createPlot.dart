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

import 'package:esgarden/Models/Orchard.dart';
import 'package:esgarden/Models/Plot.dart';
import 'package:esgarden/Models/Vegetable.dart';
import 'package:esgarden/UI/PersonalizedField.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormPlot extends StatefulWidget {
  Orchard OrchardKey;
  List<Vegetable> vegetables;
  List<Plot> plots;

  FormPlot({Key key, @required this.OrchardKey}) : super(key: key);

  @override
  FormPlotState createState() {
    vegetables = new List<Vegetable>();
    plots = new List<Plot>();
    // if(!vegetables.isEmpty){vegetables.clear();}
    final _database = FirebaseDatabase.instance.reference();
    final databaseReferenceVegetable =
    _database.child("Vegetables").onChildAdded.listen(_onNewVegetable);
    final databaseReferencePlot = _database
        .child("Gardens")
        .child(OrchardKey.key)
        .child("sensorData")
        .onChildAdded
        .listen(_onNewPlot);
    return FormPlotState();
  }

  _onNewVegetable(Event event) {
    Vegetable n = Vegetable.fromSnapshot(event.snapshot);
    vegetables.add(n);
  }

  _onNewPlot(Event event) {
    Plot n = Plot.fromSnapshot(event.snapshot);
    plots.add(n);
  }
}

class FormPlotState extends State<FormPlot> {
  List<String> vegetableNames;
  final nameContoller = TextEditingController();
  final imgContoller = TextEditingController();

  final _database = FirebaseDatabase.instance.reference();
  String vegetableValue = '0';
  List<String> idVegetables = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    "12"
  ];

  Future<String> getDataFromFuture() async {
    return new Future.delayed(Duration(milliseconds: 1000), () => "WaitFinish");
  }

  @override
  Widget build(BuildContext context) {
    //print(vegetableNames);
    return FutureBuilder(
        future: getDataFromFuture(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            vegetableNames = widget.vegetables.map((Vegetable v) {
              return (v.name);
            }).toList();

            return Scaffold(
              floatingActionButton: createGardenButton(context),
              appBar: AppBar(
                title: Text("Create new Plot"),
              ),
              body: formUI(),
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  @override
  void dispose() {
    nameContoller.dispose();
    imgContoller.dispose();

    super.dispose();
  }

  Widget formUI() {
    return Container(
      color: Colors.green,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: ListView(
          children: <Widget>[
            Container(
              height: 500,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Image.asset(
                      'images/icon.png',
                      width: 300.0,
                    ),
                    PersonalizedField(nameContoller, "Name of the Plot", false,
                        Icon(Icons.note_add, color: Colors.white)),
                    Container(
                      width: 310,
                      child: Material(
                          elevation: 5.0,
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 16.0,
                                    left: 8.0,
                                    right: 8.0,
                                    bottom: 16.0),
                                child: Icon(
                                  Icons.library_books,
                                  color: Colors.white,
                                ),
                              ),

                              Material(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0)),
                                child: Container(
                                  width: 270,
                                  height: 58,
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(left: 10.0),
                                        child: DropdownButton<String>(
                                          value: vegetableValue,
                                          items:
                                          idVegetables.map((String value) {
                                            return new DropdownMenuItem<String>(
                                              value: value,
                                              child: _createDropDownItem(value),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              print(value);
                                              vegetableValue = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _createDropDownItem(String value) {
    switch (value) {
      case '0':
        return new Text(
          _getTextVegetable(value),
          style: TextStyle(fontSize: 20.0, color: Colors.black54),
          textAlign: TextAlign.center,
        );
        break;

      default:
        return new Text(
          _getTextVegetable(value),
          style: TextStyle(fontSize: 20.0, color: Colors.black54),
          textAlign: TextAlign.center,
        );
        break;
    }
  }

  String _getTextVegetable(String num) {
    if (int.parse(num) > 0) {
      return widget.vegetables[int.parse(num) - 1].name;
    }
    return "Select a Vegetable";
  }

  Widget createGardenButton(BuildContext context) {
    return new FloatingActionButton.extended(
      onPressed: () {
        if (!_ValidateFields()) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Error with some fields!!"),
                  content:
                  Text("Check your fields, maybe your name it's used yet."),
                );
              });
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Plot Created"),
                  content: Text(
                      "The plot " + nameContoller.text + " has been created!"),
                );
              });
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          //Navigator.pop(context);
        }
      },
      label: Text(
        'Create Plot',
        style: TextStyle(fontSize: 20.0),
      ),
      icon: Icon(Icons.thumb_up),
      backgroundColor: Colors.deepOrange,
    );
  }

  bool _ValidateFields() {
    String name = nameContoller.text;

    if (widget.OrchardKey.plots[name] == null) {
      if (name.length > 0 && vegetableValue != "0" &&
          vegetableValue != idVegetables.length - 1) {
        print("Fields validated");
        _createRecord();
        return true;
      } else {
        print("Fields not validated");
        return false;
      }
    } else
      return false;
  }


  void _createRecord() {
    final databaseReference = _database.child("Gardens");
    final databaseOrchard = databaseReference.child(widget.OrchardKey.key);
    final databasePlot = databaseOrchard.child("sensorData");
    String plotKey = findFirstPlace();
    var set =
    databasePlot.child("plot " + (widget.plots.length - 2).toString()).set({
      "Name": nameContoller.text,
      "Valve": {
        "Max": [0],
        "Min": [0],
        "Active": [0],
        "Sensor": 255
      },
      "Data": {},
      "City": widget.OrchardKey.City,
      "Img": widget.vegetables[int.parse(vegetableValue) - 1]
          .Img, //La llave del misterio
      "Items": ["Vegetable"],
      "Parent": widget.OrchardKey.key,
      "Vegetable": _getTextVegetable(vegetableValue),
      "VegetableIndex": vegetableValue,
    });
  }

  String findFirstPlace() {

  }


}

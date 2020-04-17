import 'package:esgarden/Structure/Plot.dart';
import 'package:esgarden/Structure/Vegetable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  Plot PlotKey;

  Calendar({Key key, @required this.PlotKey}) : super(key: key);

  @override
  CalendarState createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  Vegetable vegetable;
  List<Vegetable> vegetables = [];

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  CalendarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    HandleData();
    return Scaffold(
        appBar: AppBar(
          title: Text("Calendar of " + widget.PlotKey.Vegetable),
          backgroundColor: Colors.green,
        ),
        body: FutureBuilder(
          future: getDataFromFuture(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return formUI();
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  HandleData() {
    vegetables.clear();
    _database
        .reference()
        .child('Gardens')
        .onChildAdded
        .listen(_onNewVegetable);
  }

  void _onNewVegetable(Event event) {
    Vegetable n = Vegetable.fromSnapshot(event.snapshot);
    vegetables.add(n);
  }

  Widget formUI() {
    return Container(
      color: Colors.white70,
      child: ListView(
        children: <Widget>[],
      ),
    );
  }

  Future<String> getDataFromFuture() async {
    return new Future.delayed(Duration(milliseconds: 1000), () => "WaitFinish");
  }
}

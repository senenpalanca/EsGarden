import 'package:esgarden/Library/Globals.dart' as globals;
import 'package:esgarden/Models/Orchard.dart';
import 'package:esgarden/Screens/Create/createGarden.dart';
import 'package:esgarden/Services/Auth.dart';
import 'package:esgarden/UI/CardGarden.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  List<Orchard> gardens = new List();
  bool isTeacher = false;

  Future<String> getDataFromFuture() async {
    isTeacher = await _auth.isTeacher();
    return new Future.delayed(Duration(milliseconds: 2000), () => "WaitFinish");
  }

  _handleData() {
    DatabaseReference gardensref = _database.reference().child('Gardens');
    gardensref.reference().onChildAdded.listen(_onNewGarden);
  }

  _onNewGarden(Event event) {
    Orchard n = Orchard.fromSnapshot(event.snapshot);
    gardens.add(n);
  }

  CardGarden _buildItem(Orchard target) {
    if (target != null) {
      return CardGarden(target);
    }
  }

  @override
  Widget build(BuildContext context) {
    _handleData();
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          actions: <Widget>[
            LogOutButton(),
          ],
          backgroundColor: Colors.green,
        ),
        floatingActionButton: FloatingButton(context),
        body: FutureBuilder(
          future: getDataFromFuture(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Container(
                  color: Colors.white,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.all(10.0),
                    children: gardens
                        .map<Widget>((data) => _buildItem(data))
                        .toList(),
                  ));
            }
            return Center(child: CircularProgressIndicator());
          },
        ));
  }

  //Teacher Funcs
  Widget LogOutButton() {
    //if(globals.isAdmin){
    return FlatButton.icon(
      icon: Icon(
        Icons.person,
        color: Colors.white,
      ),
      label: Text(
        "Log out",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        dynamic result = _auth.signOut();
      },
    );
    //}else{
    //  return Text("");
    //}
  }

  Widget FloatingButton(BuildContext context) {
    if (globals.isAdmin) {
      return FloatingActionButton(
          hoverColor: Colors.green,
          child: Icon(Icons.add),
          backgroundColor: Colors.green,
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FormGarden()),
            );
          });
    } else {
      return Text("");
    }
  }
//END Teacher Funcs
}

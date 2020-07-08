import 'package:esgarden/Library/Globals.dart' as globals;
import 'package:esgarden/Models/Orchard.dart';
import 'package:esgarden/Screens/Create/createGarden.dart';
import 'package:esgarden/Services/Auth.dart';
import 'package:esgarden/UI/CardGarden.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Orchard> gardens = List();
  final AuthService _auth = AuthService();
  bool isTeacher = false;
  DatabaseReference gardensref;
  var _queryAdded;
  var _queryChanged;

  @override
  void initState() {
    super.initState();
    final FirebaseDatabase _database = FirebaseDatabase.instance;
    gardensref = _database.reference().child('Gardens');
    _queryAdded = gardensref
        .reference()
        .orderByChild("key")
        .onChildAdded
        .listen(_onChildAdded);
    _queryChanged =
        gardensref.reference().onChildChanged.listen(_onChildChanged);
    //gardensref.reference().onChildRemoved.listen(_onChildChanged);
  }

  @override
  void dispose() {
    _queryAdded.cancel();
    _queryChanged.cancel();
    super.dispose();
  }
  void _onChildAdded(Event event) {
    setState(() {
      gardens.add(Orchard.fromSnapshot(event.snapshot));
    });
  }

  void _onChildChanged(Event event) {
    print("CHANGED");
    var old = gardens.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      gardens[gardens.indexOf(old)] = Orchard.fromSnapshot(event.snapshot);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          actions: <Widget>[
            LogOutButton(),
          ],
          backgroundColor: Colors.green,
        ),
        floatingActionButton: FloatingButton(context),
        body: Column(
          children: <Widget>[
            Flexible(
              child: FirebaseAnimatedList(
                query: gardensref,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  return new CardGarden(gardens[index]);
                },
              ),
            ),
          ],
        ));;
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

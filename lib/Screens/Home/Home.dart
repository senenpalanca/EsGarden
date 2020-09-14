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
    //    gardensref.reference().onChildChanged.listen(_onChildChanged);
        gardensref.reference().onChildRemoved.listen(_onChildDeleted);
  }

  @override
  void dispose() {
    _queryAdded.cancel();
   // _queryChanged.cancel();
    super.dispose();
  }

  void _onChildAdded(Event event) {
    setState(() {
      gardens.add(Orchard.fromSnapshot(event.snapshot));
    });
  }

  void _onChildChanged(Event event) {
    var old = gardens.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    print("onChildChanged");
    print(gardens);
    print(gardens.indexOf(old));
    setState(() {

      gardens[gardens.indexOf(old)-1] = Orchard.fromSnapshot(event.snapshot);
    });
  }
  void _onChildDeleted(Event event) {
    print("onChildDeleted");
    var old = gardens.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    print(old);
    setState(() {
      try{
        gardens.removeAt(gardens.indexOf(old));
      }catch(E){

      }

    });

    print(gardens.map((e) =>  e.key));
  }

  @override
  Widget build(BuildContext context) {
    print(gardens.map((e) =>  e.key));
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

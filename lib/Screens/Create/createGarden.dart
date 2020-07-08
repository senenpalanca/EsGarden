import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../UI/PersonalizedField.dart';

class FormGarden extends StatefulWidget {
  @override
  FormGardenState createState() => FormGardenState();
}

class FormGardenState extends State<FormGarden> {
  final nameContoller = TextEditingController();
  final cityContoller = TextEditingController();
  final imgContoller = TextEditingController();
  File _image;

  Future _getImage() async {
    final image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  final _database = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: createGardenButton(context),
      appBar: AppBar(
        title: Text("Create new Garden"),
        backgroundColor: Colors.green,
      ),
      body: Form(child: formUI()),
    );
  }

  @override
  void dispose() {
    nameContoller.dispose();
    cityContoller.dispose();
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
              height: 480,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Image.asset(
                      'images/icon.png',
                      width: 300.0,
                    ),
                    PersonalizedField(nameContoller, "Name of the Garden",
                        false, Icon(Icons.note_add, color: Colors.white)),
                    PersonalizedField(cityContoller, "City of the Garden",
                        false, Icon(Icons.location_city, color: Colors.white)),
                    //PersonalizedField2(vegetableContoller,"Vegetables to plant",false,Icon(Icons.assignment, color: Colors.white)),
                    PersonalizedField(imgContoller, "Image URL Logo", false,
                        Icon(Icons.assignment, color: Colors.white)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget createGardenButton(BuildContext context) {
    return new FloatingActionButton.extended(
      onPressed: () {
        if (!_ValidateFields()) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Error with some Fields"),
                  content: Text("Some fields where empty or with errors"),
                );
              });
        } else {
          showDialog(
              context: context,
              builder: (context) {
                createRecord();
                return AlertDialog(
                  title: Text("Garden Created"),
                  content: Text("The garden " +
                      nameContoller.text +
                      " has been created!"),
                );
              });
        }
      },
      label: Text(
        'Create Garden',
        style: TextStyle(fontSize: 20.0),
      ),
      icon: Icon(Icons.thumb_up),
      backgroundColor: Colors.deepOrange,
    );
  }

  bool _ValidateFields() {
    String name = nameContoller.text;
    String city = cityContoller.text;
    //String vegetable= vegetableContoller.text;
    String image = imgContoller.text;
    if (name.length > 0 && city.length > 0 && image.length >= 0) {
      print("Fields validated");

      return true;
    } else {
      print("Fields not validated");
      return false;
    }
  }

  void createRecord() {
    String img = imgContoller.text;
    if (img.length == 0) {
      img = "https://i.ibb.co/rwgX7b3/garden2.jpg";
    }
    final databaseReference = _database.child("Gardens");
    databaseReference.child(nameContoller.text).set({
      'City': cityContoller.text,
      //'Vegetable': vegetableContoller.text,
      //'Alerts' : {"C1" : [ "No Notifications" ],"H1" : [ "No notifications"], "T1" : [ "No notifications"]},

      "Latitude": "41.643641",
      "Longitude": "-0.879529",

      "Img": img,
      "sensorData": {
        "General": {
          "Name": "General",
          "Data": {},
          "Valve": {
            "Max": [0],
            "Min": [0],
            "Active": [0],
            "Sensor": 255
          },
          "City": cityContoller.text,
          "Items": [
            "Temperature",
            "Air Quality",
            "Humidity",
            "Brightness"
          ],
          "Img": "https://i.ibb.co/nPFdzdv/general1.jpg",
          "Parent": nameContoller.text,
          "Vegetable": "General"
        },
        "Nursery": {
          "Name": "Nursery",
          "Data": {},
          "Valve": {
            "Max": [0],
            "Min": [0],
            "Active": [0],
            "Sensor": 255
          },
          "City": cityContoller.text,
          "Items": ["Temperature", "Air Quality", "Humidity"],
          "Img": "https://i.ibb.co/ZYFqJyM/PLANTA-web.jpg",
          "Parent": nameContoller.text,
          "Vegetable": "General"
        },
        "Compost": {
          "Name": "Compost",
          "Data": {},
          "Valve": {
            "Max": [0],
            "Min": [0],
            "Active": [0],
            "Sensor": 255
          },
          "City": cityContoller.text,
          "Items": ["Compost Temperature", "Compost Humidity", "Air Quality"],
          "Img":
          "https://cdn.pixabay.com/photo/2017/06/09/12/51/fresh-2386786_960_720.jpg",
          "Parent": nameContoller.text,
          "Vegetable": "General"
        }
      }
    });
  }


}

import 'package:firebase_database/firebase_database.dart';

class Vegetable {
  String key;
  String Description;
  String BigDescription;
  String Img;
  String imgBig;
  int tmpMax;
  int tmpMin;
  String name;
  String continent;

  Vegetable(this.key, this.name, this.Description, this.Img, this.tmpMax,
      this.tmpMin);

  Vegetable.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        name = snapshot.value["Name"],
        Description = snapshot.value["Descr"],
        BigDescription = snapshot.value["BigDescr"],
        Img = snapshot.value["img"],
        tmpMax = snapshot.value["temp_max"],
        tmpMin = snapshot.value["temp_min"],
        continent = snapshot.value["continent"],
        imgBig = snapshot.value["img1200x900"];

  toJson() {
    return {
      "key": key,
      "Descr": Description,
      "img": Img,
    };
  }
}

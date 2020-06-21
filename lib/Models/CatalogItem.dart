import 'package:firebase_database/firebase_database.dart';

class CatalogItem {
  String key;
  String Description;
  String Img;
  int tmpMax;
  int tmpMin;

  CatalogItem(this.key, this.Description, this.Img, this.tmpMax, this.tmpMin);

  CatalogItem.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        Description = snapshot.value["Descr"],
        Img = snapshot.value["img"],
        tmpMax = snapshot.value["temp_max"],
        tmpMin = snapshot.value["temp_min"];

  toJson() {
    return {
      "key": key,
      "Descr": Description,
      "img": Img,
    };
  }
}

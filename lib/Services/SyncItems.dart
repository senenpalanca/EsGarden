import 'package:esgarden/Models/Plot.dart';
import 'package:esgarden/Screens/Custom/FormVegetable.dart';
import 'package:esgarden/Screens/Custom/FormWind.dart';
import 'package:esgarden/Screens/Custom/formGeoloc.dart';
import 'package:esgarden/Screens/Graphs/Days/MainScreen.dart';
import 'package:esgarden/Screens/Graphs/Historic/HistoricScreen.dart';
import 'package:esgarden/UI/CardItem.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SyncItemsService {
  Plot PlotKey;
  BuildContext context;

  final _database = FirebaseDatabase.instance.reference();

  List<String> items = [];

  void Start(Plot PlotKey, BuildContext context) {
    void _onNewItem(Event event) {
      if (!items.contains(event.snapshot.value)) {
        items.add(event.snapshot.value);
      }
    }

    this.context = context;
    this.PlotKey = PlotKey;
    items.clear();
    final _database = FirebaseDatabase.instance.reference();
    final databaseReference = _database
        .child("Gardens")
        .child(PlotKey.parent)
        .child("sensorData")
        .child(PlotKey.key)
        .child("Items")
        .onChildAdded
        .listen(_onNewItem);
  }

  List<CardItem> GetItems() {
    return items.map(_convertToCard).toList();
  }

  List<String> GetStringItems() {
    return items;
  }

  void DeleteItem(int index) {
    items.removeAt(index);
    final _database = FirebaseDatabase.instance.reference();
    final databaseReference = _database
        .child("Gardens")
        .child(PlotKey.parent)
        .child("sensorData")
        .child(PlotKey.key)
        .child("Items")
        .set(items);
  }

  void AddItem(CardItem item, int index) {
    int indice = index;
    print("Items:" + items.toString() + " : " + index.toString());
    if (index > items.length - 1) {
      print("add");
      items.add(item.caption);
    } else {
      print("insert");
      items?.insert(indice, item.caption);
    }
    final _database = FirebaseDatabase.instance.reference();
    final databaseReference = _database
        .child("Gardens")
        .child(PlotKey.parent)
        .child("sensorData")
        .child(PlotKey.key)
        .child("Items")
        .set(items);
  }

  CardItem AddCardItem(String caption) {
    CardItem item = _convertToCard(caption);
    items.add(caption);
    final _database = FirebaseDatabase.instance.reference();
    final databaseReference = _database
        .child("Gardens")
        .child(PlotKey.parent)
        .child("sensorData")
        .child(PlotKey.key)
        .child("Items")
        .set(items);
    return item;
  }

  CardItem _convertToCard(String item) {
    _push(String type, Color color) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                formChart(PlotKey: PlotKey, color: color, type: type)),
      );
    }

    CardItem ret;
    switch (item) {
      case "Compost Humidity":
        return new CardItem(
          caption: item,
          color: Colors.cyan,
          icon: Icons.cloud_queue,
          pad: 10,
          tapFunction: () {
            _push("ambienthumidity", Colors.cyan);
          },
        );
        break;
      case "Compost Temperature":
        return new CardItem(
          caption: item,
          color: Colors.red,
          icon: Icons.ac_unit,
          pad: 10,
          tapFunction: () {
            _push("soiltemperature", Colors.red);
          },
        );
        break;
      case "Temperature":
        return new CardItem(
          caption: item,
          color: Colors.red,
          icon: Icons.access_time,
          pad: 10,
          tapFunction: () {
            _push("ambienttemperature", Colors.red);
          },
        );
        break;
      case "Humidity":
        return new CardItem(
          caption: item,
          color: Colors.blue,
          icon: Icons.arrow_back,
          pad: 10,
          tapFunction: () {
            _push("ambienthumidity", Colors.cyan);
          },
        );
        break;
      case "Soil Humidity":
        return new CardItem(
          caption: item,
          color: Colors.blue,
          icon: Icons.scatter_plot,
          pad: 10,
          tapFunction: () {
            _push("soilhumidity", Colors.blue);
          },
        );
        break;
      case "Soil Temperature":
        return new CardItem(
          caption: item,
          color: Colors.red,
          icon: Icons.ac_unit,
          pad: 10,
          tapFunction: () {
            _push("soiltemperature", Colors.red);
          },
        );
        break;
      case "Historic Data":
        return new CardItem(
          caption: item,
          color: Colors.red,
          icon: Icons.graphic_eq,
          pad: 10,
          tapFunction: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HistoricScreen(PlotKey: PlotKey)),
            );
          },
        );
        break;
      case "Vegetable":
        return new CardItem(
          caption: item,
          color: Colors.green,
          icon: Icons.list,
          pad: 10,
          tapFunction: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => formVegetable(PlotKey: PlotKey)),
            );
          },
        );
        break;
      case "PH":
        return new CardItem(
          caption: item,
          color: Colors.cyan,
          icon: Icons.scatter_plot,
          pad: 10,
          tapFunction: () {
            _push("ph", Colors.blue);
          },
        );
        break;
      case "ElectroValve":
        return new CardItem(
          caption: item,
          color: Colors.cyan,
          icon: Icons.vertical_align_center,
          pad: 10,
          tapFunction: () {
            _push("electrovalve", Colors.cyan);
          },
        );
        break;
      case "GeoLocalization":
        return new CardItem(
          caption: item,
          color: Colors.cyan,
          icon: Icons.vertical_align_center,
          pad: 10,
          tapFunction: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => formGeoloc(PlotKey: PlotKey)),
            );
          },
        );
        break;
      case "Air Quality":
        return new CardItem(
          caption: item,
          color: Colors.green,
          icon: Icons.all_inclusive,
          pad: 10,
          tapFunction: () {
            _push("co2", Colors.cyan);
          },
        );
        break;
      case "Brightness":
        return new CardItem(
          caption: item,
          color: Colors.yellow,
          icon: Icons.lightbulb_outline,
          pad: 10,
          tapFunction: () {
            _push("brightness", Colors.orange);
          },
        );
        break;
      case "Wind":
        return new CardItem(
          caption: item,
          color: Colors.yellow,
          icon: Icons.toys,
          pad: 10,
          tapFunction: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => formWind(PlotKey: PlotKey)),
            );
          },
        );
        break;
      default:
        return new CardItem(
          caption: item,
          color: Colors.green,
          icon: Icons.arrow_back,
          pad: 10,
          tapFunction: () {
            print("not implemented");
          },
        );
        break;
    }
  }
}

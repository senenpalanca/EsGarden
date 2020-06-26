import 'package:esgarden/Library/Globals.dart' as globals;
import 'package:esgarden/Models/Plot.dart';
import 'package:esgarden/Services/SyncItems.dart';
import 'package:esgarden/UI/CardItem.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

List<CardItem> listItems = [];

SyncItemsService Service = SyncItemsService();

class LoadItems extends StatelessWidget {
  Plot PlotKey;

  LoadItems({this.PlotKey});

  Future<String> getDataFromFuture() async {
    return new Future.delayed(Duration(milliseconds: 1000), () => "WaitFinish");
  }

  @override
  Widget build(BuildContext context) {
    Service.Start(PlotKey, context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Items"),
        leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            }),
        actions: <Widget>[
          PopupMenuButton<int>(
              enabled: globals.isAdmin,
              itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      enabled: false,
                      value: 1,
                      child: Text(
                        "Options ",
                        style: TextStyle(color: Colors.green, fontSize: 16.0),
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      enabled: globals.isAdmin,
                      child: FlatButton(
                        onPressed: () {
                          _showChangeNameDialog(context);
                        },
                        child: Text(
                          "Edit Name",
                          style:
                              TextStyle(color: Colors.black45, fontSize: 18.0),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      enabled: globals.isAdmin,
                      value: 2,
                      child: FlatButton(
                        onPressed: () {
                          _showDeleteDialog(context);
                        },
                        child: Text(
                          "Delete Plot",
                          style:
                              TextStyle(color: Colors.black45, fontSize: 18.0),
                        ),
                      ),
                    ),
                  ]),
        ],
      ),
      body: FutureBuilder(
          future: getDataFromFuture(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Items(
                PlotKey: PlotKey,
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Delete Plot " + PlotKey.Name),
          content: new Text("Are you sure you want to delete this plot?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                final _database = FirebaseDatabase.instance.reference();
                final databaseReference = _database
                    .child("Gardens")
                    .child(PlotKey.parent)
                    .child("sensorData")
                    .child(PlotKey.key)
                    .remove();
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                //Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showChangeNameDialog(BuildContext context) {
    String plotName = '';
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('Enter current team'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: 'Plot Name',
                        hintText: 'eg. Tomatoes from UPV'),
                    onChanged: (value) {
                      plotName = value;
                    },
                  ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                if (plotName.length > 0) {
                  final _database = FirebaseDatabase.instance.reference();
                  final databaseReference = _database
                      .child("Gardens")
                      .child(PlotKey.parent)
                      .child("sensorData")
                      .child(PlotKey.key)
                      .child("Name")
                      .set(plotName);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

}

class Items extends StatefulWidget {
  Plot PlotKey;

  Items({this.PlotKey});

  SyncItemsService _syncItemsService = Service;

  @override
  _ItemsState createState() {
    listItems = _syncItemsService.GetItems();
    return _ItemsState();
  }
}

class _ItemsState extends State<Items> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      floatingActionButton: FloatingActionButton(
        onPressed: OpenItemsList,
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      body: Container(
          child: ListView.builder(
        itemCount: listItems.length,
        itemBuilder: (context, index) {
          return Dismissible(
            background: stackBehindDismiss(),
            key: ObjectKey(listItems[index]),
            child: listItems[index],
            onDismissed: (direction) {
              var item = listItems.elementAt(index);
              //To delete
              deleteItem(index);
              //To show a snackbar with the UNDO button
              Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Item deleted"),
                  action: SnackBarAction(
                      label: "UNDO",
                      onPressed: () {
                        //To undo deletion
                        undoDeletion(index, item);
                      })));
            },
          );
        },
      )),
    );
  }

  void deleteItem(index) {
    setState(() {
      widget._syncItemsService.DeleteItem(index);
      listItems.removeAt(index);
    });
  }

  void undoDeletion(index, CardItem item) {
    int indice = index;
    if (index > listItems.length) {
      indice = listItems.length;
    }
    setState(() {
      widget._syncItemsService.AddItem(item, indice);
      listItems.insert(indice, item);
    });
  }

  Widget stackBehindDismiss() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0),
      color: Colors.red,
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  void OpenItemsList() {
    List<Widget> invisibleItems = _getUnselectedElements();
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            child: Container(
              height: 15 + (65 * invisibleItems.length).toDouble(),
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(10),
                      topRight: const Radius.circular(10))),
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(10),
                          topRight: const Radius.circular(10))),
                  child: Column(
                    children: invisibleItems,
                  ),
                ),
              ),
            ),
          );
        });
  }

  List<Widget> _getUnselectedElements() {
    List<String> visibleItems = widget._syncItemsService.GetStringItems();
    print(widget.PlotKey.key);
    List<String> allItems = globals.ITEMS_PLOTS[widget.PlotKey.key] != Null
        ? globals.ITEMS_PLOTS[widget.PlotKey.key].toList()
        : [];
    List<String> invisibleItems = [];
    for (var i = 0; i < allItems.length; i++) {
      if (!visibleItems.contains(allItems[i])) {
        invisibleItems.add(allItems[i]);
      }
    }
    print(visibleItems);
    print(allItems);
    return invisibleItems.map(_createListTileItem).toList();
  }

  Widget _createListTileItem(
    String Caption,
  ) {
    return ListTile(
      leading: Icon(Icons.add),
      title: Text(Caption),
      onTap: () {
        Navigator.pop(context);
        AddItem(Caption);
      },
    );
  }

  void AddItem(String caption) {
    setState(() {
      CardItem item = widget._syncItemsService.AddCardItem(caption);
      listItems.insert(listItems.length, item);
    });
  }
}

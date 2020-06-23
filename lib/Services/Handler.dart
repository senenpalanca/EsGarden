import 'package:esgarden/Models/Orchard.dart';
import 'package:esgarden/Models/Plot.dart';
import 'package:firebase_database/firebase_database.dart';

class Handler {
  final _database = FirebaseDatabase.instance.reference();
  List<Orchard> gardens = [];
  List<Plot> plots;

  void Start() {
    final _database = FirebaseDatabase.instance.reference();

    DatabaseReference gardensref = _database.reference().child('Gardens');
    gardensref.reference().onChildAdded.listen(_onChildAdded);
  }

  void Listen() {
    final _database = FirebaseDatabase.instance.reference();

    final databaseReferenceChanged =
        _database.child("Gardens").onChildChanged.listen(_onChildChanged);
  }

  void _onChildAdded(Event event) {
    print("new garden added");
    Orchard n = Orchard.fromSnapshot(event.snapshot);
    gardens.add(n);
  }

  void _onChildChanged(Event event) {
    Orchard n = Orchard.fromSnapshot(event.snapshot);
    if (!gardens.contains(n)) {
      print("Modif.");
      gardens.add(n);
    }
  }
}

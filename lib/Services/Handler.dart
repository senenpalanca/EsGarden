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

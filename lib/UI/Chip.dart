import 'package:flutter/material.dart';

import 'file:///X:/Proyectos/flutte/ESGarden/esgarden/lib/Models/Alerts.dart';

class OptionChips extends StatefulWidget {
  final List<String> typeSeries;
  final Function(String) onSelectionChanged;

  OptionChips({this.typeSeries, this.onSelectionChanged});

  @override
  _OptionChipsState createState() => _OptionChipsState();
}

class _OptionChipsState extends State<OptionChips> {
  String selectedChoice = typeSeries[0];

  // this function will build and return the choice list
  _buildChoiceList() {
    List<Widget> choices = List();
    widget.typeSeries.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedChoice == item,
          onSelected: (selected) {
            setState(() {
              selectedChoice = item;
              widget.onSelectionChanged(selectedChoice);
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 2.0,
      children: _buildChoiceList(),
    );
  }
}

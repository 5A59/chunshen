import 'package:flutter/material.dart';

class OperationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.blue,
        child: Row(
          children: [
            Icon(Icons.ac_unit),
            Icon(Icons.access_alarm),
            Icon(Icons.backpack),
          ],
        ));
  }
}

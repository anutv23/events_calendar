import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClientType extends StatefulWidget {
  @override
  _ClientTypeState createState() => _ClientTypeState();
}

class _ClientTypeState extends State<ClientType> {
  // Default Drop Down Item.
  String dropdownValue = 'Surgeon';

  // To show Selected Item in Text.
  String holder = '';
  String data = '';
  List<String> timeSlots = [
    'Surgeon',
    'Hospital',
  ];

  void getDropDownItem() {
    setState(() {
      holder = dropdownValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            TextButton(
              child: Text(
                'Client Type:',
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
              onPressed: getDropDownItem,
            ),
            SizedBox(
              width: 10,
            ),
            DropdownButton<String>(
              value: dropdownValue,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 20,
              elevation: 16,
              style: TextStyle(color: Colors.blue, fontSize: 12),
              // underline: Container(
              //   height: 2,
              //   color: Colors.black,
              // ),
              onChanged: (data) {
                setState(() {
                  dropdownValue = data!;
                });
              },
              items: timeSlots.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
        // Text('Selected Item = ' + '$dropdownValue',
        //     style: TextStyle(fontSize: 12, color: Colors.black)),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MeetingType extends StatefulWidget {
  @override
  _MeetingTypeState createState() => _MeetingTypeState();
}

class _MeetingTypeState extends State<MeetingType> {
  // Default Drop Down Item.
  String dropdownValue = 'Intro';

  // To show Selected Item in Text.
  String holder = '';
  String data = '';
  List<String> timeSlots = [
    'Intro',
    'Ortho',
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
                'Meeting Type:',
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
        )

        // Padding(
        //     padding: EdgeInsets.only(top: 30, bottom: 30),
        //     child :
        //     //Printing Item on Text Widget
        //     Text('Selected Item = ' + '$holder',
        //         style: TextStyle
        //           (fontSize: 22,
        //             color: Colors.black))),
      ],
    );
  }
}

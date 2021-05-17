import 'package:events_calendar/model/event.dart';
import 'package:events_calendar/provider/event_provider.dart';
import 'package:events_calendar/utils.dart';
import 'package:events_calendar/widget/client_dropdown.dart';
import 'package:events_calendar/widget/meetingtype_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventEditingPage extends StatefulWidget {
  final Event? event;

  const EventEditingPage({
    Key? key,
    this.event,
  }) : super(key: key);

  @override
  _EventEditingPageState createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {
  final _formKey = GlobalKey<FormState>();
  late DateTime fromDate;
  late DateTime toDate;
  final titleController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(hours: 2));
    } else {
      final event = widget.event!;

      titleController.text = event.title;

      fromDate = event.from;
      toDate = event.to;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        actions: buildEditingActions(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: buildClientType(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: buildMeetingType(),
                  ),
                ],
              ),
              SizedBox(
                height: 18,
              ),
              buildTitle(),
              SizedBox(
                height: 12,
              ),
              buildDateTimePickers(),
              SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      height: 40,
                      width: 130,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.amber),
                      child: TextButton(
                          onPressed: surgeonAdd, child: Text("Add Surgeon"))),
                  Container(
                      height: 40,
                      width: 130,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.amber),
                      child: TextButton(
                          onPressed: () {}, child: Text("Add Hospital"))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildEditingActions() => [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              primary: Colors.transparent, shadowColor: Colors.black),
          onPressed: saveForm,
          icon: Icon(Icons.done),
          label: Text('SAVE'),
        ),
      ];

  Widget buildTitle() => TextFormField(
        style: TextStyle(fontSize: 15),
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          hintText: 'Enter Client Name ',
        ),
        onFieldSubmitted: (_) => saveForm(),
        validator: (title) =>
            title != null && title.isEmpty ? 'Field cannot be empty' : null,
        controller: titleController,
      );

  Widget buildDateTimePickers() => Column(
        children: [
          buildFrom(),
          buildTo(),
        ],
      );

  Widget buildFrom() => buildHeader(
        header: 'Start:',
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: buildDropDownField(
                  text: Utils.toDate(fromDate),
                  onClicked: () => pickFromDateTime(pickDate: true),
                )),
            Expanded(
                child: buildDropDownField(
              text: Utils.toTime(fromDate),
              onClicked: () => pickFromDateTime(pickDate: false),
            ))
          ],
        ),
      );

  Widget buildTo() => buildHeader(
        header: 'End:',
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: buildDropDownField(
                  text: Utils.toDate(toDate),
                  onClicked: () => pickToDateTime(pickDate: true),
                )),
            Expanded(
                child: buildDropDownField(
              text: Utils.toTime(toDate),
              onClicked: () => pickToDateTime(pickDate: false),
            ))
          ],
        ),
      );

  Widget buildDropDownField({
    required String text,
    required VoidCallback onClicked,
  }) =>
      ListTile(
        title: Text(text),
        trailing: Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );

  buildHeader({required String header, required Widget child}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          child,
        ],
      );
  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      final event = Event(
        title: titleController.text,
        description: 'Meeting Type',
        from: fromDate,
        to: toDate,
        // isAllDay: false
      );

      final isEditing = widget.event != null;

      final provider = Provider.of<EventProvider>(context, listen: false);

      if (isEditing) {
        provider.editEvent(event, widget.event!);
        Navigator.of(context).pop();
      } else {
        provider.addEvent(event);
      }
      Navigator.of(context).pop();
    }
  }

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);
    if (date == null) return;
    if (date.isAfter(toDate)) {
      toDate =
          DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }

    setState(() => fromDate = date);
  }

  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(toDate,
        pickDate: pickDate, firstDate: pickDate ? fromDate : null);
    if (date == null) return;

    setState(() => toDate = date);
  }

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool pickDate,
    DateTime? firstDate,
  }) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2019, 8),
        lastDate: DateTime(2101),
      );
      if (date == null) return null;
      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);
      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );
      if (timeOfDay == null) return null;
      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
      return date.add(time);
    }
  }

  Widget buildClientType() => Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      shadowColor: Colors.grey,
      elevation: 10.0,
      //  margin: EdgeInsets.fromLTRB(5.0, 10.0, 150.0, 0.0),
      child: ClientType());

  Widget buildMeetingType() => Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      shadowColor: Colors.grey,
      elevation: 10.0,
      //    margin: EdgeInsets.fromLTRB(5.0, 10.0, 150.0, 0.0),
      child: MeetingType());

  Future surgeonAdd() async {
    int _value = 1;
    showDialog(
        context: context,
        builder: (context) => Dialog(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "Add Surgeon",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("Name",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                                Text(
                                  "*",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                            TextFormField(
                              //controller: ,
                              decoration: InputDecoration(
                                labelText: "Enter Name",
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("Territory",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                                Text(
                                  "*",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: DropdownButton(
                                        value: _value,
                                        items: [
                                          DropdownMenuItem(
                                            child: Text("--Select --"),
                                            value: 1,
                                          ),
                                          DropdownMenuItem(
                                            child: Text("Mumbai"),
                                            value: 2,
                                          ),
                                          DropdownMenuItem(
                                            child: Text("Patna"),
                                            value: 3,
                                          ),
                                          DropdownMenuItem(
                                              child: Text("Bangalore"),
                                              value: 4),
                                          DropdownMenuItem(
                                              child: Text("Jamshedpur"),
                                              value: 5)
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            // _value = value;
                                          });
                                        }),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15, left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text("State",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                      Text(
                                        "*",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(left: 10),
                                          child: DropdownButton(
                                              value: _value,
                                              items: [
                                                DropdownMenuItem(
                                                  child: Text("--Select --"),
                                                  value: 1,
                                                ),
                                                DropdownMenuItem(
                                                  child: Text("Maharashtra"),
                                                  value: 2,
                                                ),
                                                DropdownMenuItem(
                                                  child: Text("Bihar"),
                                                  value: 3,
                                                ),
                                                DropdownMenuItem(
                                                    child: Text("Krnataka"),
                                                    value: 4),
                                                DropdownMenuItem(
                                                    child: Text("Jharkhand"),
                                                    value: 5)
                                              ],
                                              onChanged: (value) {
                                                setState(() {
                                                  // _value = value;
                                                });
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15, left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text("Industry Type/Surgeon Type",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                      Text(
                                        "*",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(left: 10),
                                          child: DropdownButton(
                                              value: _value,
                                              items: [
                                                DropdownMenuItem(
                                                  child: Text("--Select --"),
                                                  value: 1,
                                                ),
                                                DropdownMenuItem(
                                                  child: Text("Neuro"),
                                                  value: 2,
                                                ),
                                                DropdownMenuItem(
                                                    child: Text(
                                                        "Oral & Maxillofacial"),
                                                    value: 3),
                                                DropdownMenuItem(
                                                    child: Text("plastic"),
                                                    value: 4),
                                                DropdownMenuItem(
                                                    child: Text("orthopedic"),
                                                    value: 5),
                                                DropdownMenuItem(
                                                    child: Text("other"),
                                                    value: 6)
                                              ],
                                              onChanged: (value) {
                                                setState(() {
                                                  // _value = value;
                                                });
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20, left: 70),
                              child: Center(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Row(
                                    //   mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                            height: 25,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                color: Colors.grey),
                                            child:
                                                Center(child: Text("Cancel"))),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: Container(
                                            height: 25,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                color: Colors.amber),
                                            child: Center(child: Text("Save"))),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]))));
  }
}

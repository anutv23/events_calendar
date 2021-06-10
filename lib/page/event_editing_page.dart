import 'package:events_calendar/model/event.dart';
import 'package:events_calendar/provider/event_provider.dart';
import 'package:events_calendar/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

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

  int _user = 1;
  var users = <String>[
    'Surgeon',
    'Hospital',
  ];

  int _userTerritory = 1;
  var usersTerritory = <String>[
    'Mumbai',
    'Patna',
    'Bengaluru',
  ];

  int _userState = 1;
  var usersState = <String>[
    'Maharashtra',
    'Karnataka',
    'Kerala',
  ];

  int _userIndSurg = 1;
  var usersIndSurg = <String>[
    'Neuro',
    'Ortho',
    'Plastic',
    'Other',
  ];

  int _userMeetingType = 1;
  var usersMeetingType = <String>[
    'Intro',
    'Ortho',
  ];

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
        title: "Meeting Schedular".text.makeCentered(),
        actions: buildEditingActions(),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                VxBox(child: "Book Appointment:".text.bold.makeCentered())
                    .gray200
                    .height(40)
                    .width(context.screenWidth - 50)
                    .make()
                    .card
                    .elevation(4)
                    .shadowColor(Colors.grey)
                    .make()
                    .px12()
                    .py12(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 2,
                      child: buildClientType(),
                    ),
                    Expanded(
                      flex: 2,
                      child: buildMeetingType(),
                    ),
                  ],
                ),
                18.heightBox,
                buildTitle(),
                12.heightBox,
                buildDateTimePickers().px24(),
                12.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    VxBox(
                            child: TextButton(
                                onPressed: surgeonAdd,
                                child: "Add Surgeon"
                                    .text
                                    .color(Colors.black)
                                    .make()))
                        .height(40)
                        .width(130)
                        .color(Colors.orangeAccent)
                        .make()
                        .card
                        .elevation(4)
                        .shadowColor(Colors.grey)
                        .make(),
                    VxBox(
                            child: TextButton(
                                onPressed: hospitalAdd,
                                child: "Add Hospital"
                                    .text
                                    .color(Colors.black)
                                    .make()))
                        .height(40)
                        .width(130)
                        .color(Colors.orangeAccent)
                        .make()
                        .card
                        .elevation(4)
                        .shadowColor(Colors.grey)
                        .make(),
                  ],
                )
              ],
            ).p24().scrollVertical(),
          ).p8(),
        ),
      ),
    );
  }

  List<Widget> buildEditingActions() => [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            // shadowColor: Colors.orange
          ),
          onPressed: saveForm,
          icon: Icon(Icons.done),
          label: 'SAVE'.text.make(),
        ),
      ];

  Widget buildTitle() => VxBox(
          child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        child: TextFormField(
          style: TextStyle(fontSize: 15),
          decoration: InputDecoration(

              //  border: UnderlineInputBorder(),
              hintText: 'Enter Client Name ',
              hintStyle: TextStyle(color: Colors.grey)),
          onFieldSubmitted: (_) => saveForm(),
          validator: (title) =>
              title != null && title.isEmpty ? 'Field cannot be empty' : null,
          controller: titleController,
        ),
      )).white.shadowMd.makeCentered().h(50).px12();

  Widget buildDateTimePickers() => Column(
        children: [
          buildFrom().py12(),
          12.heightBox,
          buildTo(),
        ],
      );

  Widget buildFrom() => buildHeader(
        header: 'Start:',
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
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
        //  contentPadding: EdgeInsets.only(left: 25,top: 5),
        title: text.text.color(Colors.grey).sm.center.make(),
        trailing: Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );

  buildHeader({required String header, required Widget child}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VxBox(child: header.text.semiBold.size(12).makeCentered())
              .height(20)
              .width(50)
              .make()
              .card
              .elevation(4)
              .shadowColor(Colors.grey)
              .make()
              .px12()
              .py2(),
          child,
        ],
      );
  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      final event = Event(
          title: titleController.text,
          description: users[_user],
          meetingType: usersMeetingType[_userMeetingType],
          from: fromDate,
          to: toDate,
          backgroundColor: Colors.lightGreen
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

  Widget buildClientType() => VxBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                "Client Type:".text.semiBold.size(12).makeCentered(),
                "*".text.semiBold.color(Colors.red).make().py2(),
                15.widthBox,
                DropdownButton<String>(
                  hint: new Text('Select Client:'),
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 20,
                  elevation: 16,
                  style: TextStyle(color: Colors.blue, fontSize: 12),
                  underline:
                      VxBox().height(2).color(Colors.orangeAccent).make(),
                  value: _user == null ? null : users[_user],
                  items: users.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: value.text.color(Colors.grey).sm.center.make(),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _user = users.indexOf(value!);
                    });
                  },
                )
              ],
            ),
          ],
        ),
      )
          .height(50)
          .make()
          .card
          .elevation(4)
          .shadowColor(Colors.grey)
          .make()
          .px12()
          .py2();

  Widget buildMeetingType() => VxBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                "Meeting Type:".text.semiBold.size(12).makeCentered(),
                "*".text.semiBold.color(Colors.red).make().py2(),
                15.widthBox,
                DropdownButton<String>(
                  hint: new Text('Select one:'),
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 20,
                  elevation: 16,
                  style: TextStyle(color: Colors.blue, fontSize: 12),
                  underline:
                      VxBox().height(2).color(Colors.orangeAccent).make(),
                  value: _userMeetingType == null
                      ? null
                      : usersMeetingType[_userMeetingType],
                  items: usersMeetingType.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: value.text.color(Colors.grey).sm.center.make(),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _userMeetingType = usersMeetingType.indexOf(value!);
                    });
                  },
                )
              ],
            ),
          ],
        ),
      )
          .height(50)
          .make()
          .card
          .elevation(4)
          .shadowColor(Colors.grey)
          .make()
          .px12()
          .py2();

  surgeonAdd() {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VxBox(child: "Add Surgeon".text.bold.makeCentered())
                      .gray200
                      .height(40)
                      .width(context.screenWidth)
                      .make()
                      .p8(),
                  Column(
                    children: [
                      Row(
                        children: [
                          "Name:".text.semiBold.size(12).makeCentered().px8(),
                          "*".text.semiBold.color(Colors.red).make().py2(),
                        ],
                      ),
                      VxBox(child: TextFormField())
                          .make()
                          .card
                          .elevation(4)
                          .shadowColor(Colors.grey)
                          .make()
                          .h(40)
                          .p8()
                    ],
                  ),
                  Row(
                    children: [
                      VxBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            "Territory:"
                                .text
                                .semiBold
                                .size(12)
                                .makeCentered()
                                .px4(),
                            "*"
                                .text
                                .semiBold
                                .color(Colors.red)
                                .make()
                                .py2()
                                .px4(),
                            15.widthBox,
                            DropdownButton<String>(
                              hint: new Text('Select one:'),
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 20,
                              elevation: 16,
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 12),
                              underline: VxBox()
                                  .height(2)
                                  .color(Colors.orangeAccent)
                                  .make(),
                              value: _userTerritory == null
                                  ? null
                                  : usersTerritory[_userTerritory],
                              items: usersTerritory.map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: value.text
                                      .color(Colors.grey)
                                      .sm
                                      .center
                                      .make(),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _userTerritory =
                                      usersTerritory.indexOf(value!);
                                });
                              },
                            ),
                          ],
                        ),
                      )
                          .height(50)
                          .width(170)
                          .make()
                          .card
                          .elevation(4)
                          .shadowColor(Colors.grey)
                          .make()
                          .px8()
                          .py8(),
                      VxBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            "State:".text.semiBold.size(12).makeCentered(),
                            "*".text.semiBold.color(Colors.red).make().py2(),
                            15.widthBox,
                            DropdownButton<String>(
                              hint: new Text('Select one:'),
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 20,
                              elevation: 16,
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 12),
                              underline: VxBox()
                                  .height(2)
                                  .color(Colors.orangeAccent)
                                  .make(),
                              value: _userState == null
                                  ? null
                                  : usersState[_userState],
                              items: usersState.map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: value.text
                                      .color(Colors.grey)
                                      .sm
                                      .center
                                      .make(),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _userState = usersState.indexOf(value!);
                                });
                              },
                            )
                          ],
                        ).p8(),
                      )
                          .height(50)
                          .width(170)
                          .make()
                          .card
                          .elevation(4)
                          .shadowColor(Colors.grey)
                          .make()
                          .px8()
                          .py8(),
                    ],
                  ),
                  VxBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        "Industry Type / Surgeon Type:"
                            .text
                            .semiBold
                            .size(12)
                            .makeCentered(),
                        "*".text.semiBold.color(Colors.red).make().px2().py2(),
                        15.widthBox,
                        DropdownButton<String>(
                          hint: new Text('Select one:'),
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 20,
                          elevation: 16,
                          style: TextStyle(color: Colors.blue, fontSize: 12),
                          underline: VxBox()
                              .height(2)
                              .color(Colors.orangeAccent)
                              .make(),
                          value: _userIndSurg == null
                              ? null
                              : usersIndSurg[_userIndSurg],
                          items: usersIndSurg.map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: value.text
                                  .color(Colors.grey)
                                  .sm
                                  .center
                                  .make(),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _userIndSurg = usersIndSurg.indexOf(value!);
                            });
                          },
                        ).px4().expand(),
                      ],
                    ).p8(),
                  )
                      .height(50)
                      .width(context.screenWidth)
                      .make()
                      .card
                      .elevation(4)
                      .shadowColor(Colors.grey)
                      .make()
                      .px8()
                      .py8(),
                  20.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      VxBox(
                              child: TextButton(
                                  onPressed: () {},
                                  child:
                                      "Save".text.color(Colors.black).make()))
                          .height(40)
                          .width(100)
                          .color(Colors.orangeAccent)
                          .make()
                          .card
                          .elevation(4)
                          .shadowColor(Colors.grey)
                          .makeCentered(),
                      VxBox(
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child:
                                      "Cancel".text.color(Colors.black).make()))
                          .height(40)
                          .width(100)
                          .color(Colors.orangeAccent)
                          .make()
                          .card
                          .elevation(4)
                          .shadowColor(Colors.grey)
                          .makeCentered(),
                    ],
                  ),
                ],
              ).scrollVertical().p12(),
            ));
  }

  hospitalAdd() {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VxBox(child: "Add Hospital".text.bold.makeCentered())
                      .gray200
                      .height(40)
                      .width(context.screenWidth)
                      .make()
                      .p8(),
                  Column(
                    children: [
                      Row(
                        children: [
                          "Name:".text.semiBold.size(12).makeCentered().px8(),
                          "*".text.semiBold.color(Colors.red).make().py2(),
                        ],
                      ),
                      VxBox(child: TextFormField())
                          .make()
                          .card
                          .elevation(4)
                          .shadowColor(Colors.grey)
                          .make()
                          .h(40)
                          .p8()
                    ],
                  ),
                  Row(
                    children: [
                      VxBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            "Territory:"
                                .text
                                .semiBold
                                .size(12)
                                .makeCentered()
                                .px4(),
                            "*"
                                .text
                                .semiBold
                                .color(Colors.red)
                                .make()
                                .py2()
                                .px4(),
                            15.widthBox,
                            DropdownButton<String>(
                              hint: new Text('Select one:'),
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 20,
                              elevation: 16,
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 12),
                              underline: VxBox()
                                  .height(2)
                                  .color(Colors.orangeAccent)
                                  .make(),
                              value: _userTerritory == null
                                  ? null
                                  : usersTerritory[_userTerritory],
                              items: usersTerritory.map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: value.text
                                      .color(Colors.grey)
                                      .sm
                                      .center
                                      .make(),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _userTerritory =
                                      usersTerritory.indexOf(value!);
                                });
                              },
                            ),
                          ],
                        ),
                      )
                          .height(50)
                          .width(170)
                          .make()
                          .card
                          .elevation(4)
                          .shadowColor(Colors.grey)
                          .make()
                          .px8()
                          .py8(),
                      VxBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            "State:".text.semiBold.size(12).makeCentered(),
                            "*".text.semiBold.color(Colors.red).make().py2(),
                            15.widthBox,
                            DropdownButton<String>(
                              hint: new Text('Select one:'),
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 20,
                              elevation: 16,
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 12),
                              underline: VxBox()
                                  .height(2)
                                  .color(Colors.orangeAccent)
                                  .make(),
                              value: _userState == null
                                  ? null
                                  : usersState[_userState],
                              items: usersState.map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: value.text
                                      .color(Colors.grey)
                                      .sm
                                      .center
                                      .make(),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _userState = usersState.indexOf(value!);
                                });
                              },
                            )
                          ],
                        ).p8(),
                      )
                          .height(50)
                          .width(170)
                          .make()
                          .card
                          .elevation(4)
                          .shadowColor(Colors.grey)
                          .make()
                          .px8()
                          .py8(),
                    ],
                  ),
                  VxBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        "Industry Type / Hospital Type:"
                            .text
                            .semiBold
                            .size(12)
                            .makeCentered(),
                        "*".text.semiBold.color(Colors.red).make().py2(),
                        15.widthBox,
                        DropdownButton<String>(
                          hint: new Text('Select one:'),
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 20,
                          elevation: 16,
                          style: TextStyle(color: Colors.blue, fontSize: 12),
                          underline: VxBox()
                              .height(2)
                              .color(Colors.orangeAccent)
                              .make(),
                          value: _userIndSurg == null
                              ? null
                              : usersIndSurg[_userIndSurg],
                          items: usersIndSurg.map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: value.text
                                  .color(Colors.grey)
                                  .sm
                                  .center
                                  .make(),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _userIndSurg = usersIndSurg.indexOf(value!);
                            });
                          },
                        ).expand(),
                      ],
                    ).p8(),
                  )
                      .height(50)
                      .width(context.screenWidth)
                      .make()
                      .card
                      .elevation(4)
                      .shadowColor(Colors.grey)
                      .make()
                      .px8()
                      .py8(),
                  20.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      VxBox(
                              child: TextButton(
                                  onPressed: () {},
                                  child:
                                      "Save".text.color(Colors.black).make()))
                          .height(40)
                          .width(100)
                          .color(Colors.orangeAccent)
                          .make()
                          .card
                          .elevation(4)
                          .shadowColor(Colors.grey)
                          .makeCentered(),
                      VxBox(
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child:
                                      "Cancel".text.color(Colors.black).make()))
                          .height(40)
                          .width(100)
                          .color(Colors.orangeAccent)
                          .make()
                          .card
                          .elevation(4)
                          .shadowColor(Colors.grey)
                          .makeCentered(),
                    ],
                  ),
                ],
              ).scrollVertical().p12(),
            ));
  }
}

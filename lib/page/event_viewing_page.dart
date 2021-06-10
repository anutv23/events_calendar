import 'package:events_calendar/model/event.dart';
import 'package:events_calendar/page/event_editing_page.dart';
import 'package:events_calendar/provider/event_provider.dart';
import 'package:events_calendar/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:provider/provider.dart';
//import 'followUpDetails.dart';

class EventViewingPage extends StatelessWidget {
  final Event event;

  const EventViewingPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
      ),
      body: SafeArea(
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VxBox(child: "Meeting Details".text.bold.makeCentered())
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
              20.heightBox,
              VxBox(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  "Client Name:".text.makeCentered(),
                  10.widthBox,
                  ' ${event.title}'.text.lg.bold.makeCentered()
                ],
              )).height(30).width(context.screenWidth).px12.py4.makeCentered(),
              10.heightBox,
              VxBox(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  "Client Type:".text.make(),
                  10.widthBox,
                  ' ${event.description}'.text.lg.bold.makeCentered(),
                ],
              )).height(30).width(context.screenWidth).px12.py4.makeCentered(),
              10.heightBox,
              VxBox(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  "Meeting Type:".text.make(),
                  10.widthBox,
                  ' ${event.meetingType}'.text.lg.bold.makeCentered(),
                ],
              )).height(30).width(context.screenWidth).px12.py4.makeCentered(),
              10.heightBox,
              VxBox(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  "Scheduled Date/Time:".text.make(),
                  10.widthBox,
                  '${event.from.day}/${event.from.month}/${event.from.year} at ${event.from.hour}:${event.from.minute} to ${event.to.hour}:${event.to.minute}'.
                      text
                      .lg
                      .bold
                      .makeCentered(),
                ],
              )).height(30).width(context.screenWidth).px12.py4.makeCentered(),
              20.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  VxBox(
                          child: TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                          child: Container(
                                            color: Colors.red,
                                            height: 100,
                                            width: 100,
                                          ),
                                        ));
                              },
                              child: "Follow Up".text.color(Colors.black).make()))
                      .height(40)
                      .width(100)
                      .color(Colors.orangeAccent)
                      .make()
                      .card
                      .elevation(4)
                      .shadowColor(Colors.grey)
                      .make()
                      .p8(),
                  VxBox(
                          child: TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                        builder: (context) => EventEditingPage(
                                              event: event,
                                            )));
                              },
                              child: "Edit".text.color(Colors.black).make()))
                      .height(40)
                      .width(100)
                      .color(Colors.orangeAccent)
                      .make()
                      .card
                      .elevation(4)
                      .shadowColor(Colors.grey)
                      .make()
                      .p8(),
                  VxBox(
                          child: Consumer<EventProvider>(
                    builder: (_, model, child) => TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                    child: Container(
                                      height: 200,
                                      width: 300,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          VxBox(
                                              child:
                                              Column(
                                                children: [
                                                  "Reason for Cancel:".text.semiBold.make().pOnly(top: 10),
                                                  VxBox(
                                                      child: TextFormField(
                                                        keyboardType: TextInputType.multiline,
                                                        maxLines: null,


                                                      )
                                                  ).white.shadowMd.makeCentered().h(80).p12(),
                                                ],
                                              )
                                          ).make(),
                                          // TextFormField(
                                          //   maxLines: 2,
                                          //   decoration: InputDecoration(
                                          //     // focusColor: Colors.black,
                                          //     labelText: 'Reason for Cancel',
                                          //     // hintText: 'Enter the title',
                                          //   ),
                                          // ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10.0),
                                            child: Container(
                                              height: 30,
                                              width: 70,
                                              decoration: BoxDecoration(
                                                  color: Colors.orangeAccent,
                                                  borderRadius:
                                                      BorderRadius.circular(19)),
                                              child: TextButton(
                                                onPressed: () {
                                                  model.deleteEvent(event);

                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "Submit",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ));

                        },
                        child: "Cancel".text.color(Colors.black).make()),
                  ))
                      .height(40)
                      .width(100)
                      .color(Colors.orangeAccent)
                      .make()
                      .card
                      .elevation(4)
                      .shadowColor(Colors.grey)
                      .make()
                      .p8(),
                ],
              ),
            ],
          ).scrollVertical(),
        ).p2(),
      ),
    );
  }
}

import 'package:events_calendar/model/event.dart';
import 'package:events_calendar/page/event_editing_page.dart';
import 'package:events_calendar/provider/event_provider.dart';
import 'package:events_calendar/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventViewingPage extends StatelessWidget {
  final Event event;

  const EventViewingPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: CloseButton(),
          actions: //buildViewingActions(context, event),
              [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => EventEditingPage(
                          event: event,
                        )),
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  primary: Colors.transparent, shadowColor: Colors.black),
              onPressed: () {
                final provider =
                    Provider.of<EventProvider>(context, listen: false);

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
                              children: [
                                TextFormField(
                                  maxLines: 2,
                                  decoration: InputDecoration(
                                    // focusColor: Colors.black,
                                    labelText: 'Reason for Cancel',
                                    // hintText: 'Enter the title',
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Container(
                                    height: 30,
                                    width: 70,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(19)),
                                    child: TextButton(
                                      onPressed: () {
                                        provider.deleteEvent(event);

                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Submit",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ));

                provider.deleteEvent(event);

                Navigator.pop(context);
              },
              icon: Icon(Icons.delete),
              label: Text('CANCEL'),
            ),
            // IconButton(
            //   icon: Icon(Icons.delete),

            //   onPressed: () {
            //     final provider =
            //         Provider.of<EventProvider>(context, listen: false);

            //     provider.deleteEvent(event);

            //     Navigator.pop(context);
            //   },

            // ),
          ]),
      body: ListView(
        padding: EdgeInsets.all(32),
        children: [
          Row(
            children: [
              Text("Client Name : ",
                  style: TextStyle(
                    fontSize: 20,
                  )),
              Text(
                ' ${event.title}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            children: [
              Text("Schedule : ",
                  style: TextStyle(
                    fontSize: 20,
                  )),
              Text(
                '${event.from.day}/${event.from.month}/${event.from.year} at ${event.from.hour}:${event.from.minute} to ${event.to.hour}:${event.to.minute}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
                height: 40,
                width: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.amber),
                child: TextButton(onPressed: () {}, child: Text("Follow Up"))),
          ),
        ],
      ),
    );
  }
}

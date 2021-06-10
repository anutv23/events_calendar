import 'package:events_calendar/model/event_data_source.dart';
import 'package:events_calendar/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:provider/provider.dart';

import 'tasks_widget.dart';

class CalendarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;

    return SfCalendar(
      dataSource: EventDataSource(events),
      view: CalendarView.week,
      timeSlotViewSettings: TimeSlotViewSettings(
       // timeIntervalHeight: 60,
       // timeIntervalWidth: 50,
        timeInterval:Duration(minutes: 15) ,
              timeFormat: 'h:mm a'
      ),

      initialSelectedDate: DateTime.now(),
      cellBorderColor: Colors.transparent,
      onTap: (details) {
        final provider = Provider.of<EventProvider>(context, listen: false);

        provider.setDate(details.date!);
        showModalBottomSheet(
          context: context,
          builder: (context) => TasksWidget(),
        );
      },
    );
  }
}

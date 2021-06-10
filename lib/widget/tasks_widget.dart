
import 'package:events_calendar/model/event_data_source.dart';
import 'package:events_calendar/page/event_viewing_page.dart';
import 'package:events_calendar/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:velocity_x/velocity_x.dart';


class TasksWidget extends StatefulWidget {
  @override
  _TasksWidgetState createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);
    final selectedEvents = provider.eventsOfSelectedDate;
    if (selectedEvents.isEmpty) {
      return Center(
        child: Text(
          'No Meetings Scheduled!',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
      );
    }

    return SfCalendarTheme(
      data: SfCalendarThemeData(
        timeTextStyle: TextStyle(
            fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
      ),
      child: SfCalendar(
        view:CalendarView.schedule,
        scheduleViewSettings: ScheduleViewSettings(
            appointmentItemHeight: 70,
            hideEmptyScheduleWeek: true,

            appointmentTextStyle: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w500, color: Colors.lime)
        ),
        // view: CalendarView.timelineDay,
        dataSource: EventDataSource(provider.events),
        initialDisplayDate: provider.selectedDate,
        timeSlotViewSettings: TimeSlotViewSettings(
            startHour: 9,
            endHour: 21,
            timeInterval: Duration(minutes: 15),
            timeFormat: 'h:mm a'),
        appointmentBuilder: appointmentBuilder,
        headerHeight: 0,
        todayHighlightColor: Colors.blue,
        selectionDecoration: BoxDecoration(color: Colors.transparent),
        onTap: (details) {
          if (details.appointments == null) return;

          final event = details.appointments!.first;

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EventViewingPage(event: event)));
        },
      ),
    );
  }

  Widget appointmentBuilder(
      BuildContext context, CalendarAppointmentDetails details) {
    final event = details.appointments.first;
    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
        color: event.backgroundColor.withOpacity(0.5),

        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ).p4(),
          Text(
            '${event.from.hour}:${event.from.minute.toString().padLeft(2,'0')} to ${event.to.hour}:${event.to.minute.toString().padLeft(2,'0')}',
            style: TextStyle(
              color: Colors.black54, fontSize: 12,),
          ),

        ],
      ).pOnly(left: 10,top: 2),
    );
  }
}

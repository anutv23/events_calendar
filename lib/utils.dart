import 'package:intl/intl.dart';

class Utils {
  static String toDateTime(DateTime dateTime){

    final date = DateFormat.yMMMEd().format(dateTime);

final time =  DateFormat.jm().format(dateTime);
 //final time = DateFormat('hh:mm a').format(dateTime);

    return '$date $time';
  }

  static String toDate(DateTime dateTime){
    final date = DateFormat.yMMMEd().format(dateTime);
return '$date';
  }

  static String toTime(DateTime dateTime){
//final time = DateFormat('jm').format(dateTime);
    final time =  DateFormat.jm().format(dateTime);

    return '$time';
  }



  static DateTime removeTime(DateTime dateTime) =>
      DateTime(dateTime.year,dateTime.month,dateTime.day);
}
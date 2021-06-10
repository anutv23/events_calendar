import 'package:flutter/material.dart';

class Event {
  final String title;
  final String description;
  final String meetingType;
  final DateTime from;
  final DateTime to;
  final Color backgroundColor;
  final bool isAllDay;

  const Event({
    required this.title,
    required this.description,
    required this.meetingType,
    required this.from,
    required this.to,
    this.backgroundColor = Colors.red,
    this.isAllDay = false,
  });
}

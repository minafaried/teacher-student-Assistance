import 'package:flutter/material.dart';

class Group {
  final String day;
  final String date;
  final String hour;
  final String ampm;
  final String names;
  final int groupid;
  Group(
      {@required this.day,
      @required this.date,
      @required this.hour,
      @required this.ampm,
      @required this.names,
      @required this.groupid});
}

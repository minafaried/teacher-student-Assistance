import 'package:flutter/material.dart';

class Note {
  final String day;
  final String date;
  final String hour;
  final String ampm;
  final String text;
  final int noteid;
  Note(
      {@required this.day,
      @required this.date,
      @required this.hour,
      @required this.ampm,
      @required this.text,
      @required this.noteid});

}

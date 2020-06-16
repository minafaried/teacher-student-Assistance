import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_assistant/model/note.dart';
import 'package:teacher_assistant/scoped_model/controller.dart';
import '../model/group.dart';

class AddForm extends StatefulWidget {
  final Group group;
  final Note note;
  final bool isnote;
  AddForm({
    this.group,
    this.note,
    @required this.isnote,
  });
  @override
  State<StatefulWidget> createState() {
    return AddFormState();
  }
}

class AddFormState extends State<AddForm> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    FocusNode focusdate = FocusNode();
    FocusNode focushour = FocusNode();
    FocusNode focusampm = FocusNode();
    FocusNode focustext_names = FocusNode();
    final controller = Provider.of<Controller>(context);
    String day;
    String date;
    String hour;
    String ampm;
    String text_names;
    return Scaffold(
      appBar: AppBar(
        title: widget.isnote ? Text("add note") : Text('add group'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(30),
          child: Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: 'day'),
                  initialValue: widget.isnote
                      ? widget.note == null ? '' : widget.note.day
                      : widget.group == null ? '' : widget.group.day,
                  onSaved: (String value) {
                    day = value;
                  },
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(focusdate),
                ),
                TextFormField(
                  focusNode: focusdate,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: 'date'),
                  initialValue: widget.isnote
                      ? widget.note == null ? '' : widget.note.date
                      : widget.group == null ? '' : widget.group.date,
                  onSaved: (String value) {
                    date = value;
                  },
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(focushour),
                ),
                TextFormField(
                  focusNode: focushour,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: 'hour'),
                  initialValue: widget.isnote
                      ? widget.note == null ? '' : widget.note.hour
                      : widget.group == null ? '' : widget.group.hour,
                  onSaved: (String value) {
                    hour = value;
                  },
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(focusampm),
                ),
                TextFormField(
                  focusNode: focusampm,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: 'am/pm'),
                  initialValue: widget.isnote
                      ? widget.note == null ? '' : widget.note.ampm
                      : widget.group == null ? '' : widget.group.ampm,
                  onSaved: (String value) {
                    ampm = value;
                  },
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(focustext_names),
                ),
                TextFormField(
                  focusNode: focustext_names,
                  textInputAction: TextInputAction.newline,
                  maxLines: 5,
                  decoration: widget.isnote
                      ? InputDecoration(labelText: 'text')
                      : InputDecoration(labelText: 'students name'),
                  initialValue: widget.isnote
                      ? widget.note == null ? '' : widget.note.text
                      : widget.group == null ? '' : widget.group.names,
                  onSaved: (String value) {
                    text_names = value;
                  },
                ),
                FlatButton(
                  color: Colors.purple,
                  child: Text("save"),
                  onPressed: () {
                    _formkey.currentState.save();
                    if (widget.isnote) {
                      Note note = Note(
                          day: day,
                          date: date,
                          hour: hour,
                          ampm: ampm,
                          text: text_names,
                          noteid:
                              widget.note == null ? null : widget.note.noteid);
                      if (widget.note == null) {
                        controller.addnote(note);
                      } else {
                        controller.editnote(note);
                      }
                    } else {
                      Group group = Group(
                          day: day,
                          date: date,
                          hour: hour,
                          ampm: ampm,
                          names: text_names,
                          groupid: widget.group == null
                              ? null
                              : widget.group.groupid);
                      if (widget.group == null) {
                        controller.addgroup(group);
                      } else {
                        controller.editgroup(group);
                      }
                    }
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

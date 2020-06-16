import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:teacher_assistant/model/group.dart';
import 'package:teacher_assistant/model/note.dart';
import 'package:teacher_assistant/pages/addForm.dart';
import 'package:teacher_assistant/scoped_model/controller.dart';

class CardBody extends StatefulWidget {
  final Note note;
  final Group group;
  final bool isnote;
  CardBody({this.group, this.note, @required this.isnote});
  @override
  State<StatefulWidget> createState() {
    return CardBodyState();
  }
}

class CardBodyState extends State<CardBody> {
  bool show = false;
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<Controller>(context);
    return Card(
      child: Column(

        children: <Widget>[
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Icon(Icons.date_range),
              SizedBox(
                width: 10,
              ),
              Text(widget.isnote
                  ? "${widget.note.day}   ${widget.note.date}"
                  : "${widget.group.day}   ${widget.group.date}"),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Icon(Icons.hourglass_empty),
              SizedBox(
                width: 10,
              ),
              Text(widget.isnote
                  ? "${widget.note.hour}  ${widget.note.ampm}"
                  : "${widget.group.hour}  ${widget.group.ampm}"),
            ],
          ),
          Row(
            children: <Widget>[
              IconButton(
                  icon: widget.isnote
                      ? Icon(Icons.note)
                      : Icon(Icons.supervisor_account),
                  onPressed: () {
                    setState(() {
                      show = !show;
                    });
                  })
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                padding: show
                    ? EdgeInsets.only(left: 50)
                    : EdgeInsets.only(left: 50),
                child: show
                    ? Text(widget.isnote
                        ? "${widget.note.text} "
                        : "${widget.group.names} ")
                    : Text(""),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => widget.isnote
                          ? AddForm(
                              isnote: true,
                              note: widget.note,
                            )
                          : AddForm(
                              isnote: false,
                              group: widget.group,
                            ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('chouse'),
                        content: Text("are you sure?!!"),
                        actions: <Widget>[
                          FlatButton(
                              child: Text(
                                'yes',
                                style: TextStyle(color: Colors.purple),
                              ),
                              onPressed: () {
                                widget.isnote
                                    ? controller.deletenote(widget.note)
                                    : controller.deletegroup(widget.group);

                                Navigator.of(context).pop();
                              }),
                          FlatButton(
                              child: Text(
                                'no',
                                style: TextStyle(color: Colors.purple),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              })
                        ],
                      );
                    },
                  );
                },
              )
            ],
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_assistant/scoped_model/controller.dart';
import 'package:teacher_assistant/widget/cardBody.dart';

class AllCards extends StatefulWidget {
  final bool isnote;
  AllCards({@required this.isnote});
  @override
  State<StatefulWidget> createState() {
    return AllCardsState();
  }
}

class AllCardsState extends State<AllCards> {
  Widget _buildBody(BuildContext context) {
    // print('body' + widget.controller.isLoading.toString());
    final controller = Provider.of<Controller>(context);

    Widget res;
    if (controller.databaseisLoading == true) {
      res = Center(
        child: CircularProgressIndicator(),
      );
    } else {
      if (widget.isnote
          ? controller.allNotes.length != 0
          : controller.allGroups.length != 0) {
        print(controller.allNotes.length.toString() +
            '   ' +
            controller.allGroups.length.toString());
        res = SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              children: widget.isnote
                  ? controller.allNotes
                      .map(
                        (note) => ChangeNotifierProvider<Controller>.value(
                          value: controller,
                          child: CardBody(isnote: true, note: note),
                        ),
                      )
                      .toList()
                  : controller.allGroups
                      .map(
                        (group) => ChangeNotifierProvider<Controller>.value(
                          value: controller,
                          child: CardBody(isnote: false, group: group),
                        ),
                      )
                      .toList(),
            ),
          ),
        );
      } else {
        res = Center(
          child: widget.isnote ? Text("add a note") : Text("add a group"),
        );
      }
    }

    return res;
  }

 

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }
}

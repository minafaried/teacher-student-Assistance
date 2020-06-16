import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_assistant/scoped_model/controller.dart';

class Account extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AccountState();
  }
}

class AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<Controller>(context);
    return Scaffold(
      appBar: AppBar(title: Text("my account")),
      body: Container(
        padding: EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
              Text('Code Id :${controller.teacher.teacherId}'),
              Text('name :${controller.teacher.teacherName}'),
              Text('email :${controller.teacher.email}'),
            ],
          ),
        ),
    );
  }
}

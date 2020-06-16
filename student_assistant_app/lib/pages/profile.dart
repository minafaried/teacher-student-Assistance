import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileState();
  }
}

class ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<Controller>(context);
    return Scaffold(
      appBar: AppBar(title: Text("my Profile")),
      body: Container(
        padding: EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
              Text('Code Id :${controller.student.studentId}'),
              Text('name :${controller.student.studentName}'),
              Text('email :${controller.student.email}'),
            ],
          ),
        ),
    );
  }
}

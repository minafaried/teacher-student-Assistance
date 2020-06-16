import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller.dart';
import 'home.dart';

class AddSubscriber extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddSubscriberState();
  }
}

class AddSubscriberState extends State<AddSubscriber> {
  String teacherCode;
  File uploadingFile;
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<Controller>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('add teacher'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(30),
          child: Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  initialValue: "",
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(labelText: 'Teacher Code'),
                  onSaved: (String value) {
                    teacherCode = value;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                controller.isloading == true
                    ? CircularProgressIndicator()
                    : FlatButton(
                        color: Colors.red,
                        child: Text("save"),
                        onPressed: () {
                          _formkey.currentState.save();
                          controller.addsubscriber(teacherCode).then(
                                (_) => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ChangeNotifierProvider<
                                            Controller>.value(
                                      value: controller,
                                      child: Home(),
                                    ),
                                  ),
                                ),
                              );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

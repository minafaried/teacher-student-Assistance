import 'package:client_assistant/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller.dart';

class LoginWidget extends StatelessWidget {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  final FocusNode _pass = new FocusNode();
  final FocusNode _save = new FocusNode();
  bool login = true;
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<Controller>(context);
    return Container(
      margin: EdgeInsets.all(20),
      child: Form(
        key: _formkey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
          child: Column(
            children: <Widget>[
              TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "invaled input";
                    }
                    return null;
                  },
                  controller: email,
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(_pass)),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                  textInputAction: TextInputAction.done,
                  focusNode: _pass,
                  decoration: InputDecoration(
                    labelText: 'password',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "invaled input";
                    }
                    return null;
                  },
                  controller: pass,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(_save);
                  }),
              SizedBox(
                height: 10,
              ),
              controller.isloading?
              CircularProgressIndicator():
              FlatButton(
                focusNode: _save,
                child: Text("login"),
                color: Colors.red,
                onPressed: () async {
                  if (_formkey.currentState.validate()) {
                    controller.login(email.text, pass.text).then((_) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => Home(),
                        ),
                      );
                    });
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('there is an error'),
                          content: Text("invaled email"),
                          actions: <Widget>[
                            FlatButton(
                                child: Text(
                                  'okay',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                })
                          ],
                        );
                      },
                    );
                  }
                },
              ),
              SizedBox(
                height: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

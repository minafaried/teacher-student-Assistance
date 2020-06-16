import 'package:client_assistant/widget/loginWidget.dart';
import 'package:client_assistant/widget/signupWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller.dart';

class Auth extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AuthState();
  }
}

class AuthState extends State<Auth> {
  bool login = true;
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<Controller>(context);
    return Scaffold(
      appBar: AppBar(
        title: login ? Text("login") : Text("Signup"),
      ),
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          login
              ? ChangeNotifierProvider<Controller>.value(
                  value: controller,
                  child: LoginWidget(),
                )
              : ChangeNotifierProvider<Controller>.value(
                  value: controller,
                  child: SignupWidget(),
                ),
          FlatButton.icon(
              onPressed: () {
                setState(() {
                  login = !login;
                });
              },
              icon: Icon(Icons.repeat),
              label: login ? Text("Signup") : Text("login")),
        ],
      )),
    );
  }
}

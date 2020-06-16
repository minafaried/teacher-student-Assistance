import 'package:client_assistant/pages/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Myappstate();
  }
}

class Myappstate extends State<MyApp> {
  build(context) {
    return ChangeNotifierProvider(
      lazy: false,
      create: (BuildContext context) => Controller(),
      child: MaterialApp(
        title: "Student Assistant",
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: Auth(),
      ),
    );
  }
}

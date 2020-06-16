import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_assistant/pages/auth.dart';
import 'package:teacher_assistant/scoped_model/controller.dart';
import './pages/home.dart';

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
        title: "teacher assistant",
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: Auth(),
        routes: {
          '/home': (context) => Home(),
        },
      ),
    );
  }
}

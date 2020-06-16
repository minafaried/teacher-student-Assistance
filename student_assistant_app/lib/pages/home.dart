import 'package:client_assistant/pages/profile.dart';
import 'package:client_assistant/widget/allPosts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller.dart';
import 'addSubscribar.dart';
import 'auth.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Homestate();
  }
}

class Homestate extends State<Home> {
  @override
  void initState() {
    super.initState();

    new Future.delayed(Duration.zero, () {
      final controller = Provider.of<Controller>(context, listen: false);
      controller.getposts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<Controller>(context);
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
              title: Text('choose'),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('account'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ChangeNotifierProvider<Controller>.value(
                            value: controller, child: Profile()),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Add teacher'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => AddSubscriber(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Auth(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: ChangeNotifierProvider<Controller>.value(
        value: controller,
        child: Posts(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_assistant/pages/account.dart';
import 'package:teacher_assistant/pages/addForm.dart';
import 'package:teacher_assistant/pages/auth.dart';
import 'package:teacher_assistant/pages/posts.dart';
import 'package:teacher_assistant/scoped_model/controller.dart';
import 'package:teacher_assistant/widget/allCards.dart';

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
      controller.getnotedata();
      controller.getgroupdata();
      controller.getposts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<Controller>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              AppBar(
                automaticallyImplyLeading: false,
                title: Text('choose'),
              ),
              ListTile(
                leading: Icon(Icons.add),
                title: Text('add note'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ChangeNotifierProvider<Controller>.value(
                        value: controller,
                        child: AddForm(
                          isnote: true,
                        ),
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.add),
                title: Text('add student group'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ChangeNotifierProvider<Controller>.value(
                        value: controller,
                        child: AddForm(
                          isnote: false,
                        ),
                      ),
                    ),
                  );
                },
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
                        value: controller,
                        child: Account()
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.assignment),
                title: Text('posts'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Posts(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_forever),
                title: Text('delete all'),
                onTap: () {
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
                                controller.deleteAll();
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
          title: Text('nassom'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.note),
                child: Text("all notes"),
              ),
              Tab(
                icon: Icon(Icons.list),
                child: Text('all student group'),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ChangeNotifierProvider<Controller>.value(
              value: controller,
              child: AllCards(
                isnote: true,
              ),
            ),
            ChangeNotifierProvider<Controller>.value(
                value: controller,
                child: AllCards(
                  isnote: false,
                )),
          ],
        ),
      ),
    );
  }
}

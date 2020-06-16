import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_assistant/pages/addPostForm.dart';
import 'package:teacher_assistant/scoped_model/controller.dart';
import 'package:teacher_assistant/widget/postcard.dart';

class Posts extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PostsState();
  }
}

class PostsState extends State<Posts> {
  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
              title: Text('choose'),
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text("add post"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ChangeNotifierProvider<Controller>.value(
                      value: controller,
                      child: AddPost(),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("posts"),
      ),
      body: controller.firebaseisLoading
          ? Center(child: CircularProgressIndicator())
          : controller.allPosts.length == 0
              ? Center(
                  child: Text("add post"),
                )
              : SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      children: controller.allPosts
                          .map(
                            (post) => ChangeNotifierProvider<Controller>.value(
                              value: controller,
                              child: PostCard(post),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
    );
  }
}

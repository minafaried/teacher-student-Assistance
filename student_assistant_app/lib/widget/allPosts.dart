import 'package:client_assistant/widget/postCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller.dart';

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
    return controller.isloading
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
              );
  }
}

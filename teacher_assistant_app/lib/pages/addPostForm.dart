import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:teacher_assistant/model/post.dart';
import 'package:teacher_assistant/scoped_model/controller.dart';

class AddPost extends StatefulWidget {
  final Post post;
  AddPost({this.post});
  @override
  State<StatefulWidget> createState() {
    return AddPostState();
  }
}

class AddPostState extends State<AddPost> {
  String postText;
  File uploadingFile;
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  Future<File> getFile() async {
    return await FilePicker.getFile(type: FileType.ANY).then((onValue) {
      return onValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<Controller>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('add post'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(30),
          child: Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  initialValue: widget.post == null ? "" : widget.post.text,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(labelText: 'text'),
                  onSaved: (String value) {
                    postText = value;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                uploadingFile != null
                    ? Container(
                        child: Text("${basename(uploadingFile.path)}"),
                      )
                    : Text(""),
                Container(
                  width: 200,
                  child: OutlineButton(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.library_add),
                          SizedBox(
                            width: 10,
                          ),
                          Text("add file")
                        ],
                      ),
                      onPressed: () {
                        getFile().then((onValue) {
                          setState(() {
                            uploadingFile = onValue;
                          });
                        });
                      }),
                ),
                controller.firebaseisLoading == true
                    ? CircularProgressIndicator()
                    : FlatButton(
                        color: Colors.purple,
                        child: Text("save"),
                        onPressed: () {
                          _formkey.currentState.save();
                          controller.insertFile(uploadingFile).then((onValue) {
                            widget.post == null
                                ? controller.addPost(Post(
                                    text: postText,
                                    fileUrl: onValue['fileUrl'],
                                    filePath: onValue['filePath'],
                                    type: onValue['type']))
                                : controller.editPost(
                                    Post(
                                        text: postText,
                                        postId: widget.post.postId,
                                        comments: widget.post.comments,
                                        fileUrl: onValue['fileUrl'] == null
                                            ? widget.post.fileUrl
                                            : onValue['fileUrl'],
                                        filePath: onValue['filePath'] == null
                                            ? widget.post.filePath
                                            : onValue['filePath'],
                                        type: onValue['type'] == null
                                            ? widget.post.type
                                            : onValue['type']),
                                    onValue['fileUrl'] != null
                                        ? widget.post.filePath
                                        :null);
                            Navigator.of(context).pop();
                          });
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

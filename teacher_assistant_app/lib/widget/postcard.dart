import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:teacher_assistant/model/post.dart';
import 'package:teacher_assistant/pages/addPostForm.dart';
import 'package:teacher_assistant/scoped_model/controller.dart';
import 'package:teacher_assistant/widget/imageview.dart';
import 'package:teacher_assistant/widget/pdfview.dart';

class PostCard extends StatefulWidget {
  final Post post;

  PostCard(this.post);

  @override
  State<StatefulWidget> createState() {
    return PostCardState();
  }
}

class PostCardState extends State<PostCard> {
  bool showcomments = false;
  bool showaddcomment = false;
  TextEditingController comment = TextEditingController();

  Widget comments() {
    int length = widget.post.comments == null ? 0 : widget.post.comments.length;
    return Row(
      children: <Widget>[
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              for (var i = 0; i < length; i++)
                Text(
                  "${widget.post.comments[i]}\n",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 100,
                )
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<Controller>(context);

    return Container(
      width: 1000,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                SizedBox(width: 10),
                Text("${widget.post.text}"),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                SizedBox(width: 10),
                widget.post.type != null
                    ? OutlineButton(
                        child: Row(
                          children: <Widget>[
                            Icon(widget.post.type == "pdf"
                                ? Icons.picture_as_pdf
                                : Icons.image),
                            SizedBox(width: 10),
                            Text(widget.post.type == "pdf"
                                ? "open pdf"
                                : "open image"),
                          ],
                        ),
                        onPressed: () {
                          widget.post.type == "pdf"
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ChangeNotifierProvider<
                                            Controller>.value(
                                      value: controller,
                                      child: PdfView(widget.post.fileUrl),
                                    ),
                                  ),
                                )
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ChangeNotifierProvider<
                                            Controller>.value(
                                      value: controller,
                                      child: ImageView(widget.post.fileUrl),
                                    ),
                                  ),
                                );
                        },
                      )
                    : Text(""),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.comment),
                  onPressed: () {
                    setState(
                      () {
                        if (!showcomments && !showaddcomment) {
                          showcomments = !showcomments;
                        } else if (showcomments) {
                          showcomments = false;
                          showaddcomment = false;
                        } else {
                          showcomments = !showcomments;
                          showaddcomment = !showaddcomment;
                        }
                      },
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add_comment),
                  onPressed: () {
                    setState(
                      () {
                        if (!showcomments && !showaddcomment) {
                          showaddcomment = !showaddcomment;
                        } else if (showaddcomment) {
                          showcomments = false;
                          showaddcomment = false;
                        } else {
                          showcomments = !showcomments;
                          showaddcomment = !showaddcomment;
                        }
                      },
                    );
                  },
                ),
                IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
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
                                    controller.deletePost(widget.post);
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
                    }),
                IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ChangeNotifierProvider<Controller>.value(
                            value: controller,
                            child: AddPost(post: widget.post),
                          ),
                        ),
                      );
                    }),
              ],
            ),
            showaddcomment
                ? Form(
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 220,
                          child: TextFormField(
                            textInputAction: TextInputAction.newline,
                            decoration:
                                InputDecoration(labelText: 'add comment'),
                            controller: comment,
                          ),
                        ),
                        FlatButton(
                          child: Text("comment"),
                          onPressed: () {
                            List<String> newComments = [];
                            if (widget.post.comments != null) {
                              newComments.addAll(widget.post.comments);
                            }
                            newComments.add(comment.text);
                            controller.editPost(
                              Post(
                                  text: widget.post.text,
                                  postId: widget.post.postId,
                                  comments: newComments,
                                  filePath: widget.post.filePath,
                                  fileUrl: widget.post.fileUrl,
                                  type: widget.post.type),null
                            );
                          },
                        ),
                      ],
                    ),
                  )
                : showcomments ? comments() : Text("")
          ],
        ),
      ),
    );
  }
}

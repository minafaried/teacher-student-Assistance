import 'package:client_assistant/model/Post.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import './pdfViewer.dart';
import '../controller.dart';
import 'imageViewer.dart';

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
                Text("${widget.post.ownerName}"),
              ],
            ),
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
                            controller.addComment(
                              comment.text,widget.post.postId);
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
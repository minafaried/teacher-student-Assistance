import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageView extends StatefulWidget {
  final String fileUrl;

  ImageView(
    this.fileUrl,
  );
  @override
  State<StatefulWidget> createState() {
    return ImageViewState();
  }
}

class ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: PhotoView(
      imageProvider: NetworkImage(widget.fileUrl),
    ));
  }
}

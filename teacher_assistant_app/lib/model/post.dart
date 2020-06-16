import 'package:flutter/material.dart';

class Post {
  final String postId;
  final String text;
  final List<String> comments;
  final String fileUrl;
  final String filePath;
  final String type;

  Post(
      {@required this.text,
      this.comments,
      this.postId,
      this.fileUrl,
      this.filePath,
      this.type});
}

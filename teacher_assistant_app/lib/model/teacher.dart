import 'package:flutter/material.dart';
import './post.dart';

class Teacher {
  final String teacherId;
  final String teacherName;
  final String email;
  final String password;
  final List<Post> allPosts;
  Teacher(
      {@required this.teacherName,
      this.teacherId,
      @required this.allPosts,
      this.email,
      this.password});
}

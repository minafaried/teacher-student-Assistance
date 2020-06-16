import 'dart:io';

import 'package:client_assistant/database/firebase.dart';
import 'package:client_assistant/model/Post.dart';
import 'package:flutter/cupertino.dart';

import './model/Student.dart';

class Controller extends ChangeNotifier {
  Student _student;
  List<Post> _posts = List<Post>();
  FireBase _fireBase = FireBase();
  bool _isloading = false;
  Student get student {
    return _student;
  }

  List<Post> get allPosts {
    return _posts;
  }

  bool get isloading {
    return _isloading;
  }

  void setIsLoading(bool value) {
    _isloading = value;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    setIsLoading(true);
    return await _fireBase.logein(email, password).then((value) {
      setIsLoading(false);
      if (value != null) {
        _student = value;
        return true;
      } else
        return false;
    });
  }

  Future<bool> signup(String email, String password, String name) async {
    setIsLoading(true);
    return await _fireBase.signup(email, password, name).then((value) {
      setIsLoading(false);
      if (value != null) {
        _student = value;
        return true;
      } else
        return false;
    });
  }

  Future<void> addsubscriber(String teacherId) async {
    setIsLoading(true);
    await _fireBase.addSubscriber(_student,teacherId).then((_) {
      _student.teacherSubscriberIdS.add(teacherId);
      setIsLoading(false);
    });
  }

  Future<void> getposts() async {
    setIsLoading(true);
    await _fireBase.getposts(_student.teacherSubscriberIdS).then((value) {
      setIsLoading(false);
      if (value != null) {
        _posts = value;
        return true;
      } else
        return false;
    });
  }
  Future<void> addComment(String comment, String postId) async {
    for (var i = 0; i < _posts.length; i++) {
      if (_posts[i].postId == postId) {
        List<String> comm = List<String>();
        comm.addAll(_posts[i].comments);
        comm.add(comment);
        Post p = Post(
            text: _posts[i].text,
            comments: comm,
            ownerName: _posts[i].ownerName,
            ownerId: _posts[i].ownerId,
            postId: _posts[i].postId,
            filePath: _posts[i].filePath,
            fileUrl: _posts[i].fileUrl,
            type: _posts[i].type);
        setIsLoading(true);
        await _fireBase.addComment(p, _posts[i].ownerId).then((_) {
          _posts[i].comments.add(comment);
          setIsLoading(false);
        });
        break;
      }
    }
  }
}

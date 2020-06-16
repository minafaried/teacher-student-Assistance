import 'package:teacher_assistant/model/post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:teacher_assistant/model/teacher.dart';

class FireBase {
  final String _api = "https://nasoom-ab5e9.firebaseio.com/teachers/";
  Future<Post> addpost(Post post, String id) async {
    final Map<String, dynamic> newpost = {
      'text': post.text,
      'comments': null,
      'fileUrl': post.fileUrl,
      'filePath': post.filePath,
      'type': post.type
    };

    return await http
        .post('$_api' + '$id/posts/' + '.json', body: json.encode(newpost))
        .then(
      (res) {
        Map<String, dynamic> data = json.decode(res.body);
        return Post(
            text: post.text,
            postId: data['name'],
            filePath: post.filePath,
            fileUrl: post.fileUrl,
            comments: null,
            type: post.type);
      },
    );
  }

  Future<List<Post>> getposts(String id) async {
    return await http.get('$_api' + '$id/posts/' + '.json').then((res) {
      Map<String, dynamic> data = json.decode(res.body);
      List<Post> allposts = [];
      if (data != null) {
        data.forEach((String id, dynamic postdata) {
          List<String> allcomments = [];
          int length =
              postdata['comments'] == null ? 0 : postdata['comments'].length;
          for (var i = 0; i < length; i++) {
            allcomments.add(postdata['comments'][i]);
          }
          final Post post = Post(
              text: postdata['text'],
              comments: allcomments,
              postId: id,
              fileUrl: postdata['fileUrl'],
              filePath: postdata['filePath'],
              type: postdata['type']);
          allposts.add(post);
        });
      }
      return allposts;
    });
  }

  Future<Null> editpost(Post post, String id) async {
    final Map<String, dynamic> newpost = {
      'text': post.text,
      'comments': post.comments,
      'fileUrl': post.fileUrl,
      'filePath': post.filePath,
      'type': post.type
    };

    return await http
        .put('$_api' + '$id/posts/' + '${post.postId}.json',
            body: json.encode(newpost))
        .then((onValue) {
      return;
    });
  }

  Future<Null> deletePost(String postId, String id) async {
    return await http
        .delete('$_api' + '$id/posts/' + '${postId}.json')
        .then((onValue) {
      return;
    });
  }

  Future<Map<String, String>> uploadfile(File file) async {
    String type;
    Map<String, String> res = {'filePath': null, 'fileUrl': null, 'type': null};

    if (file != null) {
      String name = basename(file.path);

      if (name.contains("pdf")) {
        type = "pdf";
      } else if (name.contains("jpg") || name.contains("png")) {
        type = "image";
      } else {
        type = "other";
      }
      res['type'] = type;
      StorageReference storageReference =
          FirebaseStorage.instance.ref().child('/$type/${name}');
      return await storageReference.putFile(file).onComplete.then((onValue) {
        return onValue.ref.getDownloadURL().then((onValue2) {
          res['filePath'] = onValue.ref.path;
          res['fileUrl'] = onValue2.toString();
          return res;
        });
      });
    } else {
      return res;
    }
  }

  Future<Null> deleteFile(String path) async {
    return await FirebaseStorage.instance.ref().child(path).delete().then((_) {
      return;
    });
  }

  Future<Teacher> getteacher(String email) async {
    return await http.get('$_api' + '.json').then((res) {
      Map<String, dynamic> data = json.decode(res.body);
      Teacher teacher = null;
      if (data != null) {
        data.forEach((String id, dynamic t) {
          if (t["email"] == email) {
            teacher = Teacher(
                teacherName: t['teacherName'],
                allPosts: List<Post>(),
                teacherId: id,
                email: t['email'],
                password: t['password']);
          }
        });
      }
      return teacher;
    });
  }

  Future<Teacher> logein(String email, String password) async {
    Map<String, dynamic> auth = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    final http.Response res = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyA7aZGtVlG7VIQ-uCYz1lP5RLZNjOO8FSg',
      body: json.encode(auth),
      headers: {'Content-Type': 'application/json'},
    );
    Map<String, dynamic> data = json.decode(res.body);

    if (data.containsKey('idToken')) {
      return getteacher(email);
    } else
      return null;
  }

  Future<Teacher> signup(
      String email, String password, String name) async {
    Map<String, dynamic> auth = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    print(auth);
    return await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyA7aZGtVlG7VIQ-uCYz1lP5RLZNjOO8FSg',
      body: json.encode(auth),
      headers: {'Content-Type': 'application/json'},
    ).then((res) async {
      Map<String, dynamic> data = json.decode(res.body);
      if (data.containsKey('idToken')) {
        final Map<String, dynamic> newteacher = {
          'posts': null,
          'teacherName': name,
          'email': email,
          'password': password
        };
        return await http
            .post('$_api' + '.json', body: json.encode(newteacher))
            .then((value) {
          Map<String, dynamic> data1 = json.decode(value.body);
          return Teacher(
              teacherId: data1["name"],
              allPosts: List<Post>(),
              teacherName: name,
              email: email,
              password: password);
        });
      } else
        return null;
    });
  }
}

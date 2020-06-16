import 'package:client_assistant/model/Post.dart';
import 'package:client_assistant/model/Student.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FireBase {
  final String _api = "https://nasoom-ab5e9.firebaseio.com/students/";

  Future<List<Post>> getposts(List<String> subscribers) async {
    List<Post> allPosts = List<Post>();
    for (int i = 0; i < subscribers.length; i++) {
      print(subscribers[i]);
      await http
          .get("https://nasoom-ab5e9.firebaseio.com/teachers/${subscribers[i]}.json")
          .then((value) {
        Map<String, dynamic> data = json.decode(value.body);
        data["posts"].forEach((String id1, dynamic postdata) {
          List<String> allcomments = [];
          int length =
              postdata['comments'] == null ? 0 : postdata['comments'].length;
          for (var i = 0; i < length; i++) {
            allcomments.add(postdata['comments'][i]);
          }
          final Post post = Post(
              ownerId: subscribers[i],
              ownerName: data["teacherName"],
              text: postdata['text'],
              comments: allcomments,
              postId: id1,
              fileUrl: postdata['fileUrl'],
              filePath: postdata['filePath'],
              type: postdata['type']);
          allPosts.add(post);
        });
      });
    }
    return allPosts;
  }

  Future<Null> addComment(Post post, String id) async {
    
    final Map<String, dynamic> newpost = {
      'text': post.text,
      'comments': post.comments,
      'fileUrl': post.fileUrl,
      'filePath': post.filePath,
      'type': post.type
    };

    return await http
        .put('https://nasoom-ab5e9.firebaseio.com/teachers/' + '$id/posts/' + '${post.postId}.json',
            body: json.encode(newpost))
        .then((onValue) {
      return;
    });
  }

  Future<void> addSubscriber(Student student, String id) async {
    List<String> ts = List<String>();
    ts.addAll(student.teacherSubscriberIdS);
    ts.add(id);
    Map<String, dynamic> newstudent = {
      'studentName': student.studentName,
      'teacherSubscriberIdS': ts,
      'email': student.email,
      'password': student.password
    };
    await http.put("$_api" + '${student.studentId}.json',
        body: json.encode(newstudent));
  }

  Future<Student> getStudent(String email) async {
    return await http.get('$_api' + '.json').then((res) {
      Map<String, dynamic> data = json.decode(res.body);
      Student student;
      if (data != null) {
        data.forEach((String id, dynamic s) {
          if (s["email"] == email) {
             List<String> ts= List<String>();
             for (var i = 0; i < s['teacherSubscriberIdS'].length; i++) {
               ts.add(s["teacherSubscriberIdS"][i]);
             }
             print(ts);
            student = Student(
                studentName: s['studentName'],
                teacherSubscriberIdS: ts,
                studentId: id,
                email: s['email'],
                password: s['password']);
          }
        });
      }
      return student;
    });
  }

  Future<Student> logein(String email, String password) async {
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
      return getStudent(email);
    } else
      return null;
  }

  Future<Student> signup(String email, String password, String name) async {
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
        final Map<String, dynamic> newStudent = {
          'teacherSubscriberIdS': null,
          'studentName': name,
          'email': email,
          'password': password
        };
        return await http
            .post('$_api' + '.json', body: json.encode(newStudent))
            .then((value) {
          Map<String, dynamic> data1 = json.decode(value.body);
          return Student(
              studentId: data1["name"],
              teacherSubscriberIdS: List<String>(),
              studentName: name,
              email: email,
              password: password);
        });
      } else
        return null;
    });
  }
}

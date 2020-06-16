import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:teacher_assistant/model/group.dart';
import 'package:teacher_assistant/model/note.dart';
import 'package:teacher_assistant/model/post.dart';
import 'package:teacher_assistant/model/teacher.dart';
import 'package:teacher_assistant/scoped_model/fireBase.dart';
import 'dataBase.dart';

class Controller extends ChangeNotifier {
  List<Note> _allNotes = List<Note>();
  List<Group> _allGroups = List<Group>();
  Teacher _teacher;
  DataBase _dataBase = DataBase();
  FireBase _fireBase = FireBase();
  bool _databaseisLoading = false;
  bool _firebaseisLoading = false;
  List<Note> get allNotes {
    return _allNotes;
  }
  Teacher get teacher {
    return _teacher;
  }
  List<Group> get allGroups {
    return _allGroups;
  }

  List<Post> get allPosts {
    return _teacher.allPosts;
  }


  bool get databaseisLoading {
    return _databaseisLoading;
  }

  bool get firebaseisLoading {
    return _firebaseisLoading;
  }

  void set_databaseIsLoading(bool value) {
    //print('cotroller' + value.toString());
    _databaseisLoading = value;
    notifyListeners();
  }

  void set_firebaseIsLoading(bool value) {
    //print('cotroller' + value.toString());
    _firebaseisLoading = value;
    notifyListeners();
  }

  Future<Null> addnote(Note n) async {
    set_databaseIsLoading(true);
    await _dataBase.insertnote(n).then((onValue) async {
      await _dataBase.getlastnoteid().then((onValue2) {
        Note newn = Note(
            day: n.day,
            date: n.date,
            hour: n.hour,
            ampm: n.ampm,
            text: n.text,
            noteid: onValue2);
        _allNotes.add(
          newn,
        );
        set_databaseIsLoading(false);
      });
    });
  }

  Future<Null> getnotedata() async {
    set_databaseIsLoading(true);
    await _dataBase.getnotes().then((onValue) {
      _allNotes = onValue;
      set_databaseIsLoading(false);
    });
  }

  Future<Null> deletenote(Note note) async {
    final int index = _allNotes.indexWhere((Note tempnote) {
      return tempnote.noteid == note.noteid;
    });
    set_databaseIsLoading(true);
    await _dataBase.deletenote(note.noteid).then((onValue) {
      if (allNotes.length == 1) {
        _allNotes.clear();
        _allNotes = [];
      } else {
        List<Note> temp = List<Note>();
        for (var i = 0; i < _allNotes.length; i++) {
          if (i != index) {
            temp.add(_allNotes[i]);
          }
        }
        _allNotes.clear();
        _allNotes.addAll(temp);
        temp.clear();
      }
      set_databaseIsLoading(false);
    });
  }

  Future<Null> editnote(Note n) async {
    set_databaseIsLoading(true);
    final int index = _allNotes.indexWhere((Note note) {
      return note.noteid == n.noteid;
    });
    await _dataBase.updatenote(n).then((onValue) {
      _allNotes[index] = n;
      set_databaseIsLoading(false);
    });
  }

  Future<Null> addgroup(Group group) async {
    set_databaseIsLoading(true);
    await _dataBase.insertgroup(group).then((onValue) async {
      await _dataBase.getlastgroupid().then((onValue2) {
        Group newg = Group(
            day: group.day,
            date: group.date,
            hour: group.hour,
            ampm: group.ampm,
            names: group.names,
            groupid: onValue2);
        _allGroups = _allGroups
          ..add(
            newg,
          );
        set_databaseIsLoading(false);
      });
    });
  }

  Future<bool> getgroupdata() async {
    set_databaseIsLoading(true);
    await _dataBase.getgroups().then((onValue) {
      _allGroups = onValue;
      set_databaseIsLoading(false);
    });
    return _allGroups == 0 ? false : true;
  }

  Future<Null> deletegroup(Group group) async {
    set_databaseIsLoading(true);
    await _dataBase.deletegroup(group.groupid).then((onValue) {
      if (_allGroups.length == 1) {
        _allGroups.remove(group);
        _allGroups = [];
      } else
        _allGroups.remove(group);

      set_databaseIsLoading(false);
    });
  }

  Future<Null> editgroup(Group n) async {
    set_databaseIsLoading(true);
    final int index = _allGroups.indexWhere((Group group) {
      return group.groupid == n.groupid;
    });
    await _dataBase.updategroup(n).then((onValue) {
      _allGroups[index] = n;
      set_databaseIsLoading(false);
    });
  }

  Future<Null> deleteAll() async {
    set_databaseIsLoading(true);
    await _dataBase.resetdatabase().then((onValue) {
      _allNotes = [];
      _allGroups = [];
      set_databaseIsLoading(false);
    });
  }

  Future<Null> addPost(Post post) async {
    set_firebaseIsLoading(true);
    await _fireBase.addpost(post, _teacher.teacherId).then((onValue) {
      _teacher.allPosts.add(onValue);
      set_firebaseIsLoading(false);
    });
  }

  Future<Null> getposts() async {
    set_firebaseIsLoading(true);
    await _fireBase.getposts(_teacher.teacherId).then((onValue) {
      _teacher.allPosts.clear();
      _teacher.allPosts.addAll(onValue);
      set_firebaseIsLoading(false);
    });
  }

  Future<Null> editPost(Post post, String oldfilepath) async {
    set_firebaseIsLoading(true);
    final int index = _teacher.allPosts.indexWhere((Post p) {
      return p.postId == post.postId;
    });
    if (oldfilepath != null) {
      await _fireBase.deleteFile(oldfilepath);
    }
    await _fireBase.editpost(post, _teacher.teacherId).then((onValue) {
      _teacher.allPosts[index] = post;
      set_firebaseIsLoading(false);
    });
  }

  Future<Null> deletePost(Post post) async {
    set_firebaseIsLoading(true);
    final int index = _teacher.allPosts.indexWhere((Post p) {
      return p.postId == post.postId;
    });
    if (post.type != null) {
      await _fireBase.deleteFile(post.filePath);
    }
    await _fireBase.deletePost(post.postId, _teacher.teacherId).then((_) async {
      _teacher.allPosts.removeAt(index);
      set_firebaseIsLoading(false);
    });
  }

  Future<Map<String, String>> insertFile(File file) async {
    set_firebaseIsLoading(true);
    return await _fireBase.uploadfile(file).then((onValue) {
      set_firebaseIsLoading(false);
      return onValue;
    });
  }

  Future<bool> signUp(
      String email, String password, String name) async {
    set_firebaseIsLoading(true);
    return await _fireBase.signup(email, password,name).then((value) {
      set_firebaseIsLoading(false);
      if (value!=null) {
        _teacher = value;
      return true;
      }
      else
        return false;
    });
  }

  Future<void> login(String email, String password) async {
    set_firebaseIsLoading(true);
    return await _fireBase.logein(email, password).then((value) {
      _teacher = value;
      set_firebaseIsLoading(false);
    });
  }
}

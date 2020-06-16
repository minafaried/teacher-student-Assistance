import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:teacher_assistant/model/group.dart';
import '../model/note.dart';
import 'package:path/path.dart';

class DataBase {
  static Database _db;
  DataBase() {
    cdb();
  }

  void cdb() async {
    if (_db == null) {
      _db = await init();
    }
  }

  void createdb(Database _db, int v)  {
    String notetable =
        "CREATE TABLE note (   day    VARCHAR (20),   date   VARCHAR (20),   hour   VARCHAR (5),   ampm   VARCHAR (2),   text   TEXT (4000),    noteid INTEGER      PRIMARY KEY AUTOINCREMENT); ";
    String grouptable =
        "CREATE TABLE studentgroup (   day    VARCHAR (20),   date   VARCHAR (20),   hour   VARCHAR (5),   ampm   VARCHAR (2),   names   TEXT (4000),    groupid INTEGER      PRIMARY KEY AUTOINCREMENT); ";

     print(_db.execute(notetable));
     print(_db.execute(grouptable));
  }

  Future<Database> init() async {
    io.Directory d = await getApplicationDocumentsDirectory();
    String path = join(d.path, "teacher_assistant.db");
   // print("\n\n\n the path: " + path);
    var newdb = await openDatabase(path, version: 1, onCreate: createdb);
    return newdb;
  }

  Future<void> insertnote(Note n) async {
   //   print('${n.text}');
    if (_db == null) {
      _db = await init();
    }
    var q =
        "insert into note (day,date,hour,ampm,text)values('${n.day}','${n.date}','${n.hour}','${n.ampm}','${n.text}')";
    print('insert note: ${await _db.rawInsert(q)}');
  }

  Future<List<Note>> getnotes() async {
    if (_db == null) {
      _db = await init();
    }
    List<Map> data = await _db.rawQuery("select * from note");
    List<Note> all = [];
    for (var i = 0; i < data.length; i++) {
      Note n = Note(
          day: data[i]['day'],
          date: data[i]['date'],
          hour: data[i]['hour'],
          ampm: data[i]['ampm'],
          text: data[i]['text'],
          noteid: data[i]['noteid']);
    //  print("get note the id is : ${data[i]['noteid']}");
      all.add(n);
    }
    return all;
  }

  Future<int> getlastnoteid() async {
    if (_db == null) {
      _db = await init();
    }
    String q = "select max(noteid) as noteid from note group by (noteid)";
    List<Map> data = await _db.rawQuery(q);
    return data[0]['noteid'];
  }

  Future<void> deletenote(int id) async {
    if (_db == null) {
      _db = await init();
    }
    String q = "delete from note where noteid='${id}'";
    await _db.rawDelete(q);
  }

  Future<void> updatenote(Note n) async {
    if (_db == null) {
      _db = await init();
    }
    String q =
        "update note set day='${n.day}',hour='${n.hour}',date='${n.date}',ampm='${n.ampm}',text='${n.text}' where noteid='${n.noteid}' ";
    await _db.rawUpdate(q);
  }

  Future<void> insertgroup(Group group) async {
    if (_db == null) {
      _db = await init();
    }
    //  print('${n.noteid}  ${n.text}');
    var q =
        "insert into studentgroup (day,date,hour,ampm,names)values('${group.day}','${group.date}','${group.hour}','${group.ampm}','${group.names}')";
    await _db.rawInsert(q);
  }

  Future<List<Group>> getgroups() async {
    if (_db == null) {
      _db = await init();
    }
    List<Map> data = await _db.rawQuery("select * from studentgroup");
    List<Group> all = [];
    for (var i = 0; i < data.length; i++) {
      Group g = Group(
          day: data[i]['day'],
          date: data[i]['date'],
          hour: data[i]['hour'],
          ampm: data[i]['ampm'],
          names: data[i]['names'],
          groupid: data[i]['groupid']);
      //print("get studentgroup the id is : ${data[i]['groupid']}");
      all.add(g);
    }
    return all;
  }

  Future<int> getlastgroupid() async {
    if (_db == null) {
      _db = await init();
    }
    String q =
        "select max(groupid) as groupid from studentgroup group by (groupid)";
    List<Map> data = await _db.rawQuery(q);
    return data[0]['groupid'];
  }

  Future<void> deletegroup(int id) async {
    if (_db == null) {
      _db = await init();
    }
    String q = "delete from studentgroup where groupid='${id}'";
    await _db.rawDelete(q);
  }

  Future<void> updategroup(Group group) async {
    if (_db == null) {
      _db = await init();
    }
    String q =
        "update studentgroup set day='${group.day}',hour='${group.hour}',date='${group.date}',ampm='${group.ampm}',names='${group.names}' where groupid='${group.groupid}' ";
    await _db.rawUpdate(q);
  }

  Future<void> resetdatabase() async {
    if (_db == null) {
      _db = await init();
    }
    String q1 = "DELETE FROM note;";
    String q2 = "DELETE FROM SQLITE_SEQUENCE WHERE NAME = 'note';";
    String q3 = "DELETE FROM studentgroup;";
    String q4 = "DELETE FROM SQLITE_SEQUENCE WHERE NAME = 'studentgroup';";
    await _db.execute(q1);
    await _db.execute(q2);
    await _db.execute(q3);
    await _db.execute(q4);
  }
}

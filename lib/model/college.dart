import 'package:cloud_firestore/cloud_firestore.dart';

class College {
  String name = "";
  String city = "";
  String code = "";
  String id = "";
  String pid = "";
  DateTime date = DateTime.now();
  int students = 0;

  College({this.name, this.city, this.code, this.id, this.students});

  void info() {
    print("College Details");
    print("Name: " + name);
    print("city: " + city);
    print("code: " + code);
    print("id: " + id);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'city': city,
      'code': code,
      'pid': pid,
      'date': date,
      'students': students,
    };
  }

  void fromDocument(DocumentSnapshot doc) {
    id = doc.documentID;
    name = doc['name'];
    city = doc['city'];
    code = doc['code'];
    pid = doc['pid'];
    date = doc['date'].toDate();
    if (doc.data.containsKey('students'))
      students = doc['students'];
    else
      students = 0;
  }
}

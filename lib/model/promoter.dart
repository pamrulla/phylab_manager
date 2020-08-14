import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phylab_manager/constants.dart';
import 'package:phylab_manager/model/types.dart';

import '../helpers.dart';

class Promoter {
  String id = "";
  String name = "";
  String phone = "";
  String email = "email";
  String role = Constants.promoterTag;
  DateTime date = DateTime.now();
  int students = 0;

  void info() {
    print("Promoter Details");
    print("id: " + id);
    print("Name: " + name);
    print("phone: " + phone);
    print("email: " + email);
    print("year: " + date.toString());
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'role': role,
      'date': date,
      'students': students,
    };
  }

  void fromDocument(DocumentSnapshot doc) {
    id = doc.documentID;
    name = doc['name'];
    phone = doc['phone'];
    email = doc['email'];
    role = doc['role'];
    students = doc['students'];
    date = doc['date'].toDate();
  }
}

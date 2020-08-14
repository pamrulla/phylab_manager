import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phylab_manager/constants.dart';
import 'package:phylab_manager/model/types.dart';

import '../helpers.dart';

class Student {
  String id = "";
  String name = "";
  String phone = "";
  String email = "email";
  String parentName = "";
  String parentPhone = "";
  String cid = "";
  String pid = "";
  String role = Constants.studentTag;
  int year = 0;
  ClassEnum classAssigned = ClassEnum.Class_11;

  String getEmailOfUser() {
    return email.split('@').first + '@' + Helper.currentCollege.code + '.com';
  }

  String getStudentInfoForStudentsListScreen() {
    return getEmailOfUser() +
        ", " +
        classAssigned.toString().split('.').last.replaceAll('_', ' ') +
        ", " +
        year.toString();
  }

  void info() {
    print("Student Details");
    print("id: " + id);
    print("Name: " + name);
    print("phone: " + phone);
    print("email: " + email);
    print("parent name: " + parentName);
    print("parent phone: " + parentPhone);
    print("College: " + cid);
    print("year: " + year.toString());
    print("class: " + classAssigned.toString());
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'parentName': parentName,
      'parentPhone': parentPhone,
      'cid': cid,
      'pid': pid,
      'role': role,
      'year': year,
      'classAssigned': classAssigned.index,
    };
  }

  void fromDocument(DocumentSnapshot doc) {
    id = doc.documentID;
    name = doc['name'];
    phone = doc['phone'];
    email = doc['email'];
    parentName = doc['parentName'];
    parentPhone = doc['parentPhone'];
    pid = doc['pid'];
    role = doc['role'];
    year = doc['year'];
    classAssigned = ClassEnum.values[doc['classAssigned']];
  }
}

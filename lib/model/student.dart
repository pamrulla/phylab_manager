import 'package:phylab_manager/model/types.dart';

import '../helpers.dart';

class Student {
  String id = "";
  String name = "";
  String phone = "";
  String email = "email";
  String parentName = "";
  String parentPhone = "";
  String college = "";
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
    print("College: " + college);
    print("year: " + year.toString());
    print("class: " + classAssigned.toString());
  }
}

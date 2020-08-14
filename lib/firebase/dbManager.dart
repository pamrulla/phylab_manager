import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phylab_manager/helpers.dart';
import 'package:phylab_manager/model/college.dart';
import 'package:phylab_manager/model/promoter.dart';
import 'package:phylab_manager/model/student.dart';

class DBManager {
  final String collegeCollection = "College";
  final String studentCollection = "Student";
  final String promoterCollection = "Promoter";

  DBManager._privateConstructor();

  static DBManager instance = DBManager._privateConstructor();

  Future<Promoter> getCurrentUser(String id) async {
    Promoter user = Promoter();
    var doc = await Firestore.instance
        .collection(promoterCollection)
        .document(id)
        .get();
    if (doc == null) return null;
    user.fromDocument(doc);
    return user;
  }

  Future<bool> addCollege(College college) async {
    try {
      DocumentReference doc =
          Firestore.instance.collection(collegeCollection).document();
      if (doc == null) {
        return false;
      }
      college.id = doc.documentID;
      doc.updateData(college.toMap());
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> addStudent(Student student, String id) async {
    try {
      WriteBatch batch = Firestore.instance.batch();
      batch.setData(
          Firestore.instance.collection(studentCollection).document(id),
          student.toMap());
      batch.updateData(
          Firestore.instance
              .collection(collegeCollection)
              .document(student.cid),
          {'students': Helper.currentCollege.students + 1});
      batch.updateData(
          Firestore.instance
              .collection(promoterCollection)
              .document(student.pid),
          {'students': Helper.currentCollege.students + 1});
      await batch.commit().catchError((e) {
        return false;
      });
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> addPromoter(Promoter promoter) async {
    try {
      WriteBatch batch = Firestore.instance.batch();
      batch.setData(
          Firestore.instance
              .collection(promoterCollection)
              .document(promoter.id),
          promoter.toMap());
      await batch.commit().catchError((e) {
        return false;
      });
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<List<Promoter>> getPromotersList() async {
    List<Promoter> promoters = List<Promoter>();
    QuerySnapshot docs =
        await Firestore.instance.collection(promoterCollection).getDocuments();
    for (int i = 0; i < docs.documents.length; ++i) {
      Promoter promoter = Promoter();
      promoter.fromDocument(docs.documents[i]);
      promoters.add(promoter);
    }
    return promoters;
  }

  Future<List<College>> getCollegesList(String pid) async {
    List<College> colleges = List<College>();
    QuerySnapshot docs = await Firestore.instance
        .collection(collegeCollection)
        .where('pid', isEqualTo: pid)
        .getDocuments();
    for (int i = 0; i < docs.documents.length; ++i) {
      College college = College();
      college.fromDocument(docs.documents[i]);
      colleges.add(college);
    }
    return colleges;
  }

  Future<List<College>> getCollegesListAdmin() async {
    List<College> colleges = List<College>();
    QuerySnapshot docs =
        await Firestore.instance.collection(collegeCollection).getDocuments();
    for (int i = 0; i < docs.documents.length; ++i) {
      College college = College();
      college.fromDocument(docs.documents[i]);
      colleges.add(college);
    }
    return colleges;
  }

  Future<List<Student>> getStudentsList(String pid, String cid) async {
    List<Student> students = List<Student>();
    QuerySnapshot docs = await Firestore.instance
        .collection(studentCollection)
        .where('pid', isEqualTo: pid)
        .where('cid', isEqualTo: cid)
        .getDocuments();
    for (int i = 0; i < docs.documents.length; ++i) {
      Student student = Student();
      student.fromDocument(docs.documents[i]);
      students.add(student);
    }
    return students;
  }

  Future<List<Student>> getStudentsListAdmin(String cid) async {
    List<Student> students = List<Student>();
    QuerySnapshot docs = await Firestore.instance
        .collection(studentCollection)
        .where('cid', isEqualTo: cid)
        .getDocuments();
    for (int i = 0; i < docs.documents.length; ++i) {
      Student student = Student();
      student.fromDocument(docs.documents[i]);
      students.add(student);
    }
    return students;
  }
}

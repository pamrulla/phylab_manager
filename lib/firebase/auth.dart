import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:phylab_manager/constants.dart';
import 'package:phylab_manager/firebase/dbManager.dart';

import '../helpers.dart';

class Authorization {
  Future<String> logIn(String username, String password) async {
    try {
      AuthResult result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: username, password: password)
          .catchError((e) {
        throw e;
      });
      if (result == null) {
        return "Invalid Email or password.";
      }
      print(result.user.uid);
      Helper.currentUserId = result.user.uid;
      var user = await DBManager.instance.getCurrentUser(result.user.uid);
      if (user.role == Constants.studentTag)
        return "Do not have permission to login";
      Helper.currentUser = user;
      return null;
    } catch (e) {
      print(e);
      return "Invalid Email or password.";
    }
  }

  Future<bool> logOut() async {
    await FirebaseAuth.instance.signOut();
    return true;
  }

/*
  Future<bool> changePassword(String password) async {
    bool ret = true;
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    await user.updatePassword(password).catchError((e) {
      ret = false;
    });
    if (ret) {
      currentAgent.isFirstTime = false;
      await DBManager.instance.updateAgent(currentAgent);
    }
    return ret;
  }
*/
  Future<Map<String, dynamic>> registerUser(
      String userName, String password) async {
    var response = await http.post(
      "https://us-central1-phylab-65237.cloudfunctions.net/createUser",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': userName,
        'pass': password,
      }),
    );
    return json.decode(response.body);
  }
}

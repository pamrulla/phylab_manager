import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:phylab_manager/helpers.dart';
import 'constants.dart';
import 'custom_route.dart';
import 'dashboard_screen.dart';
import 'firebase/auth.dart';
import 'users.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/auth';
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  //TextEditingController _nameController;
  // AnimationController _loadingController;
  // Interval _nameTextFieldLoadingAnimationInterval;

  String email;
  @override
  void initState() {
    super.initState();
    // _nameController = TextEditingController(text: email);
    // _loadingController = AnimationController(
    //   vsync: this,
    //   duration: Duration(milliseconds: 1150),
    //   reverseDuration: Duration(milliseconds: 300),
    // )..value = 1.0;
    // _nameTextFieldLoadingAnimationInterval = const Interval(0, .85);
  }

  Future<String> _loginUser(LoginData data) {
    return Future.delayed(loginTime).then((_) {
      if (!mockUsers.containsKey(data.name)) {
        return 'Username not exists';
      }
      if (mockUsers[data.name] != data.password) {
        return 'Password does not match';
      }
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      if (!mockUsers.containsKey(name)) {
        return 'Username not exists';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = BorderRadius.vertical(
      bottom: Radius.circular(10.0),
      top: Radius.circular(20.0),
    );
    return FlutterLogin(
      title: Constants.appName,
      logo: 'assets/images/iconlogo.png',
      logoTag: Constants.logoTag,
      titleTag: Constants.titleTag,
      emailValidator: (value) {
        if (!Helper.isValidEmail(value)) {
          return "Email must contain '@' and end with '.com'";
        }
        return null;
      },
      passwordValidator: (value) {
        if (value.isEmpty) {
          return 'Password is empty';
        }
        return null;
      },
      onLogin: (loginData) {
        print('Login info');
        print('Name: ${loginData.name}');
        print('Password: ${loginData.password}');
        return Authorization().logIn(loginData.name, loginData.password);
      },
      onSignup: null,
      /*(loginData) {
        print('Signup info');
        print('Name: ${loginData.name}');
        print('Password: ${loginData.password}');
        return _loginUser(loginData);
      },*/
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(FadePageRoute(
          builder: (context) => DashboardScreen(),
        ));
      },
      onRecoverPassword: null,
      /*(name) {
        print('Recover password info');
        print('Name: $name');
        return _recoverPassword(name);
        // Show new password dialog
      },*/
      showDebugButtons: false,
    );
  }
}

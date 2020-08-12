import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phylab_manager/widgets/fade_in.dart';

import 'constants.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';
import 'main.dart';
import 'model/college.dart';

class Helper {
  static College currentCollege =
      College(name: "a", city: "b", id: "c", code: "d", students: 0);

  static String getCollegeFullName() {
    return currentCollege.name +
        ',' +
        currentCollege.city +
        ', ' +
        currentCollege.code;
  }

  static bool isValidEmail(String value) {
    print(value);
    return EmailValidator.validate(value);
  }

  static bool isValidPhoneNumber(String value) {
    return RegExp(r'^\d{10}$').hasMatch(value);
  }

  static Future<bool> _goToLogin(BuildContext context) {
    return Navigator.of(context)
        .pushReplacementNamed(LoginScreen.routeName)
        // we dont want to pop the screen, just replace it completely
        .then((_) => false);
  }

  static AppBar buildAppBar(BuildContext context, ThemeData theme,
      AnimationController _loadingController) {
    final menuBtn = IconButton(
      color: Color(secondaryColor.value),
      icon: const Icon(FontAwesomeIcons.arrowLeft),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    final signOutBtn = IconButton(
      icon: const Icon(FontAwesomeIcons.signOutAlt),
      color: Color(secondaryColor.value),
      onPressed: () => _goToLogin(context),
    );
    final title = Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Hero(
              tag: Constants.logoTag,
              child: Image.asset(
                'assets/images/iconlogo.png',
                filterQuality: FilterQuality.high,
                height: 30,
              ),
            ),
          ),
          Hero(
            child: Text(
              Constants.appName,
              style: theme.textTheme.headline6,
            ),
            tag: Constants.titleTag,
          ),
          SizedBox(width: 20),
        ],
      ),
    );

    return AppBar(
      leading: Navigator.canPop(context)
          ? FadeIn(
              child: menuBtn,
              controller: _loadingController,
              offset: .3,
              curve: DashboardScreen.headerAniInterval,
              fadeDirection: FadeDirection.startToEnd,
            )
          : null,
      actions: <Widget>[
        FadeIn(
          child: signOutBtn,
          controller: _loadingController,
          offset: .3,
          curve: DashboardScreen.headerAniInterval,
          fadeDirection: FadeDirection.endToStart,
        ),
      ],
      title: title,
      backgroundColor: theme.primaryColor,
      elevation: 0,
      textTheme: theme.accentTextTheme,
      iconTheme: theme.accentIconTheme,
    );
  }
}

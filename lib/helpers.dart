import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:phylab_manager/model/promoter.dart';
import 'package:phylab_manager/widgets/fade_in.dart';

import 'constants.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';
import 'main.dart';
import 'model/college.dart';

class Helper {
  static College currentCollege =
      College(name: "a", city: "b", id: "c", code: "d", students: 0);
  static String currentUserId = "1";
  static Promoter currentUser = Promoter();

  static bool isAdmin() {
    return currentUser.role == Constants.adminTag;
  }

  static String getCollegeFullName() {
    return currentCollege.name + ',' + currentCollege.city;
    /* +
        ', ' +
        currentCollege.code;*/
  }

  static bool isValidEmail(String value) {
    print(value);
    return EmailValidator.validate(value);
  }

  static bool isValidPhoneNumber(String value) {
    return RegExp(r'^\d{10}$').hasMatch(value);
  }

  static String formatDate(DateTime date) {
    DateFormat format = DateFormat('dd-MMM-yyyy');
    return format.format(date).toString();
  }

  static void ShowASnakBar(GlobalKey<ScaffoldState> key, String message) {
    key.currentState.showSnackBar(SnackBar(
      backgroundColor: Theme.of(key.currentContext).errorColor,
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
    ));
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
      color: theme.primaryColorDark,
      icon: const Icon(FontAwesomeIcons.arrowLeft),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    final signOutBtn = IconButton(
      icon: const Icon(FontAwesomeIcons.signOutAlt),
      color: theme.primaryColorDark,
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

  static AppBar buildAppBarNoAnim(BuildContext context, ThemeData theme) {
    final menuBtn = IconButton(
      color: theme.primaryColorDark,
      icon: const Icon(FontAwesomeIcons.arrowLeft),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    final signOutBtn = IconButton(
      icon: const Icon(FontAwesomeIcons.signOutAlt),
      color: theme.primaryColorDark,
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
      leading: Navigator.canPop(context) ? menuBtn : null,
      actions: <Widget>[
        signOutBtn,
      ],
      title: title,
      backgroundColor: theme.primaryColor,
      elevation: 0,
      textTheme: theme.accentTextTheme,
      iconTheme: theme.accentIconTheme,
    );
  }

  static void showProgressbarDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return SimpleDialog(
            title: Text("Please wait..."),
            children: [
              Center(
                  child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColorDark,
              )),
            ],
          );
        });
  }
}

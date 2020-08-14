import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phylab_manager/add_student_screen.dart';
import 'package:phylab_manager/firebase/dbManager.dart';
import 'package:phylab_manager/helpers.dart';
import 'package:phylab_manager/main.dart';
import 'package:phylab_manager/model/college.dart';
import 'package:phylab_manager/theme.dart';
import 'package:phylab_manager/transition_route_observer.dart';
import 'package:phylab_manager/widgets/fade_in.dart';
import 'package:phylab_manager/widgets/text_form_field_rounded.dart';

import 'custom_route.dart';
import 'dashboard_screen.dart';

class AddCollegeScreen extends StatefulWidget {
  static String routeName = "AddCollegeScreen";
  AddCollegeScreen({Key key}) : super(key: key);

  @override
  _AddCollegeScreenState createState() => _AddCollegeScreenState();
}

class _AddCollegeScreenState extends State<AddCollegeScreen>
    with SingleTickerProviderStateMixin, TransitionRouteAware {
  AnimationController _loadingController;

  College college = College(name: "", city: "", code: "", id: "", students: 0);

  TextEditingController _nameController;
  TextEditingController _cityController;
  TextEditingController _codeController;

  FocusNode _nameFocusNode = FocusNode();
  FocusNode _cityFocusNode = FocusNode();
  FocusNode _codeFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    college.pid = Helper.currentUserId;

    _nameController = TextEditingController(text: college.name);
    _cityController = TextEditingController(text: college.city);
    _codeController = TextEditingController(text: college.code);

    _nameController.addListener(() {
      college.name = _nameController.text;
      if (college.name.length > 1) {
        _codeController.text = "";
        for (var item in college.name.split(' ')) {
          if (item.length != 0) {
            _codeController.text += item[0];
          }
        }
      } else if (college.name.length == 1) {
        _codeController.text = "";
      }
    });
    _cityController.addListener(() {
      college.city = _cityController.text;
    });
    _codeController.addListener(() {
      college.code = _codeController.text;
    });

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _loadingController.forward();
  }

  @override
  void dispose() {
    _loadingController.dispose();
    _nameController.dispose();
    _cityController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  void didPushAfterTransition() {
    _loadingController.forward();
    print('1');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: null,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: Helper.buildAppBar(context, theme, _loadingController),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: theme.primaryColor.withOpacity(.1),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      FadeIn(
                        controller: _loadingController,
                        offset: 1,
                        fadeDirection: FadeDirection.endToStart,
                        child: Text(
                          'Add New College',
                          style: theme.textTheme.headline5.copyWith(
                            fontWeight: FontWeight.w900,
                            color: accentSwatch.shade400,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FadeIn(
                        controller: _loadingController,
                        offset: 1,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: TextFromFieldRounded(
                            labelText: "College Name",
                            prefixIcon: Icon(FontAwesomeIcons.university),
                            focusNode: _nameFocusNode,
                            focusNodeNext: _cityFocusNode,
                            controller: _nameController,
                            validator: (value) {
                              if (value.isEmpty)
                                return "Name should not be empty";
                              return null;
                            },
                          ),
                        ),
                      ),
                      FadeIn(
                        controller: _loadingController,
                        offset: 2,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: TextFromFieldRounded(
                            labelText: "College City",
                            prefixIcon: Icon(FontAwesomeIcons.city),
                            focusNode: _cityFocusNode,
                            focusNodeNext: _codeFocusNode,
                            controller: _cityController,
                            validator: (value) {
                              if (value.isEmpty)
                                return "City should not be empty";
                              return null;
                            },
                          ),
                        ),
                      ),
                      /*FadeIn(
                        controller: _loadingController,
                        offset: 3,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: TextFromFieldRounded(
                            labelText: "College Code",
                            prefixIcon: Icon(FontAwesomeIcons.barcode),
                            focusNode: _codeFocusNode,
                            controller: _codeController,
                            validator: (value) {
                              if (value.isEmpty)
                                return "Code should not be empty";
                              return null;
                            },
                          ),
                        ),
                      ),*/
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            color: theme.primaryColor.withOpacity(.1),
            padding: EdgeInsets.all(0.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: FadeIn(
                    controller: _loadingController,
                    offset: 2,
                    fadeDirection: FadeDirection.bottomToTop,
                    child: FlatButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(FontAwesomeIcons.windowClose),
                      label: Text("Cancel"),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: FadeIn(
                    controller: _loadingController,
                    offset: 4,
                    fadeDirection: FadeDirection.bottomToTop,
                    child: FlatButton.icon(
                      onPressed: () {
                        _nameController.text = "";
                        _cityController.text = "";
                        _codeController.text = "";
                        _nameFocusNode.unfocus();
                        _cityFocusNode.unfocus();
                        _codeFocusNode.unfocus();
                      },
                      icon: Icon(FontAwesomeIcons.undoAlt),
                      label: Text("Clear"),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: FadeIn(
                    controller: _loadingController,
                    offset: 6,
                    fadeDirection: FadeDirection.bottomToTop,
                    child: FlatButton.icon(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          Helper.showProgressbarDialog(context);
                          bool ret =
                              await DBManager.instance.addCollege(college);
                          Navigator.pop(context);
                          if (ret) {
                            Helper.currentCollege = college;
                            Helper.currentCollege.info();

                            showDialog(
                                context: context,
                                builder: (alertContext) {
                                  return prepareAlertDialogBox(
                                      context, alertContext);
                                });
                          } else {
                            Helper.ShowASnakBar(_scaffoldKey,
                                "Something went wrong while adding College, please try again...");
                          }
                        } else {}
                      },
                      icon: Icon(
                        FontAwesomeIcons.arrowAltCircleRight,
                        color: theme.primaryColorDark,
                      ),
                      label: Text(
                        "Submit",
                        style: TextStyle(
                          color: theme.primaryColorDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget prepareAlertDialogBox(
      BuildContext context, BuildContext alertContext) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text("Success...", style: theme.primaryTextTheme.subtitle2),
      content: Text("Successfully registered college. What next?",
          style: theme.primaryTextTheme.caption),
      actions: <Widget>[
        FlatButton.icon(
          onPressed: () {
            Navigator.pop(alertContext);
            Navigator.pop(context);
          },
          icon: Icon(
            FontAwesomeIcons.home,
            color: theme.textTheme.caption.color,
          ),
          label: Text("Home", style: theme.textTheme.caption),
        ),
        FlatButton.icon(
          onPressed: () {
            Navigator.pop(context);
            Navigator.of(context).pushReplacement(FadePageRoute(
              builder: (context) => AddStudentScreen(),
            ));
          },
          icon: Icon(
            FontAwesomeIcons.userGraduate,
            color: theme.primaryColorDark,
          ),
          label: Text(
            "Register New Student",
            style: TextStyle(
              color: theme.primaryColorDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

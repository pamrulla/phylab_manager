import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phylab_manager/dashboard_screen.dart';
import 'package:phylab_manager/helpers.dart';
import 'package:phylab_manager/main.dart';
import 'package:phylab_manager/model/student.dart';
import 'package:phylab_manager/theme.dart';
import 'package:phylab_manager/transition_route_observer.dart';
import 'package:phylab_manager/widgets/fade_in.dart';
import 'package:phylab_manager/widgets/text_form_field_rounded.dart';

import 'model/student.dart';
import 'model/types.dart';

class AddStudentScreen extends StatefulWidget {
  static String routeName = "AddStudentScreen";
  AddStudentScreen({Key key}) : super(key: key);

  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen>
    with SingleTickerProviderStateMixin, TransitionRouteAware {
  AnimationController _loadingController;

  Student student = Student();
  TextEditingController _nameController;
  TextEditingController _phoneController;
  TextEditingController _emailController;
  TextEditingController _parentNameController;
  TextEditingController _parentPhoneController;

  FocusNode _nameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _parentNameFocusNode = FocusNode();
  FocusNode _parentPhoneFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    student.year = DateTime.now().year;
    student.classAssigned = ClassEnum.Class_11;
    student.email = "";

    _nameController = TextEditingController(text: student.name);
    _emailController = TextEditingController(text: student.email);
    _phoneController = TextEditingController(text: student.phone);
    _parentNameController = TextEditingController(text: student.parentName);
    _parentPhoneController = TextEditingController(text: student.parentPhone);

    _nameController.addListener(() {
      student.name = _nameController.text;
    });
    _phoneController.addListener(() {
      student.phone = _phoneController.text;
    });
    _emailController.addListener(() {
      student.email = _emailController.text;
    });
    _parentNameController.addListener(() {
      student.parentName = _parentNameController.text;
    });
    _parentPhoneController.addListener(() {
      student.parentPhone = _parentPhoneController.text;
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
    _phoneController.dispose();
    _parentNameController.dispose();
    _parentPhoneController.dispose();
    super.dispose();
  }

  @override
  void didPushAfterTransition() {
    _loadingController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: null,
      child: SafeArea(
        child: Scaffold(
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
                          'Register New Student',
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
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  Helper.getCollegeFullName(),
                                  style: theme.accentTextTheme.caption,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  student.year.toString(),
                                  style: theme.accentTextTheme.caption,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      FadeIn(
                        controller: _loadingController,
                        offset: 1,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: TextFromFieldRounded(
                            labelText: "Student Name",
                            prefixIcon: Icon(FontAwesomeIcons.userGraduate),
                            focusNode: _nameFocusNode,
                            focusNodeNext: _phoneFocusNode,
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
                            labelText: "Student Phone Number",
                            prefixIcon: Icon(FontAwesomeIcons.mobileAlt),
                            focusNode: _phoneFocusNode,
                            focusNodeNext: _emailFocusNode,
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value.isEmpty)
                                return "Phone Number should not be empty";
                              if (!Helper.isValidPhoneNumber(value))
                                return "Invalid Phone Number";
                              return null;
                            },
                          ),
                        ),
                      ),
                      FadeIn(
                        controller: _loadingController,
                        offset: 3,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: TextFromFieldRounded(
                            labelText: "Email",
                            prefixIcon: Icon(FontAwesomeIcons.envelope),
                            focusNode: _emailFocusNode,
                            focusNodeNext: _parentNameFocusNode,
                            controller: _emailController,
                            validator: (value) {
                              print(value);
                              if (value.isEmpty)
                                return "Email should not be empty";
                              if (!Helper.isValidEmail(value))
                                return 'Email is invalid';
                              return null;
                            },
                          ),
                        ),
                      ),
                      FadeIn(
                        controller: _loadingController,
                        offset: 3,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: TextFromFieldRounded(
                            labelText: "Parent Name",
                            prefixIcon: Icon(FontAwesomeIcons.houseUser),
                            focusNode: _parentNameFocusNode,
                            focusNodeNext: _parentPhoneFocusNode,
                            controller: _parentNameController,
                            validator: (value) {
                              if (value.isEmpty)
                                return "Parent name should not be empty";
                              return null;
                            },
                          ),
                        ),
                      ),
                      FadeIn(
                        controller: _loadingController,
                        offset: 4,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: TextFromFieldRounded(
                            labelText: "Parent Phone Number",
                            prefixIcon: Icon(FontAwesomeIcons.mobileAlt),
                            focusNode: _parentPhoneFocusNode,
                            controller: _parentPhoneController,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value.isEmpty)
                                return "Parent phone number should not be empty";
                              if (!Helper.isValidPhoneNumber(value))
                                return "Invalid Phone Number";
                              return null;
                            },
                          ),
                        ),
                      ),
                      FadeIn(
                        controller: _loadingController,
                        offset: 5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Choose Class: ',
                                  style: theme.accentTextTheme.caption,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: theme.backgroundColor.withAlpha(100),
                                    borderRadius: BorderRadius.circular(35.0),
                                  ),
                                  child: DropdownButton(
                                    isExpanded: true,
                                    items: ClassEnum.values
                                        .map((ClassEnum classType) {
                                      return DropdownMenuItem<ClassEnum>(
                                        child: Text(
                                          classType
                                              .toString()
                                              .split('.')
                                              .last
                                              .replaceAll('_', ' '),
                                          style: theme.accentTextTheme.caption
                                              .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        value: classType,
                                      );
                                    }).toList(),
                                    value: student.classAssigned,
                                    onChanged: (ClassEnum value) {
                                      setState(() {
                                        student.classAssigned = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
                        clearScreen();
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
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          student.info();
                          showDialog(
                              context: context,
                              builder: (alertContext) {
                                return prepareAlertDialogBox(
                                    context, alertContext);
                              });
                        } else {}
                      },
                      icon: Icon(
                        FontAwesomeIcons.arrowAltCircleRight,
                        color: secondaryColor.shade500,
                      ),
                      label: Text(
                        "Submit",
                        style: TextStyle(
                          color: secondaryColor.shade500,
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

  void clearScreen() {
    _nameController.text = "";
    _phoneController.text = "";
    _parentNameController.text = "";
    _parentPhoneController.text = "";
    _emailController.text = "";
    _nameFocusNode.unfocus();
    _emailFocusNode.unfocus();
    _phoneFocusNode.unfocus();
    _parentNameFocusNode.unfocus();
    _parentPhoneFocusNode.unfocus();
  }

  Widget prepareAlertDialogBox(
      BuildContext context, BuildContext alertContext) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text("Success...", style: theme.primaryTextTheme.subtitle2),
      content: Text("Successfully registered student. What next?",
          style: theme.primaryTextTheme.caption),
      actions: <Widget>[
        FlatButton.icon(
          onPressed: () {
            print('asf');
            Navigator.pop(alertContext);
            print('zxcv');
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
            clearScreen();
            Navigator.pop(alertContext);
          },
          icon: Icon(
            FontAwesomeIcons.userGraduate,
            color: secondaryColor.shade500,
          ),
          label: Text(
            "Register New Student",
            style: TextStyle(
              color: secondaryColor.shade500,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phylab_manager/constants.dart';
import 'package:phylab_manager/dashboard_screen.dart';
import 'package:phylab_manager/firebase/auth.dart';
import 'package:phylab_manager/firebase/dbManager.dart';
import 'package:phylab_manager/helpers.dart';
import 'package:phylab_manager/main.dart';
import 'package:phylab_manager/model/promoter.dart';
import 'package:phylab_manager/model/promoter.dart';
import 'package:phylab_manager/theme.dart';
import 'package:phylab_manager/transition_route_observer.dart';
import 'package:phylab_manager/widgets/fade_in.dart';
import 'package:phylab_manager/widgets/text_form_field_rounded.dart';

import 'model/promoter.dart';
import 'model/types.dart';

class AddPromoterScreen extends StatefulWidget {
  static String routeName = "AddPromoterScreen";
  AddPromoterScreen({Key key}) : super(key: key);

  @override
  _AddPromoterScreenState createState() => _AddPromoterScreenState();
}

class _AddPromoterScreenState extends State<AddPromoterScreen>
    with SingleTickerProviderStateMixin, TransitionRouteAware {
  AnimationController _loadingController;

  Promoter promoter = Promoter();
  TextEditingController _nameController;
  TextEditingController _phoneController;
  TextEditingController _emailController;

  FocusNode _nameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();
  final _scaffolfKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    promoter.date = DateTime.now();
    promoter.email = "";
    promoter.role = Constants.promoterTag;

    _nameController = TextEditingController(text: promoter.name);
    _emailController = TextEditingController(text: promoter.email);
    _phoneController = TextEditingController(text: promoter.phone);

    _nameController.addListener(() {
      promoter.name = _nameController.text;
    });
    _phoneController.addListener(() {
      promoter.phone = _phoneController.text;
    });
    _emailController.addListener(() {
      promoter.email = _emailController.text;
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
          key: _scaffolfKey,
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
                          'Register New Promoter',
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
                                child: Text(
                                  Helper.formatDate(promoter.date),
                                  style: theme.accentTextTheme.caption,
                                  textAlign: TextAlign.right,
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
                            labelText: "Promoter Name",
                            prefixIcon: Icon(FontAwesomeIcons.userGraduate),
                            focusNode: _nameFocusNode,
                            focusNodeNext: _phoneFocusNode,
                            controller: _nameController,
                            validator: (value) {
                              if (value.isEmpty)
                                return "Name should not be empty";
                              if (value.length < 4)
                                return "Name should be more than 4 letter";
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
                            labelText: "Promoter Phone Number",
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
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          Helper.showProgressbarDialog(context);
                          String password =
                              promoter.name.substring(0, 4).toUpperCase() +
                                  promoter.phone
                                      .substring(promoter.phone.length - 4);
                          var response = await Authorization()
                              .registerUser(promoter.email, password);
                          if (response.containsKey('error')) {
                            Navigator.pop(context);
                            Helper.ShowASnakBar(
                                _scaffolfKey, response['error']['message']);
                          } else {
                            if (!response.containsKey('uid')) {
                              Navigator.pop(context);
                              Helper.ShowASnakBar(_scaffolfKey,
                                  'Something went wrong, please try again...');
                            } else {
                              promoter.id = response['uid'];
                              bool res = await DBManager.instance
                                  .addPromoter(promoter);

                              Navigator.pop(context);
                              if (res) {
                                Helper.currentCollege.students += 1;
                                promoter.info();
                                Navigator.pop(context, true);
                              } else {
                                Helper.ShowASnakBar(_scaffolfKey,
                                    'Something went wrong, please try again...');
                              }
                            }
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

  void clearScreen() {
    _nameController.text = "";
    _phoneController.text = "";
    _emailController.text = "";
    _nameFocusNode.unfocus();
    _emailFocusNode.unfocus();
    _phoneFocusNode.unfocus();
  }
}

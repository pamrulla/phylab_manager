import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phylab_manager/firebase/dbManager.dart';
import 'package:phylab_manager/helpers.dart';
import 'package:phylab_manager/model/student.dart';
import 'package:phylab_manager/theme.dart';
import 'package:phylab_manager/transition_route_observer.dart';
import 'package:phylab_manager/widgets/center_loading_pleasewait.dart';
import 'package:phylab_manager/widgets/fade_in.dart';

import 'model/student.dart';

class StudentsListScreen extends StatefulWidget {
  static String routeName = "StudentsListScreen";
  StudentsListScreen({Key key}) : super(key: key);

  @override
  _StudentsListScreenState createState() => _StudentsListScreenState();
}

class _StudentsListScreenState extends State<StudentsListScreen>
    with SingleTickerProviderStateMixin, TransitionRouteAware {
  AnimationController _loadingController;

  List<Student> students = List<Student>();
  Future<List<Student>> studentsFuture;

  @override
  void initState() {
    super.initState();

    studentsFuture = DBManager.instance
        .getStudentsList(Helper.currentUserId, Helper.currentCollege.id);

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _loadingController.forward();
  }

  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
  }

  @override
  void didPushAfterTransition() {
    _loadingController.forward();
  }

  List<Widget> _buildList(BuildContext context) {
    final theme = Theme.of(context);
    List<Widget> items = List<Widget>();
    items.add(FadeIn(
      controller: _loadingController,
      offset: 1,
      fadeDirection: FadeDirection.endToStart,
      child: Text(
        'Students List',
        style: theme.textTheme.headline5.copyWith(
          fontWeight: FontWeight.w900,
          color: accentSwatch.shade400,
        ),
      ),
    ));
    items.add(FadeIn(
      controller: _loadingController,
      offset: 1,
      fadeDirection: FadeDirection.endToStart,
      child: Text(
        Helper.getCollegeFullName(),
        style: theme.textTheme.caption,
      ),
    ));

    items.add(SizedBox(
      height: 20,
    ));
    double count = 1;
    for (var item in students) {
      items.add(
        FadeIn(
          controller: _loadingController,
          offset: count++,
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              hoverColor: theme.primaryColorLight,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(FontAwesomeIcons.userGraduate),
              ),
              title: Text(item.name,
                  style: TextStyle(
                    color: primarySwatch.shade800,
                    fontWeight: FontWeight.w900,
                  )),
              subtitle: Text(item.getStudentInfoForStudentsListScreen()),
            ),
          ),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: null,
      child: SafeArea(
        child: Scaffold(
          appBar: Helper.buildAppBarNoAnim(context, theme),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: theme.primaryColor.withOpacity(.1),
            child: FutureBuilder(
              future: studentsFuture,
              builder: (context, AsyncSnapshot<List<Student>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length == 0) {
                    return Center(
                      child: Text(
                        'No Students',
                        style: theme.textTheme.caption,
                      ),
                    );
                  } else {
                    if (students.length == 0) {
                      snapshot.data.forEach((element) {
                        students.add(element);
                      });
                    }
                    var widges = _buildList(context);
                    _loadingController.forward();
                    return SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: widges,
                        ),
                      ),
                    );
                  }
                } else {
                  return CenterLoadingPleasewait();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

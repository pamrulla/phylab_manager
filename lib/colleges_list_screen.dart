import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phylab_manager/helpers.dart';
import 'package:phylab_manager/model/college.dart';
import 'package:phylab_manager/students_list_screen.dart';
import 'package:phylab_manager/theme.dart';
import 'package:phylab_manager/transition_route_observer.dart';
import 'package:phylab_manager/widgets/fade_in.dart';

class CollegesListScreen extends StatefulWidget {
  static String routeName = "CollegesListScreen";
  CollegesListScreen({Key key}) : super(key: key);

  @override
  _CollegesListScreenState createState() => _CollegesListScreenState();
}

class _CollegesListScreenState extends State<CollegesListScreen>
    with SingleTickerProviderStateMixin, TransitionRouteAware {
  AnimationController _loadingController;

  List<College> colleges = List<College>();

  void _prepareDummyColleges() {
    for (var i = 0; i < 10; ++i)
      colleges.add(College(
        city: "c" + i.toString(),
        name: "n" + i.toString(),
        code: 'code' + i.toString(),
        id: '',
        students: i + 1,
      ));
  }

  @override
  void initState() {
    super.initState();

    //TODO remove it
    _prepareDummyColleges();

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
        'Colleges List',
        style: theme.textTheme.headline5.copyWith(
          fontWeight: FontWeight.w900,
          color: accentSwatch.shade400,
        ),
      ),
    ));
    items.add(SizedBox(
      height: 20,
    ));
    for (var item in colleges) {
      items.add(Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          hoverColor: theme.primaryColorLight,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(FontAwesomeIcons.university),
          ),
          title: Text(item.name,
              style: TextStyle(
                color: primarySwatch.shade800,
                fontWeight: FontWeight.w900,
              )),
          subtitle: Row(
            children: [
              Expanded(child: Text(item.city)),
              Expanded(child: Text(item.code)),
              Expanded(
                  child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.userGraduate,
                    color: primarySwatch.shade300,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(item.students.toString()),
                  ),
                ],
              )),
            ],
          ),
          trailing: Icon(FontAwesomeIcons.angleDoubleRight),
          isThreeLine: false,
          onTap: () {
            Helper.currentCollege = item;
            Navigator.pushNamed(context, StudentsListScreen.routeName);
          },
        ),
      ));
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
          appBar: Helper.buildAppBar(context, theme, _loadingController),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: theme.primaryColor.withOpacity(.1),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: _buildList(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

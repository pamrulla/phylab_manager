import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phylab_manager/add_student_screen.dart';
import 'package:phylab_manager/firebase/dbManager.dart';
import 'package:phylab_manager/helpers.dart';
import 'package:phylab_manager/model/college.dart';
import 'package:phylab_manager/model/promoter.dart';
import 'package:phylab_manager/students_list_screen.dart';
import 'package:phylab_manager/theme.dart';
import 'package:phylab_manager/transition_route_observer.dart';
import 'package:phylab_manager/widgets/center_loading_pleasewait.dart';
import 'package:phylab_manager/widgets/fade_in.dart';

class PromotersListScreen extends StatefulWidget {
  static String routeName = "PromotersListScreen";
  PromotersListScreen({Key key}) : super(key: key);
  @override
  _PromotersListScreenState createState() => _PromotersListScreenState();
}

class _PromotersListScreenState extends State<PromotersListScreen>
    with SingleTickerProviderStateMixin, TransitionRouteAware {
  AnimationController _loadingController;

  Future<List<Promoter>> collegesFuture;
  List<Promoter> colleges = List<Promoter>();

  bool toAddStudent = false;

  @override
  void initState() {
    super.initState();

    collegesFuture = DBManager.instance.getPromotersList();

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
  }

  @override
  void didPushAfterTransition() {
    print('comiing');
    _loadingController.forward();
  }

  List<Widget> _buildList(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) toAddStudent = arguments['toAddStudent'];

    final theme = Theme.of(context);
    List<Widget> items = List<Widget>();
    items.add(FadeIn(
      controller: _loadingController,
      offset: 1,
      fadeDirection: FadeDirection.endToStart,
      child: Text(
        'Promoters List',
        style: theme.textTheme.headline5.copyWith(
          fontWeight: FontWeight.w900,
          color: accentSwatch.shade400,
        ),
      ),
    ));
    items.add(SizedBox(
      height: 20,
    ));
    double count = 1;
    for (var item in colleges) {
      items.add(FadeIn(
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
              child: Icon(FontAwesomeIcons.university),
            ),
            title: Text(item.name,
                style: TextStyle(
                  color: primarySwatch.shade800,
                  fontWeight: FontWeight.w900,
                )),
            subtitle: Row(
              children: [
                Expanded(
                  child: Text(item.email),
                  flex: 2,
                ),
                Expanded(
                  child: Text(item.phone),
                  flex: 2,
                ),
                Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.userGraduate,
                          color: primarySwatch.shade300,
                          size: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(item.students.toString()),
                        ),
                      ],
                    )),
              ],
            ),
            //trailing: Icon(FontAwesomeIcons.angleDoubleRight),
            isThreeLine: false,
            onTap: null,
          ),
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
          appBar: Helper.buildAppBarNoAnim(context, theme),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: theme.primaryColor.withOpacity(.1),
            child: FutureBuilder(
              future: collegesFuture,
              builder: (context, AsyncSnapshot<List<Promoter>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length == 0) {
                    return Center(
                      child: Text(
                        'No promoters',
                        style: theme.textTheme.caption,
                      ),
                    );
                  } else {
                    if (colleges.length == 0) {
                      snapshot.data.forEach((element) {
                        colleges.add(element);
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

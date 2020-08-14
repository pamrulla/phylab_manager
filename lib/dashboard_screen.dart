import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phylab_manager/add_college_screen.dart';
import 'package:phylab_manager/add_promoter_screen.dart';
import 'package:phylab_manager/add_student_screen.dart';
import 'package:phylab_manager/colleges_list_screen.dart';
import 'package:phylab_manager/promoters_list_screen.dart';
import 'package:phylab_manager/theme.dart';
import 'custom_route.dart';
import 'helpers.dart';
import 'main.dart';
import 'transition_route_observer.dart';
import 'widgets/fade_in.dart';
import 'constants.dart';
import 'widgets/animated_numeric_text.dart';
import 'widgets/round_button.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';
  static const headerAniInterval =
      const Interval(.1, .3, curve: Curves.easeOut);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin, TransitionRouteAware {
  double totalEarned = 34657;
  final globalKey = GlobalKey<ScaffoldState>();

  Future<bool> _goToLogin(BuildContext context) {
    return Navigator.of(context)
        .pushReplacementNamed(LoginScreen.routeName)
        // we dont want to pop the screen, just replace it completely
        .then((_) => false);
  }

  final routeObserver = TransitionRouteObserver<PageRoute>();
  Animation<double> _headerScaleAnimation;
  AnimationController _loadingController;

  @override
  void initState() {
    super.initState();

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _headerScaleAnimation =
        Tween<double>(begin: .6, end: 1).animate(CurvedAnimation(
      parent: _loadingController,
      curve: DashboardScreen.headerAniInterval,
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    print("Dispoting dashboard");
    routeObserver.unsubscribe(this);
    _loadingController.dispose();
    super.dispose();
  }

  @override
  void didPushAfterTransition() => _loadingController.forward();

  AppBar _buildAppBar(ThemeData theme) {
    final menuBtn = IconButton(
      color: Color.fromARGB(0, 0, 0, 0),
      icon: const Icon(FontAwesomeIcons.circle),
      onPressed: () {},
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
      leading: FadeIn(
        child: menuBtn,
        controller: _loadingController,
        offset: .3,
        curve: DashboardScreen.headerAniInterval,
        fadeDirection: FadeDirection.startToEnd,
      ),
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

  Widget _buildHeader(ThemeData theme) {
    final primaryColor = primarySwatch;
    //Colors.primaries.where((c) => c == theme.primaryColor).first;
    final accentColor = accentSwatch;
    final linearGradient = LinearGradient(colors: [
      primaryColor.shade800,
      primaryColor.shade200,
    ]).createShader(Rect.fromLTWH(0.0, 0.0, 418.0, 78.0));

    return ScaleTransition(
      scale: _headerScaleAnimation,
      child: FadeIn(
        controller: _loadingController,
        curve: DashboardScreen.headerAniInterval,
        fadeDirection: FadeDirection.bottomToTop,
        offset: .5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Welcome " + Helper.currentUser.name,
              style: theme.textTheme.headline6,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     Text(
            //       'INR',
            //       style: theme.textTheme.display2.copyWith(
            //         fontWeight: FontWeight.w300,
            //         color: accentColor.shade400,
            //       ),
            //     ),
            //     SizedBox(width: 5),
            //     AnimatedNumericText(
            //       initialValue: 0,
            //       targetValue: totalEarned,
            //       curve: Interval(0, .5, curve: Curves.easeOut),
            //       controller: _loadingController,
            //       style: theme.textTheme.display2.copyWith(
            //         foreground: Paint()..shader = linearGradient,
            //       ),
            //     ),
            //   ],
            // ),
            // Text('Total Earned', style: theme.textTheme.caption),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
      {Widget icon, String label, Interval interval, VoidCallback onPressed}) {
    return RoundButton(
      icon: icon,
      label: label,
      loadingController: _loadingController,
      interval: Interval(
        interval.begin,
        interval.end,
        curve: ElasticOutCurve(0.42),
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildDashboardGrid() {
    const step = 0.04;
    const aniInterval = 0.75;

    List<Widget> buttons = List<Widget>();
    buttons.add(_buildButton(
      icon: Icon(FontAwesomeIcons.university),
      label: 'Register College',
      interval: Interval(0, aniInterval),
      onPressed: () {
        Navigator.of(context).pushNamed(AddCollegeScreen.routeName);
      },
    ));
    buttons.add(_buildButton(
      icon: Container(
        // fix icon is not centered like others for some reasons
        padding: const EdgeInsets.only(left: 16.0),
        alignment: Alignment.centerLeft,
        child: Icon(
          FontAwesomeIcons.listUl,
          size: 20,
        ),
      ),
      label: 'Colleges List',
      interval: Interval(step, aniInterval + step),
      onPressed: () {
        Navigator.of(context).pushNamed(CollegesListScreen.routeName);
      },
    ));
    if (Helper.isAdmin()) {
      buttons.add(_buildButton(
        icon: Icon(FontAwesomeIcons.userNinja),
        label: 'Register Promoter',
        interval: Interval(0, aniInterval),
        onPressed: () async {
          var result = await Navigator.of(context)
              .pushNamed(AddPromoterScreen.routeName);
          if (result != null && result)
            globalKey.currentState
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Center(child: Text("Successfully added promoter...")),
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ));
        },
      ));
      buttons.add(_buildButton(
        icon: Icon(FontAwesomeIcons.userFriends),
        label: 'Promoters List',
        interval: Interval(0, aniInterval),
        onPressed: () async {
          Navigator.of(context).pushNamed(PromotersListScreen.routeName);
        },
      ));
    }
    buttons.add(_buildButton(
      icon: Icon(FontAwesomeIcons.userGraduate),
      label: 'Register Students',
      interval: Interval(step * 2, aniInterval + step * 2),
      onPressed: () {
        Navigator.of(context).pushNamed(CollegesListScreen.routeName,
            arguments: {'toAddStudent': true});
      },
    ));
    buttons.add(_buildButton(
      icon: Icon(FontAwesomeIcons.chartLine),
      label: 'Report',
      interval: Interval(0, aniInterval),
      onPressed: () {
        Helper.ShowASnakBar(globalKey, 'This feature is not yet implemented');
      },
    ));
    return GridView.count(
      padding: const EdgeInsets.symmetric(
        horizontal: 32.0,
        vertical: 20,
      ),
      childAspectRatio: .9,
      // crossAxisSpacing: 5,
      crossAxisCount: 2,
      children: buttons,
    );
  }

  Widget _buildDebugButtons() {
    const textStyle = TextStyle(fontSize: 12, color: Colors.white);

    return Positioned(
      bottom: 0,
      right: 0,
      child: Row(
        children: <Widget>[
          RaisedButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            color: Colors.red,
            child: Text('loading', style: textStyle),
            onPressed: () => _loadingController.value == 0
                ? _loadingController.forward()
                : _loadingController.reverse(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () => _goToLogin(context),
      child: SafeArea(
        child: Scaffold(
          key: globalKey,
          appBar: _buildAppBar(theme),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: theme.primaryColor.withOpacity(.1),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(height: 40),
                    Expanded(
                      flex: 2,
                      child: _buildHeader(theme),
                    ),
                    Expanded(
                      flex: 8,
                      child: true
                          ? ShaderMask(
                              // blendMode: BlendMode.srcOver,
                              shaderCallback: (Rect bounds) {
                                return LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  tileMode: TileMode.clamp,
                                  colors: <Color>[
                                    primarySwatch.shade600,
                                    primarySwatch.shade400,
                                    primarySwatch.shade200,
                                    primarySwatch.shade100,
                                  ],
                                ).createShader(bounds);
                              },
                              child: _buildDashboardGrid(),
                            )
                          : _buildDashboardGrid(),
                    ),
                  ],
                ),
                //if (!kReleaseMode) _buildDebugButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

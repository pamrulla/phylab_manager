import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phylab_manager/add_college_screen.dart';
import 'package:phylab_manager/add_student_screen.dart';
import 'package:phylab_manager/students_list_screen.dart';
import 'package:phylab_manager/theme.dart';
import 'package:phylab_manager/transition_route_observer.dart';

import 'colleges_list_screen.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor:
          SystemUiOverlayStyle.dark.systemNavigationBarColor,
    ),
  );
  runApp(MyApp());
}

MaterialColor primaryColor = MaterialColor(4279356158, {
  50: Color(0xffe6f9ff),
  100: Color(0xffccf4ff),
  200: Color(0xff99e8ff),
  300: Color(0xff67ddfe),
  400: Color(0xff34d2fe),
  500: Color(0xff01c6fe),
  600: Color(0xff019fcb),
  700: Color(0xff017798),
  800: Color(0xff004f66),
  900: Color(0xff002833)
});

MaterialColor secondaryColor = MaterialColor(4294853905, {
  50: Color(0xffffebe6),
  100: Color(0xffffd7cc),
  200: Color(0xffffb099),
  300: Color(0xfffe8867),
  400: Color(0xfffe6034),
  500: Color(0xfffe3901),
  600: Color(0xffcb2d01),
  700: Color(0xff982201),
  800: Color(0xff661700),
  900: Color(0xff330b00)
});

Color textColorOnbackground = Color.fromARGB(0xff, 0xFE, 0x9F, 0x85);
Color mainBackgroundColor = Color.fromARGB(0xff, 0x0e, 0x00, 0x18);
Color mainBackgroundColorLighter = Color.fromARGB(0xff, 0x37, 0x00, 0x5F);

//Primary
Color primaryColorLight = Color.fromARGB(0xff, 0x6e, 0xfd, 0xff);
Color primaryColorDark = Color.fromARGB(0xff, 0x00, 0x99, 0xcb);
Color primaryColorLargeText = Colors.black54;
Color primaryColorSmallText = Colors.black87;
Color primaryColorLightLargeText = Colors.black54;
Color primaryColorLightSmallText = Colors.black87;
Color primaryColorDarkLargeText = Colors.black54;
Color primaryColorDarkSmallText = Colors.black87;

//Secondary
Color secondaryColorLight = Color.fromARGB(0xff, 0xff, 0x7b, 0x43);
Color secondaryColorDark = Color.fromARGB(0xff, 0xc3, 0x00, 0x00);
Color secondaryColorLargeText = Colors.black54;
Color secondaryColorSmallText = Colors.black87;
Color secondaryColorLightLargeText = Colors.black54;
Color secondaryColorLightSmallText = Colors.black87;
Color secondaryColorDarkLargeText = Colors.white;
Color secondaryColorDarkSmallText = Colors.white70;

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'PhyLab: Manager',
//       theme: ThemeData(
//         primarySwatch: primaryColor,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: LogIn(),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      theme: myTheme,
      home: LoginScreen(),
      navigatorObservers: [TransitionRouteObserver()],
      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
        DashboardScreen.routeName: (context) => DashboardScreen(),
        AddCollegeScreen.routeName: (context) => AddCollegeScreen(),
        AddStudentScreen.routeName: (context) => AddStudentScreen(),
        CollegesListScreen.routeName: (context) => CollegesListScreen(),
        StudentsListScreen.routeName: (context) => StudentsListScreen(),
      },
    );
  }
}

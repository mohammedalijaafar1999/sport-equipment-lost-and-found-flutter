import 'package:flutter/material.dart';
import 'package:sports_equipment_lost_and_found_it_project/test.dart';
import 'Screens/LoadingScreen.dart';
import './Assets/Constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: MaterialColor(0xff2563EB, colorPrimaryLight),
          backgroundColor: Color(0xffFFFFFF)),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: MaterialColor(0xff00ADB5, colorPrimaryDark),
          backgroundColor: Color(0xff222831)),
      themeMode: ThemeMode.light,
      home: LoadingScreen(),
    );
  }
}

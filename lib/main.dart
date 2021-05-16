import 'package:cowin_slot_checker/constants/color_constants.dart';
import 'package:cowin_slot_checker/route.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp(
    appRoutes: AppRoutes(),
  ));
}

class MyApp extends StatelessWidget {
  final AppRoutes appRoutes;

  const MyApp({Key key, @required this.appRoutes}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: ColorConstants.kBlueColor,
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRoutes.onGenerateRoute,
    );
  }
}

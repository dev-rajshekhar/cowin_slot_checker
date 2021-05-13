import 'package:cowin_slot_checker/route.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_svg/svg.dart';

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
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRoutes.onGenerateRoute,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String stateName = "";
  String stateId = "";
  String districtName = "";
  String districtId = "";
  bool isButtonEnabled = false;
  String assets = "assets/banner.svg";

  navigateToDisttictPage() async {
    var result =
        await Navigator.of(context).pushNamed("/district", arguments: stateId);
    var encodedData = json.encode(result);
    var deCodedData = json.decode(encodedData);

    setState(() {
      if (deCodedData["fromWhere"] == "fromDistict") {
        districtName = deCodedData["name"];
        districtId = deCodedData["id"].toString();
      }
    });
  }

  navigateToStatePage() async {
    var result = await Navigator.of(context).pushNamed("/states");
    var encodedData = json.encode(result);
    var deCodedData = json.decode(encodedData);

    setState(() {
      if (deCodedData["fromWhere"] == "fromState") {
        stateName = deCodedData["name"];
        stateId = deCodedData["id"];
      }
    });
    print(stateName);
  }

  void navigateToSlotsScreen() async {
    setState(() {
      isButtonEnabled = stateName.isNotEmpty && districtName.isNotEmpty;
    });

    await Future.delayed(Duration(seconds: 1));

    isButtonEnabled
        ? Navigator.of(context).pushNamed("/slots", arguments: [
            stateName.toString(),
            stateId.toString(),
            districtName.toString(),
            districtId.toString(),
          ])
        : ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Select State & City.'),
              duration: const Duration(seconds: 1),
            ),
          );
    setState(() {
      isButtonEnabled = false;
    });
  }

  Widget buildFomSelection({String key, String value = "", Function function}) {
    return Container(
        padding: EdgeInsets.all(8.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color(0xFFFAFAFA),
          border: Border.all(color: Color(0xFFD6D6D6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(key),
            InkWell(
              onTap: () {
                if (key == "District") {
                  stateName.isNotEmpty
                      ? function()
                      : ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Select District.'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                } else {
                  function();
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SafeArea(
            child: Column(
              children: [
                SvgPicture.asset(assets),
                Text(
                  "Enter your location \n to find available slots \n around you.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 28.0,
                      fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  height: 30.0,
                ),
                buildFomSelection(
                    key: "State",
                    value: stateName,
                    function: navigateToStatePage),
                SizedBox(
                  height: 10.0,
                ),
                buildFomSelection(
                    key: "District",
                    value: districtName,
                    function: navigateToDisttictPage),
                SizedBox(
                  height: 20.0,
                ),
                InkWell(
                  onTap: () {
                    navigateToSlotsScreen();
                  },
                  child: AnimatedContainer(
                    duration: Duration(seconds: 1),
                    width: isButtonEnabled
                        ? 50
                        : MediaQuery.of(context).size.width,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFF6C6DC9),
                      borderRadius:
                          BorderRadius.circular(isButtonEnabled ? 50.0 : 50.0),
                    ),
                    child: isButtonEnabled
                        ? Icon(Icons.done, color: Colors.white)
                        : Text(
                            "Get Slots",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
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
}

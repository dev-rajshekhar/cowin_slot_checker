import 'package:cowin_slot_checker/constants/app_routs.dart';
import 'package:cowin_slot_checker/constants/color_constants.dart';
import 'package:cowin_slot_checker/constants/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

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
  String radioButtonItem = 'Pincode';
  String pinCode = "";
  DateTime date = DateTime.now();
  TextEditingController _textController = TextEditingController();
  List<bool> isSelected = [true, false];
  navigateToDisttictPage() async {
    var result = await Navigator.of(context)
        .pushNamed(AppRoutsConstants.DISTICT_ROUTE, arguments: stateId);

    List<dynamic> results = result;

    setState(() {
      if (results.length > 0 && results[0] == "fromDistict") {
        districtName = results[1];
        districtId = results[2].toString();
      }
    });
  }

  onItemChanged(String query) {
    setState(() {
      pinCode = query;
    });
  }

  Widget buildTextField() {
    final styleActive = TextStyle(
        color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold);
    final styleHint = TextStyle(
        color: Colors.black54, fontSize: 16.0, fontWeight: FontWeight.normal);
    final style = pinCode.toString().isEmpty ? styleHint : styleActive;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Color(0xFFFAFAFA),
        border: Border.all(color: Color(0xFFD6D6D6)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        style: style,
        keyboardType: TextInputType.number,
        controller: _textController,
        decoration: InputDecoration(
          hintText: 'Enter Your Pincode.',
          border: InputBorder.none,
        ),
        onChanged: onItemChanged,
      ),
    );
  }

  Future pickDate() async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
        initialEntryMode: DatePickerEntryMode.calendar,
        context: context,
        initialDate: date ?? initialDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 1));

    if (newDate == null) return;
    setState(() {
      date = newDate;
    });
  }

  navigateToStatePage() async {
    var result = await Navigator.of(context).pushNamed("/states");
    List<dynamic> results = result;

    setState(() {
      if (results.length > 0 && results[0] == "fromState") {
        stateName = results[1];
        stateId = results[2];
      }
      districtName = "";
      districtId = "";
    });
  }

  void navigateToSlotsScreen() async {
    setState(() {
      if (radioButtonItem == "Pincode") {
        isButtonEnabled = pinCode.isNotEmpty;
      } else {
        isButtonEnabled = stateName.isNotEmpty && districtName.isNotEmpty;
      }
    });

    await Future.delayed(Duration(seconds: 1));
    FocusScope.of(context).requestFocus(FocusNode());

    isButtonEnabled
        ? Navigator.of(context)
            .pushNamed(AppRoutsConstants.SLOT_ROUTE, arguments: [
            stateName.toString(),
            stateId.toString(),
            districtName.toString(),
            districtId.toString(),
            pinCode.toString(),
            getSelectedDate()
          ])
        : ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(radioButtonItem == "Pincode"
                  ? "Please enter pincode."
                  : StringConstants.ERROR_SELECT_STATE_AND_DISTRICT),
              duration: const Duration(seconds: 1),
            ),
          );

    await Future.delayed(Duration(seconds: 1));

    setState(() {
      isButtonEnabled = false;
    });
  }

  Widget buildSelectionOption() {
    return Container(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ToggleButtons(
              fillColor: Colors.transparent,
              borderColor: Colors.transparent,
              borderWidth: 0,
              constraints:
                  BoxConstraints.expand(width: constraints.maxWidth / 2),
              selectedBorderColor: Colors.transparent,
              borderRadius: BorderRadius.circular(48),
              onPressed: (index) {
                setState(() {
                  for (int i = 0; i < isSelected.length; i++) {
                    isSelected[i] = i == index;
                  }
                  if (isSelected[0]) {
                    radioButtonItem = "Pincode";
                  } else {
                    radioButtonItem = "District";
                    pinCode = "";
                    _textController.clear();
                  }
                });
              },
              isSelected: isSelected,
              children: [
                Container(
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected[0]
                        ? ColorConstants.kBlueColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.all(isSelected[0]
                        ? Radius.circular(48.0)
                        : Radius.circular(0.0)),
                  ),
                  child: Text(
                    "PINCODE",
                    style: isSelected[0]
                        ? TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )
                        : TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                  ),
                ),
                Container(
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected[1]
                        ? ColorConstants.kBlueColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.all(isSelected[1]
                        ? Radius.circular(48.0)
                        : Radius.circular(0.0)),
                  ),
                  child: Text(
                    "DISTRICT",
                    style: isSelected[1]
                        ? TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )
                        : TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                  ),
                ),
              ],
            );
          },
        ),
        width: MediaQuery.of(context).size.width,
        height: 48,
        decoration: BoxDecoration(
            color: Color(0xFFFAFAFA),
            border: Border.all(
              color: Color(0xFFD6D6D6),
            ),
            borderRadius: BorderRadius.circular(48.0)));
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
                if (key == StringConstants.DISTRICT) {
                  stateName.isNotEmpty
                      ? function()
                      : ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                                StringConstants.ERROR_SELECT_DISTRICT),
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

  String getSelectedDate() {
    return DateFormat("dd-MM-yyyy").format(date);
  }

  Widget buildDatePicker() {
    return InkWell(
      onTap: pickDate,
      child: Container(
          padding: EdgeInsets.all(8.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color(0xFFFAFAFA),
            border: Border.all(color: Color(0xFFD6D6D6)),
          ),
          child: Row(
            children: [
              Icon(Icons.date_range_outlined),
              Text(
                getSelectedDate(),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        shrinkWrap: true,
        children: [
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SafeArea(
                child: Column(
                  children: [
                    SvgPicture.asset(
                      assets,
                      height: MediaQuery.of(context).size.height * 0.4,
                    ),
                    Text(
                      StringConstants.ENTER_YOUR_LOCATION,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24.0,
                          fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    buildSelectionOption(),
                    SizedBox(
                      height: 20.0,
                    ),
                    radioButtonItem == "District"
                        ? Column(children: [
                            buildFomSelection(
                                key: StringConstants.STATE,
                                value: stateName,
                                function: navigateToStatePage),
                            SizedBox(
                              height: 10.0,
                            ),
                            buildFomSelection(
                                key: StringConstants.DISTRICT,
                                value: districtName,
                                function: navigateToDisttictPage),
                          ])
                        : buildTextField(),
                    SizedBox(
                      height: 10.0,
                    ),
                    buildDatePicker(),
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
                          borderRadius: BorderRadius.circular(
                              isButtonEnabled ? 50.0 : 50.0),
                        ),
                        child: isButtonEnabled
                            ? Icon(Icons.done, color: Colors.white)
                            : Text(
                                StringConstants.GET_SLOTS,
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
        ],
      ),
    );
  }
}

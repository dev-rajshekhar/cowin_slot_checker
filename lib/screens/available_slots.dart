import 'package:cowin_slot_checker/constants/api_constant.dart';
import 'package:cowin_slot_checker/constants/string_constants.dart';
import 'package:cowin_slot_checker/model/slots_response.dart';
import 'package:cowin_slot_checker/repo/state_repo.dart';
import 'package:cowin_slot_checker/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AvailableSlots extends StatefulWidget {
  final String stateId;
  final String stateName;
  final String districtId;
  final String districName;
  final String pinCode;
  final String selectedDate;

  const AvailableSlots({
    Key key,
    @required this.stateId,
    @required this.stateName,
    @required this.districtId,
    @required this.districName,
    @required this.pinCode,
    @required this.selectedDate,
  }) : super(key: key);
  @override
  _AvailableSlotsState createState() => _AvailableSlotsState();
}

class _AvailableSlotsState extends State<AvailableSlots> {
  StateRepo slotsRepo;
  List<Centers> centreList = [];
  bool isLoading = true;
  List<Map<String, String>> filterOptionList = [
    {"key": "min_age", "value": "18"},
    {"key": "min_age", "value": "45"},
    {"key": "paid_type", "value": "Free"},
    {"key": "paid_type", "value": "Paid"},
  ];
  List<Map<String, String>> selectedChoices = [];

  Future fetchSlots() async {
    Map<String, String> queryParams = {
      'district_id': widget.districtId.toString(),
      'date': widget.selectedDate.toString()
    };
    Map<String, String> queryParamsByPin = {
      'pincode': widget.pinCode.toString(),
      'date': widget.selectedDate.toString()
    };

    slotsRepo = StateRepo();
    widget.pinCode.isNotEmpty
        ? slotsRepo.fetchAllSlotsByPin(queryParamsByPin).then((value) {
            setState(() {
              centreList = value.centers;
              fetchSlotMinAge();
              isLoading = false;
            });
          }).onError((error, stackTrace) {
            setState(() {
              isLoading = false;
            });
          })
        : slotsRepo.fetchAllSlotsByDistrict(queryParams).then((value) {
            setState(() {
              centreList = value.centers;
              fetchSlotMinAge();
            });
          }).onError((error, stackTrace) {
            setState(() {
              isLoading = false;
            });
          });
  }

  List<Sessions> fetchSlotMinAge() {
    List<Sessions> sessionList = [];
    for (var i = 0; i < centreList.length; i++) {
      List<Sessions> session = centreList[i]
          .sessions
          .where(
              (string) => string.date.contains(widget.selectedDate.toString()))
          // .where((item) => item.availableCapacity > 0)
          .toList();
      sessionList = sessionList..addAll(session);
    }
    return sessionList;
  }

  // filterSlots({String key, String value}) {
  //   print("key" + key + "value:" + value);
  //   List<Sessions> sessionList = [];
  //   List<Centers> centers = [];

  //   for (var i = 0; i < centreList.length; i++) {
  //     List<Sessions> session = centreList[i]
  //         .sessions
  //         .where(
  //             (string) => string.date.contains(widget.selectedDate.toString()))
  //         .where((item) => item.minAgeLimit == 18)
  //         .toList();

  //     if (session.length > 0) {
  //       centers..add(centreList[i]);
  //     }

  //     sessionList = sessionList..addAll(session);
  //   }
  //   print("===Flutter" + centers.toString());
  // }

  String getDateString(String date) {
    DateTime parseDate = DateFormat("dd-MM-yyyy").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('MMM dd, yyyy');
    var outputDate = outputFormat.format(inputDate);

    return outputDate;
  }

  @override
  void initState() {
    fetchSlots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print("object" + date.toString());
    return Scaffold(
      appBar: AppBar(title: Text("Find Your Slots")),
      body: ListView(
        children: [
          // Container(
          //   height: 150.0,
          //   color: Colors.white,
          //   child: Row(
          //     children: [
          //       ...filterOptionList.map((label) {
          //         return ChoiceChip(
          //           label: Text(label["value"]),
          //           onSelected: (selected) {
          //             setState(() {
          //               selectedChoices.contains(label)
          //                   ? selectedChoices.remove(label)
          //                   : selectedChoices.add(label);
          //             });
          //           },
          //           selected: selectedChoices.contains(label),
          //         );
          //       }),
          //     ],
          //   ),
          // ),
          Container(
            margin: EdgeInsets.all(10.0),
            color: Color(0xFFF8F8F8),
            child: Column(
              children: [
                Text(
                  getDateString(widget.selectedDate),
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RichText(
                    text: TextSpan(
                        text: 'Note: ',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0),
                        children: [
                          TextSpan(
                            text:
                                'Open slots exhaust quickly so the availibity here might differ from that is available whn you login to cowin.',
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 12.0),
                          ),
                        ]),
                  ),
                ),
                !isLoading
                    ? fetchSlotMinAge().length > 0
                        ? ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            itemCount: centreList.length,
                            itemBuilder: (context, index) {
                              var centerInfo = centreList[index];

                              return RenderCenter(
                                  center: centerInfo,
                                  date: widget.selectedDate.toString());
                            })
                        : Container(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: Center(
                                child: Text(
                                    "No Vaccination center is available for booking.")),
                          )
                    : Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Center(child: CircularProgressIndicator()))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RenderCenter extends StatelessWidget {
  final Centers center;
  final String date;

  const RenderCenter({Key key, @required this.center, @required this.date})
      : super(key: key);

  List<Sessions> fetchSlotMinAge(
    Centers centers,
  ) {
    List<Sessions> sessions =
        centers.sessions.where((string) => string.date.contains(date)).toList();

    return sessions;
  }

  @override
  Widget build(BuildContext context) {
    List<Sessions> sessions = fetchSlotMinAge(center);
    return sessions.length > 0
        ? Card(
            elevation: 4.0,
            margin: new EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(center.name,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      Text(
                        sessions[0].availableCapacity.toString() + " slots",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFF00C7E2),
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    center.address + ", " + center.pincode.toString(),
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFF666666),
                        fontWeight: FontWeight.normal),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextWithPadding(text: center.feeType),
                      Spacer(),
                      TextWithPadding(
                          text: sessions[0].minAgeLimit.toString() + "+"),
                      Spacer(),
                      TextWithPadding(text: sessions[0].vaccine.toString()),
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          Utils.openLink(url: ApiConstant.COWIN_WEB);
                        },
                        child: Text(
                          StringConstants.BOOK_ON_COWIN,
                          style: TextStyle(
                              fontSize: 12.0,
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.bold),
                        ),
                        style: TextButton.styleFrom(
                          minimumSize: Size(120.0, 30.0),
                          backgroundColor: Color(0xFF6C6DC9),
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        : Text("");
  }
}

class TextWithPadding extends StatelessWidget {
  final String text;
  const TextWithPadding({
    Key key,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFEDF9F7),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 12.0, color: Colors.black),
        textAlign: TextAlign.center,
      ),
    );
  }
}

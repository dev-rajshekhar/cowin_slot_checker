import 'package:cowin_slot_checker/constants/color_constants.dart';
import 'package:cowin_slot_checker/model/slots_response.dart';
import 'package:cowin_slot_checker/repo/state_repo.dart';
import 'package:cowin_slot_checker/widgest/render_center.dart';
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
  List<Centers> filteredList = [];

  bool isLoading = true;
  var clickedDate = "";
  int _choiceIndex = 0;
  bool _isSlotAvailable = false;

  List<Map<String, String>> selectedChoices = [];

  Future fetchSlots() async {
    clickedDate = widget.selectedDate.toString();
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
              fetchSlotMinAge(clickedDate, _isSlotAvailable);
              fetchCentreByDate(clickedDate, _isSlotAvailable);
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
              fetchSlotMinAge(clickedDate, _isSlotAvailable);
              fetchCentreByDate(clickedDate, _isSlotAvailable);

              isLoading = false;
            });
          }).onError((error, stackTrace) {
            setState(() {
              isLoading = false;
            });
          });

    print("===>" + centreList.toString());
  }

  List<String> getSlotsDate() {
    List<String> dates = [];
    for (var i = 0; i < centreList.length; i++) {
      List<Sessions> session = centreList[i].sessions;
      for (var j = 0; j < session.length; j++) {
        dates.add(session[j].date.toString());
      }
    }
    return dates.toSet().toList();
  }

  List<Sessions> fetchSlotMinAge(String date, bool isAvailableSlots) {
    List<Sessions> sessionList = [];
    if (isAvailableSlots) {
      for (var i = 0; i < centreList.length; i++) {
        List<Sessions> session = centreList[i]
            .sessions
            .where((string) => string.date.contains(date))
            .where((item) => item.availableCapacity > 0)
            .toList();
        sessionList = sessionList..addAll(session);
      }
    } else {
      for (var i = 0; i < centreList.length; i++) {
        List<Sessions> session = centreList[i]
            .sessions
            .where((string) => string.date.contains(date))
            // .where((item) => item.availableCapacity > 0)
            .toList();
        sessionList = sessionList..addAll(session);
      }
    }
    print("sessionList" + sessionList.length.toString());

    return sessionList;
  }

  fetchCentreByDate(String date, bool isAvailableSlots) {
    List<Centers> centreLists = [];
    filteredList.clear();
    if (isAvailableSlots) {
      for (var i = 0; i < centreList.length; i++) {
        List<Sessions> session = centreList[i]
            .sessions
            .where((string) => string.date.contains(date))
            .where((item) => item.availableCapacity > 0)
            .toList();
        if (session.length > 0) {
          centreLists.add(centreList[i]);

          setState(() {
            filteredList = centreLists;
          });
        }
      }
    } else {
      for (var i = 0; i < centreList.length; i++) {
        List<Sessions> session = centreList[i]
            .sessions
            .where((string) => string.date.contains(date))
            // .where((item) => item.availableCapacity > 0)
            .toList();
        if (session.length > 0) {
          centreLists.add(centreList[i]);

          setState(() {
            filteredList = centreLists;
          });
        }
      }
    }

    print("filteredList" + filteredList.length.toString());
  }

  String getDateString(String selectedDate) {
    DateTime parseDate = DateFormat("dd-MM-yyyy").parse(selectedDate);
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
        physics: ScrollPhysics(),
        children: [
          Container(
            height: 60.0,
            color: Colors.white,
            child: ListView.builder(
              padding: EdgeInsets.all(6),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: getSlotsDate().length,
              itemBuilder: (context, index) {
                var label = getSlotsDate()[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ChoiceChip(
                    shape: StadiumBorder(side: BorderSide()),
                    selected: _choiceIndex == index,
                    selectedColor: ColorConstants.kBlueColor,
                    backgroundColor: Color(0xFFFAFAFA),
                    label: Text(
                      getDateString(label),
                      style: TextStyle(
                          color: _choiceIndex == index
                              ? Colors.white
                              : Colors.black,
                          fontSize: 12.0),
                    ),
                    onSelected: (selected) {
                      setState(() {
                        _choiceIndex = selected ? index : 0;

                        clickedDate = label;
                      });
                      fetchSlotMinAge(clickedDate, _isSlotAvailable);
                      fetchCentreByDate(clickedDate, _isSlotAvailable);
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            height: 50.0,
            color: Colors.white,
            child: Row(
              children: [
                Checkbox(
                  value: _isSlotAvailable,
                  onChanged: (value) {
                    setState(() {
                      _isSlotAvailable = value;
                    });
                    fetchSlotMinAge(clickedDate, _isSlotAvailable);
                    fetchCentreByDate(clickedDate, _isSlotAvailable);
                  },
                ),
                Text(
                  'Show only available Slots.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            color: Color(0xFFF8F8F8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      getDateString(clickedDate),
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ],
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
                    ? fetchSlotMinAge(widget.selectedDate, _isSlotAvailable)
                                .length >
                            0
                        ? ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              var centerInfo = filteredList[index];

                              return RenderCenter(
                                  center: centerInfo, date: clickedDate);
                            },
                          )
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

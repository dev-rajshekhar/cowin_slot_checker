import 'package:cowin_slot_checker/model/slots_response.dart';
import 'package:cowin_slot_checker/repo/state_repo.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AvailableSlots extends StatefulWidget {
  final String stateId;
  final String stateName;
  final String districtId;
  final String districName;

  const AvailableSlots(
      {Key key,
      @required this.stateId,
      @required this.stateName,
      @required this.districtId,
      @required this.districName})
      : super(key: key);
  @override
  _AvailableSlotsState createState() => _AvailableSlotsState();
}

class _AvailableSlotsState extends State<AvailableSlots> {
  StateRepo slotsRepo;
  List<Centers> centreList = [];

  String date = "";
  Future fetchSlots() async {
    var dt = DateTime.now();
    setState(() {
      date = DateFormat("dd-MM-yyyy").format(dt);
    });
    Map<String, String> queryParams = {
      'district_id': widget.districtId.toString(),
      'date': date
    };

    slotsRepo = StateRepo();
    slotsRepo.fetchAllSlotsByDistrict(queryParams).then((value) {
      setState(() {
        centreList = value.centers;
      });
    });
  }

  @override
  void initState() {
    fetchSlots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Find Your Slots")),
      body: Container(
        color: Color(0xFFF8F8F8),
        child: Column(
          children: [
            Text(
              DateFormat("MMM dd, yyyy").format(DateTime.now()),
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
            Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  itemCount: centreList.length,
                  itemBuilder: (context, index) {
                    var centerInfo = centreList[index];
                    return RenderCenter(center: centerInfo, date: date);
                  }),
            )
          ],
        ),
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
                        sessions[0].availableCapacity.toString() + "slots",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFF00C7E2),
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    center.blockName + ", " + center.pincode.toString(),
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
                      TextWithPadding(text: sessions[0].minAgeLimit.toString()),
                      Spacer(),
                      TextWithPadding(text: sessions[0].vaccine.toString()),
                      Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: Text("Book on Cowin"),
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

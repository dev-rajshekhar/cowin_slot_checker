import 'package:cowin_slot_checker/constants/api_constant.dart';
import 'package:cowin_slot_checker/constants/string_constants.dart';
import 'package:cowin_slot_checker/model/slots_response.dart';
import 'package:cowin_slot_checker/utils/utils.dart';
import 'package:flutter/material.dart';

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
    return Card(
      shape: sessions[0].availableCapacity == 0
          ? RoundedRectangleBorder(
              side: BorderSide(color: Color(0xFFD6D6D6), width: 2),
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            )
          : null,
      elevation: sessions[0].availableCapacity > 0 ? 4.0 : 0.0,
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
                Flexible(
                  child: Text(center.name,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                ),
                Text(
                  sessions[0].availableCapacity.toString() + " slots",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: sessions[0].availableCapacity > 0
                          ? Color(0xFF00C7E2)
                          : Color(0xFFFF3333),
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
                TextWithPadding(text: sessions[0].minAgeLimit.toString() + "+"),
                Spacer(),
                TextWithPadding(text: sessions[0].vaccine.toString()),
                Spacer(),
                sessions[0].availableCapacity > 0
                    ? TextButton(
                        onPressed: () {
                          sessions[0].availableCapacity > 0 ??
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
                      )
                    : Container(
                        color: Color(0xFFFF3333),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: Text(
                          "Booked",
                          style: TextStyle(fontSize: 12.0, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                sessions[0].availableCapacity == 0 ? Spacer() : SizedBox()
              ],
            ),
          ],
        ),
      ),
    );
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

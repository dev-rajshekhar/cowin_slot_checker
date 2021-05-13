import 'package:cowin_slot_checker/available_slots.dart';
import 'package:cowin_slot_checker/main.dart';
import 'package:cowin_slot_checker/select_district.dart';
import 'package:cowin_slot_checker/select_state.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    var args = routeSettings.arguments;
    print(args);
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute<dynamic>(builder: (_) => MyHomePage());
        break;
      case '/states':
        return MaterialPageRoute<dynamic>(builder: (_) => SelecteState());
        break;
      case '/district':
        if (args is String) {
          return MaterialPageRoute<dynamic>(
              builder: (_) => SelectDistricts(stateId: args));
        }
        return null;
        break;
      case '/slots':
        List<dynamic> arguments = routeSettings.arguments;
        return MaterialPageRoute<dynamic>(
            builder: (_) => AvailableSlots(
                  districName: arguments[2],
                  stateId: arguments[1],
                  districtId: arguments[3],
                  stateName: arguments[0],
                ));

        break;
      default:
        return null;
    }
  }
}

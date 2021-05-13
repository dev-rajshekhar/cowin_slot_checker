import 'package:cowin_slot_checker/screens/screens.dart';
import 'package:flutter/material.dart';

import 'constants/app_routs.dart';

class AppRoutes {
  Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    var args = routeSettings.arguments;
    print(args);
    switch (routeSettings.name) {
      case AppRoutsConstants.HOME_PAGE_ROUTE:
        return MaterialPageRoute<dynamic>(builder: (_) => MyHomePage());
        break;
      case AppRoutsConstants.STATE_ROUTE:
        return MaterialPageRoute<dynamic>(builder: (_) => SelecteState());
        break;
      case AppRoutsConstants.DISTICT_ROUTE:
        if (args is String) {
          return MaterialPageRoute<dynamic>(
            builder: (_) => SelectDistricts(stateId: args),
          );
        }
        return null;
        break;
      case AppRoutsConstants.SLOT_ROUTE:
        List<dynamic> arguments = routeSettings.arguments;
        return MaterialPageRoute<dynamic>(
          builder: (_) => AvailableSlots(
            districName: arguments[2],
            stateId: arguments[1],
            districtId: arguments[3],
            stateName: arguments[0],
          ),
        );

        break;
      default:
        return null;
    }
  }
}

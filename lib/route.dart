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
        return AnimatedRoute(SelecteState());

        // MaterialPageRoute<dynamic>(builder: (_) => SelecteState());
        break;
      case AppRoutsConstants.DISTICT_ROUTE:
        return AnimatedRoute(SelectDistricts(stateId: args));
        // if (args is String) {
        //   return MaterialPageRoute<dynamic>(
        //     builder: (_) => SelectDistricts(stateId: args),
        //   );
        // }
        // return null;
        break;
      case AppRoutsConstants.SLOT_ROUTE:
        List<dynamic> arguments = routeSettings.arguments;
        return AnimatedRoute(AvailableSlots(
          districName: arguments[2],
          stateId: arguments[1],
          districtId: arguments[3],
          stateName: arguments[0],
          pinCode: arguments[4],
          selectedDate: arguments[5],
        ));

        // return MaterialPageRoute<dynamic>(
        //   builder: (_) => AvailableSlots(
        //     districName: arguments[2],
        //     stateId: arguments[1],
        //     districtId: arguments[3],
        //     stateName: arguments[0],
        //     pinCode: arguments[4],
        //     selectedDate: arguments[5],
        //   ),
        // );

        break;
      default:
        return null;
    }
  }
}

class AnimatedRoute extends PageRouteBuilder {
  final Widget widget;

  AnimatedRoute(this.widget)
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => widget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(0.0, 1.0);
            var end = Offset.zero;
            var tween = Tween(begin: begin, end: end);
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}

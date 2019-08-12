import 'package:flutter/widgets.dart' as flutter;
import 'package:hpi_flutter/route.dart';

class NavigationService {
  Route lastKnownRoute;
  static Route getActiveScreen(flutter.BuildContext context) {
    Route route;
    flutter.Navigator.popUntil(context, (r) {
      route = Route.fromString(r.settings.name);
      return true;
    });
    return route;
  }
}

class NavigationObserver extends flutter.RouteObserver {
  NavigationObserver(this.service) : assert(service != null);

  final NavigationService service;

  @override
  void didPush(
      flutter.Route<dynamic> route, flutter.Route<dynamic> previousRoute) {
    _onUpdate(route, previousRoute);
  }

  @override
  void didPop(flutter.Route route, flutter.Route previousRoute) {
    _onUpdate(previousRoute, route);
  }

  @override
  void didRemove(flutter.Route route, flutter.Route previousRoute) {
    _onUpdate(previousRoute, route);
  }

  @override
  void didReplace(
      {flutter.Route<dynamic> newRoute, flutter.Route<dynamic> oldRoute}) {
    _onUpdate(newRoute, oldRoute);
  }

  void _onUpdate(
      flutter.Route<dynamic> newRoute, flutter.Route<dynamic> oldRoute) {
    var knownRoute = Route.fromString(newRoute?.settings?.name);
    if (knownRoute != null) service.lastKnownRoute = knownRoute;
    // Route newInternalRoute = Route.fromString(newRoute.settings.name);
    // print("Navigated from ${oldRoute?.settings?.name} to ");
    // service.activeScreen = newInternalRoute;
  }
}

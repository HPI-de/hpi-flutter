import 'package:flutter/widgets.dart' as flutter;
import 'package:hpi_flutter/route.dart';

class NavigationService {
  Route lastKnownRoute;
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
    print(
        "Navigating from ${oldRoute?.settings?.name} to ${newRoute?.settings?.name}");
    var knownRoute = Route.fromString(newRoute?.settings?.name);
    if (knownRoute != null) service.lastKnownRoute = knownRoute;
  }
}

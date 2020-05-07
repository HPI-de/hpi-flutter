import 'package:flutter/widgets.dart' as flutter;

import '../utils.dart';

class NavigationService {
  String lastKnownRoute;
}

class NavigationObserver extends flutter.RouteObserver {
  final NavigationService service = services.get<NavigationService>();

  @override
  void didPush(
    flutter.Route<dynamic> route,
    flutter.Route<dynamic> previousRoute,
  ) {
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
  void didReplace({
    flutter.Route<dynamic> newRoute,
    flutter.Route<dynamic> oldRoute,
  }) {
    _onUpdate(newRoute, oldRoute);
  }

  void _onUpdate(
    flutter.Route<dynamic> newRoute,
    flutter.Route<dynamic> oldRoute,
  ) {
    print(
        'Navigating from ${oldRoute?.settings?.name} to ${newRoute?.settings?.name}');
    final knownRoute = newRoute?.settings?.name;
    if (knownRoute != null) {
      service.lastKnownRoute = knownRoute;
    }
  }
}

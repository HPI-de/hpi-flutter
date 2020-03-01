import 'package:flutter/widgets.dart';

class HpiTheme extends InheritedWidget {
  const HpiTheme({@required this.tertiary, Widget child})
      : assert(tertiary != null),
        super(child: child);

  factory HpiTheme.of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<HpiTheme>();

  final Color tertiary;

  @override
  bool updateShouldNotify(HpiTheme oldWidget) {
    return tertiary != oldWidget.tertiary;
  }
}

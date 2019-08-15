import 'package:flutter/widgets.dart';

@immutable
class HpiTheme extends InheritedWidget {
  HpiTheme({@required this.tertiary, Widget child})
      : assert(tertiary != null),
        super(child: child);

  final Color tertiary;

  factory HpiTheme.of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(HpiTheme) as HpiTheme;

  @override
  bool updateShouldNotify(HpiTheme oldWidget) {
    return tertiary != oldWidget.tertiary;
  }
}

import 'package:meta/meta.dart';

@immutable
class Routes {
  final String _name;

  const Routes._internal(this._name);
  factory Routes.fromString(String name) =>
      values.firstWhere((route) => route.name == name);

  toString() => 'Routes.$_name';

  static const dashboard = const Routes._internal('/');
  static const news = const Routes._internal('/news');

  static List<Routes> get values => [dashboard, news];
  String get name => _name;
}

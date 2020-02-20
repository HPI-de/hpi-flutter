import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/hpi_theme.dart';

final services = GetIt.instance;
SharedPreferences get sharedPreferences => services.get<SharedPreferences>();

extension FancyContext on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  TextDirection get directionality => Directionality.of(this);
  ScaffoldState get scaffold => Scaffold.of(this);
  DefaultTextStyle get defaultTextStyle => DefaultTextStyle.of(this);
  ThemeData get theme => Theme.of(this);
  HpiTheme get hpiTheme => HpiTheme.of(this);
  NavigatorState get navigator => Navigator.of(this);
  NavigatorState get rootNavigator => Navigator.of(this, rootNavigator: true);
  PageStorageBucket get pageStorage => PageStorage.of(this);
}

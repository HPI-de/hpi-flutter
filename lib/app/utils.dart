import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final services = GetIt.instance;
SharedPreferences get sharedPreferences => services.get<SharedPreferences>();

import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:hpi_flutter/crashreporting/data/crashreporting.dart';
import 'package:kt_dart/kt.dart';
import 'package:package_info/package_info.dart';

import 'data/bloc.dart';

bool get isInDebugMode {
  // Assume you're in production mode.
  bool inDebugMode = false;
  // Assert expressions are only evaluated during development.
  assert(inDebugMode = true);
  return inDebugMode;
}

Future<void> reportError(
    dynamic error, StackTrace stackTrace, Uri serverUrl) async {
  print('Caught error: $error');
  if (isInDebugMode) {
    print(stackTrace);
  } else {
    final platformInfo = await getDeviceAndOS();
    String log;
    try {
      log = await MethodChannel('feedback').invokeMethod('getLog');
    } on PlatformException catch (e) {
      log = 'Error getting log: ${e.message}';
    }
    final packageInfo = await PackageInfo.fromPlatform();
    final crashReport = CrashReport(
      id: '',
      appName: packageInfo.packageName,
      appVersion: packageInfo.version,
      appVersionCode: int.tryParse(packageInfo.buildNumber),
      device: platformInfo.first,
      operatingSystem: platformInfo.second,
      timestamp: DateTime.now(),
      exception: error.toString(),
      stackTrace: stackTrace.toString(),
      log: log,
    );
    CrashReportingBloc(serverUrl).createCrashReport(crashReport);
  }
}

Future<KtPair<Device, OperatingSystem>> getDeviceAndOS() async {
  if (Platform.isAndroid) {
    var deviceInfo = await DeviceInfoPlugin().androidInfo;
    return KtPair(
      Device(
        brand: deviceInfo.brand,
        model: deviceInfo.model,
      ),
      OperatingSystem(
          os: Platform.operatingSystem, version: deviceInfo.version.release),
    );
  } else if (Platform.isIOS) {
    var deviceInfo = await DeviceInfoPlugin().iosInfo;
    return KtPair(
      Device(
        brand: 'Apple',
        model: deviceInfo.model,
      ),
      OperatingSystem(
          os: Platform.operatingSystem, version: deviceInfo.systemVersion),
    );
  } else {
    return KtPair(
      Device(
        brand: 'Unknown',
        model: 'Unknown',
      ),
      OperatingSystem(
        os: Platform.operatingSystem,
        version: Platform.operatingSystemVersion,
      ),
    );
  }
}

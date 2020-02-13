import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hpi_flutter/app/app.dart';
import 'package:kt_dart/kt.dart';
import 'package:package_info/package_info.dart';

import 'bloc.dart';
import 'data.dart';

Future<void> runWithCrashReporting(Future<void> Function() body) async {
  // This captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (isInDebugMode) {
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode report to the application zone.
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  // run in custom zone for catching errors
  await runZoned<Future<void>>(
    body,
    onError: (error, StackTrace stackTrace) async {
      await reportError(error, stackTrace);
    },
  );
}

bool get isInDebugMode {
  // Assume you're in production mode.
  bool inDebugMode = false;
  // Assert expressions are only evaluated during development.
  assert(inDebugMode = true);
  return inDebugMode;
}

Future<void> reportError(dynamic error, StackTrace stackTrace) async {
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
    services.get<CrashReportingBloc>().createCrashReport(crashReport);
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

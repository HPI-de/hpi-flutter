import 'package:hpi_flutter/core/core.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/crashreporting/v1test/crashreport.pb.dart'
    as proto;
import 'package:meta/meta.dart';

@immutable
class CrashReport {
  final String id;
  final String appName;
  final String appVersion;
  final int appVersionCode;
  final Device device;
  final OperatingSystem operatingSystem;
  final DateTime timestamp;
  final String exception;
  final String stackTrace;
  final String log;

  CrashReport({
    this.id,
    @required this.appName,
    @required this.appVersion,
    @required this.appVersionCode,
    this.device,
    this.operatingSystem,
    @required this.timestamp,
    @required this.exception,
    @required this.stackTrace,
    @required this.log,
  })  : assert(appName != null),
        assert(appVersion != null),
        assert(appVersionCode != null),
        assert(timestamp != null),
        assert(exception != null),
        assert(stackTrace != null),
        assert(log != null);

  CrashReport.fromProto(proto.CrashReport crashReport)
      : this(
          id: crashReport.id,
          appName: crashReport.appName,
          appVersion: crashReport.appVersion,
          appVersionCode: crashReport.appVersionCode,
          device: Device.fromProto(crashReport.device),
          operatingSystem:
              OperatingSystem.fromProto(crashReport.operatingSystem),
          timestamp: timestampToDateTime(crashReport.timestamp),
          exception: crashReport.exception,
          stackTrace: crashReport.stackTrace,
          log: crashReport.log,
        );

  proto.CrashReport toProto() {
    return proto.CrashReport()
      ..id = id
      ..appName = appName
      ..appVersion = appVersion
      ..appVersionCode = appVersionCode
      ..device = device.toProto()
      ..operatingSystem = operatingSystem.toProto()
      ..timestamp = dateTimeToTimestamp(timestamp)
      ..exception = exception
      ..stackTrace = stackTrace
      ..log = log;
  }
}

@immutable
class Device {
  final String brand;
  final String model;

  Device({
    @required this.brand,
    @required this.model,
  })  : assert(brand != null),
        assert(model != null);

  Device.fromProto(proto.CrashReport_Device device)
      : this(brand: device.brand, model: device.model);

  proto.CrashReport_Device toProto() {
    return proto.CrashReport_Device()
      ..brand = brand
      ..model = model;
  }
}

@immutable
class OperatingSystem {
  final String os;
  final String version;

  OperatingSystem({
    @required this.os,
    @required this.version,
  })  : assert(os != null),
        assert(version != null);

  OperatingSystem.fromProto(proto.CrashReport_OperatingSystem operatingSystem)
      : this(os: operatingSystem.os, version: operatingSystem.version);

  proto.CrashReport_OperatingSystem toProto() {
    return proto.CrashReport_OperatingSystem()
      ..os = os
      ..version = version;
  }
}

import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'package:hpi_flutter/crashreporting/data/crashreporting.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/crashreporting/v1test/service.pbgrpc.dart';

@immutable
class CrashReportingBloc {
  CrashReportingBloc(Uri serverUrl)
      : assert(serverUrl != null),
        _client = CrashReportingServiceClient(
          ClientChannel(
            serverUrl.toString(),
            port: 50066,
            options: ChannelOptions(
              credentials: ChannelCredentials.insecure(),
            ),
          ),
        );

  final CrashReportingServiceClient _client;

  Stream<CrashReport> createCrashReport(CrashReport crashReport) {
    var request = CreateCrashReportRequest()
      ..crashReport = crashReport.toProto();
    return Stream.fromFuture(_client.createCrashReport(request))
        .map((r) => CrashReport.fromProto(r));
  }
}

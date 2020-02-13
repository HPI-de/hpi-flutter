import 'package:grpc/grpc.dart';
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/crashreporting/v1test/service.pbgrpc.dart';
import 'package:meta/meta.dart';

import 'data.dart';

@immutable
class CrashReportingBloc {
  CrashReportingBloc()
      : _client = CrashReportingServiceClient(
          ClientChannel(
            services.get<Uri>().toString(),
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

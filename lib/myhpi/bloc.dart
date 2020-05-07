import 'package:grpc/grpc.dart';
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/core/core.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/myhpi/v1test/myhpi_service.pbgrpc.dart';

import 'data.dart';

class MyHpiBloc {
  MyHpiBloc()
      : _client = MyHpiServiceClient(
          ClientChannel(
            services.get<Uri>().toString(),
            port: 50063,
            options: ChannelOptions(
              credentials: ChannelCredentials.insecure(),
            ),
          ),
          options: createCallOptions(),
        );

  final MyHpiServiceClient _client;

  Stream<PaginationResponse<InfoBit>> getInfoBits({
    String parentId,
    int pageSize,
    String pageToken,
  }) {
    final request = ListInfoBitsRequest()
      ..parentId = parentId ?? ''
      ..pageSize = pageSize ?? 0
      ..pageToken = pageToken ?? '';
    return Stream.fromFuture(_client.listInfoBits(request))
        .map((r) => PaginationResponse(
              r.infoBits.map((a) => InfoBit.fromProto(a)).toList(),
              r.nextPageToken,
            ));
  }

  Stream<InfoBit> getInfoBit(String id) {
    assert(id != null);
    return Stream.fromFuture(_client.getInfoBit(GetInfoBitRequest()..id = id))
        .map((i) => InfoBit.fromProto(i));
  }

  Stream<InfoBitTag> getTag(String id) {
    assert(id != null);
    return Stream.fromFuture(
            _client.getInfoBitTag(GetInfoBitTagRequest()..id = id))
        .map((a) => InfoBitTag.fromProto(a));
  }

  Stream<Action> getAction(String id) {
    assert(id != null);
    return Stream.fromFuture(_client.getAction(GetActionRequest()..id = id))
        .map((a) => Action.fromProto(a));
  }
}

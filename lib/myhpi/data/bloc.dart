import 'dart:ui';

import 'package:grpc/grpc.dart';
import 'package:hpi_flutter/core/data/utils.dart';
import 'package:hpi_flutter/core/widgets/pagination.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/myhpi/v1test/myhpi_service.pbgrpc.dart';
import 'package:hpi_flutter/myhpi/data/infobit.dart';
import 'package:kt_dart/collection.dart';

class MyHpiBloc {
  MyHpiBloc(Uri serverUrl, Locale locale)
      : assert(serverUrl != null),
        assert(locale != null),
        _client = MyHpiServiceClient(
          ClientChannel(
            serverUrl.toString(),
            port: 50063,
            options: ChannelOptions(
              credentials: ChannelCredentials.insecure(),
            ),
          ),
          options: createCallOptions(locale),
        );

  final MyHpiServiceClient _client;

  Future<PaginationResponse<InfoBit>> getInfoBits({
    String parentId,
    int pageSize,
    String pageToken,
  }) async {
    final request = ListInfoBitsRequest()
      ..parentId = parentId ?? ''
      ..pageSize = pageSize ?? 0
      ..pageToken = pageToken ?? '';
    final response = await _client.listInfoBits(request);

    return PaginationResponse(
      KtList.from(response.infoBits).map((a) => InfoBit.fromProto(a)),
      response.nextPageToken,
    );
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

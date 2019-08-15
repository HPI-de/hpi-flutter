import 'package:grpc/grpc.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/myhpi/v1test/myhpi_service.pbgrpc.dart';
import 'package:hpi_flutter/myhpi/data/infobit.dart';
import 'package:kt_dart/collection.dart';

class MyHpiBloc {
  MyHpiBloc(Uri serverUrl)
      : assert(serverUrl != null),
        _client = MyHpiServiceClient(
          ClientChannel(
            serverUrl.toString(),
            port: 50063,
            options: ChannelOptions(
              credentials: ChannelCredentials.insecure(),
            ),
          ),
        );

  final MyHpiServiceClient _client;

  Stream<KtList<InfoBit>> getInfoBits() {
    return Stream.fromFuture(_client.listInfoBits(ListInfoBitsRequest()))
        .map((r) => KtList.from(r.infoBits).map((i) => InfoBit.fromProto(i)));
  }

  Stream<InfoBit> getInfoBit(String id) {
    assert(id != null);
    return Stream.fromFuture(_client.getInfoBit(GetInfoBitRequest()..id = id))
        .map((i) => InfoBit.fromProto(i));
  }

  Stream<Action> getAction(String id) {
    assert(id != null);
    return Stream.fromFuture(_client.getAction(GetActionRequest()..id = id))
        .map((a) => Action.fromProto(a));
  }
}

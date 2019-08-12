import 'package:grpc/grpc.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/myhpi/v1test/info_bit.pb.dart'
    as prefix0;
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/myhpi/v1test/myhpi_service.pbgrpc.dart';
import 'package:hpi_flutter/myhpi/data/infobit.dart';
import 'package:kt_dart/collection.dart';

class MyHPIBloc {
  final MyHpiServiceClient _client;

  MyHPIBloc(ClientChannel channel)
      : assert(channel != null),
        _client = MyHpiServiceClient(channel);

  Stream<KtList<InfoBit>> getInfoBits() {
    return Stream.fromFuture(_client.listInfoBits(ListInfoBitsRequest()))
        .map((r) => KtList.from(r.infoBits).map((i) => InfoBit.fromProto(i)));
  }

  Stream<InfoBit> getInfoBit(String id) {
    return Stream.fromFuture(_client.getInfoBit(GetInfoBitRequest()..id = id))
        .map((i) => InfoBit.fromProto(i));
  }

  Stream<Action> getAction(String id) {
    return Stream.fromFuture(_client.getAction(GetActionRequest()..id = id))
        .map((a) {
      switch (a.whichType()) {
        case prefix0.Action_Type.text:
          return ActionText.fromProto(a);
        case prefix0.Action_Type.link:
          return ActionLink.fromProto(a);
        case prefix0.Action_Type.notSet:
          throw Error();
      }
    });
  }
}

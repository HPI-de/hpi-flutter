import 'package:fixnum/fixnum.dart';
import 'package:hpi_flutter/hpi_cloud_apis/google/protobuf/timestamp.pb.dart';

const int secondToMillis = 1000;
const int secondToMicros = secondToMillis * milliToMicros;
const int milliToMicros = 1000;
const int microToNanos = 1000;

DateTime timestampToDateTime(Timestamp timestamp) {
  return DateTime.fromMicrosecondsSinceEpoch(
    timestamp.seconds.toInt() * secondToMicros + timestamp.nanos ~/ microToNanos,
    isUtc: true,
  );
}

Timestamp dateTimeToTimestamp(DateTime dateTime) {
  DateTime utc = dateTime.toUtc();
  return Timestamp()
    ..seconds = Int64(utc.millisecondsSinceEpoch ~/ secondToMillis)
    ..nanos = utc.microsecondsSinceEpoch % secondToMicros;
}

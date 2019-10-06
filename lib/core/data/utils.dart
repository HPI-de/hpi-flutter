import 'package:fixnum/fixnum.dart';
import 'package:hpi_flutter/hpi_cloud_apis/google/protobuf/timestamp.pb.dart';
import 'package:hpi_flutter/hpi_cloud_apis/google/type/date.pb.dart';
import 'package:hpi_flutter/hpi_cloud_apis/google/type/money.pb.dart';

const int secondToMillis = 1000;
const int secondToMicros = secondToMillis * milliToMicros;
const int milliToMicros = 1000;
const int microToNanos = 1000;

DateTime timestampToDateTime(Timestamp timestamp) {
  return DateTime.fromMicrosecondsSinceEpoch(
    timestamp.seconds.toInt() * secondToMicros +
        timestamp.nanos ~/ microToNanos,
    isUtc: true,
  );
}

Timestamp dateTimeToTimestamp(DateTime dateTime) {
  DateTime utc = dateTime.toUtc();
  return Timestamp()
    ..seconds = Int64(utc.millisecondsSinceEpoch ~/ secondToMillis)
    ..nanos = utc.microsecondsSinceEpoch % secondToMicros;
}

DateTime dateToDateTime(Date date) {
  return DateTime(date.year, date.month, date.day);
}

Date dateTimeToDate(DateTime dateTime) {
  return Date()
    ..year = dateTime.year
    ..month = dateTime.month
    ..day = dateTime.day;
}

double moneyToDouble(Money money) {
  return money.units.toDouble() + (money.nanos / 1000000000.0);
}

Money doubleToMoney(double doubleValue) {
  return Money()
    ..currencyCode = 'EUR'
    ..nanos = (doubleValue * 1000000000).round();
}

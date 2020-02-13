import 'dart:ui';

import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/hpi_cloud_apis/google/protobuf/timestamp.pb.dart';
import 'package:hpi_flutter/hpi_cloud_apis/google/type/date.pb.dart';
import 'package:hpi_flutter/hpi_cloud_apis/google/type/money.pb.dart';
import 'package:time_machine/time_machine.dart';

const int secondToMillis = 1000;
const int secondToMicros = secondToMillis * milliToMicros;
const int milliToMicros = 1000;
const int microToNanos = 1000;

extension InstantToProtobuf on Instant {
  Timestamp toTimestamp() {
    return Timestamp()
      ..seconds = Int64(epochSeconds)
      ..nanos = timeSinceEpoch.millisecondOfSecond;
  }
}

extension TimestampToTimeMachine on Timestamp {
  Instant toInstant() =>
      Instant.epochTime(Time(seconds: seconds.toInt(), nanoseconds: nanos));
}

extension LocalDateToProtobuf on LocalDate {
  Date toDate() {
    return Date()
      ..year = year
      ..month = monthOfYear
      ..day = dayOfMonth;
  }
}

extension DateToTimeMachine on Date {
  LocalDate toLocalDate() => LocalDate(year, month, day);
}

double moneyToDouble(Money money) {
  return money.units.toDouble() + (money.nanos / 1000000000.0);
}

Money doubleToMoney(double doubleValue) {
  return Money()
    ..currencyCode = 'EUR'
    ..nanos = (doubleValue * 1000000000).round();
}

CallOptions createCallOptions() {
  return CallOptions(
    metadata: {'Accept-Language': services.get<Locale>().toLanguageTag()},
  );
}

import 'package:kt_dart/collection.dart';

bool isNullOrBlank(String string) {
  return string == null || string.trim().isEmpty;
}

KtList<T> toKtList<T>(Iterable<T> iterable) => KtList.from(iterable);

KtList<T> valuesToKtList<T>(Map<dynamic, T> map) => KtList.from(map.values);

import 'package:kt_dart/collection.dart';
import 'package:url_launcher/url_launcher.dart';

bool isNullOrBlank(String string) {
  return string == null || string.trim().isEmpty;
}

KtList<T> toKtList<T>(Iterable<T> iterable) => KtList.from(iterable);

KtList<T> valuesToKtList<T>(Map<dynamic, T> map) => KtList.from(map.values);

String enumToString(Object enumValue) {
  if (enumValue == null) return null;

  final string = enumValue.toString();
  return string.substring(string.indexOf('.') + 1);
}

E stringToEnum<E>(String value, List<E> enumValues) {
  if (value == null) return null;
  assert(enumValues != null);

  return enumValues.firstWhere(
    (v) => enumToString(v) == value,
    orElse: () => null,
  );
}

Future<bool> tryLaunch(String urlString) async {
  if (await canLaunch(urlString)) return launch(urlString);
  return false;
}

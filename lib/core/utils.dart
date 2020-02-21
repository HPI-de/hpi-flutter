import 'package:url_launcher/url_launcher.dart';

bool isNullOrBlank(String string) {
  return string == null || string.trim().isEmpty;
}

String enumToString(Object enumValue) {
  if (enumValue == null) {
    return null;
  }

  final string = enumValue.toString();
  return string.substring(string.indexOf('.') + 1);
}

E stringToEnum<E>(String value, List<E> enumValues) {
  if (value == null) {
    return null;
  }
  assert(enumValues != null);

  return enumValues.firstWhere(
    (v) => enumToString(v) == value,
    orElse: () => null,
  );
}

Future<bool> tryLaunch(String urlString) async {
  if (await canLaunch(urlString)) {
    return launch(urlString);
  }
  return false;
}

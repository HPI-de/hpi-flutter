import 'package:flutter/widgets.dart';
import 'package:hpi_flutter/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

extension ContextWithLocalization on BuildContext {
  S get s => S.of(this);
}

bool isNullOrBlank(String string) {
  return string == null || string.trim().isEmpty;
}

Future<bool> tryLaunch(String urlString) async {
  if (await canLaunch(urlString)) {
    return launch(urlString);
  }
  return false;
}

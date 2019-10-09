import 'package:flutter/widgets.dart';

import '../localizations.dart';

String getLanguage(BuildContext context, String abbreviation) {
  assert(context != null);
  assert(abbreviation != null);

  return HpiL11n.get(context, 'language.${abbreviation.toLowerCase()}');
}

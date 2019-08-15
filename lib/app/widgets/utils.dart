import 'package:flutter/widgets.dart';

Widget buildAppBarTitle({@required Widget title, Widget subtitle}) {
  assert(title != null);

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      title,
      subtitle,
    ],
  );
}

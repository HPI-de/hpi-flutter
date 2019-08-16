import 'package:flutter/material.dart';

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

Widget buildLoadingErrorSliver(AsyncSnapshot<dynamic> snapshot) {
  return SliverFillRemaining(
    child: Center(
      child: snapshot.hasError
          ? Text(snapshot.error.toString())
          : CircularProgressIndicator(),
    ),
  );
}

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

Widget buildLoadingErrorScaffold(
    BuildContext context, AsyncSnapshot<dynamic> snapshot,
    {bool appBarElevated = false, String loadingTitle = 'Loading…'}) {
  assert(context != null);
  assert(snapshot != null);
  assert(appBarElevated != null);
  assert(loadingTitle != null);

  return Scaffold(
    appBar: AppBar(
      elevation: appBarElevated ? null : 0,
      backgroundColor: appBarElevated ? Theme.of(context).cardColor : null,
      title: Text(snapshot.hasError ? 'Error' : loadingTitle),
    ),
    body: Center(
      child: snapshot.hasError
          ? Text(snapshot.error.toString())
          : CircularProgressIndicator(),
    ),
  );
}

Widget buildLoadingErrorSliver(AsyncSnapshot<dynamic> snapshot) {
  assert(snapshot != null);

  return SliverFillRemaining(
    child: Center(
      child: snapshot.hasError
          ? Text(snapshot.error.toString())
          : CircularProgressIndicator(),
    ),
  );
}

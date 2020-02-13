import 'package:flutter/material.dart';
import 'package:hpi_flutter/core/core.dart';

Widget buildAppBarTitle({
  @required BuildContext context,
  @required Widget title,
  Widget subtitle,
}) {
  assert(context != null);
  assert(title != null);

  if (subtitle == null) return title;

  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      DefaultTextStyle(
        style: Theme.of(context).textTheme.title.copyWith(
              color: Colors.black87,
            ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        child: title,
      ),
      DefaultTextStyle(
        style: Theme.of(context).textTheme.subhead,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        child: subtitle,
      ),
    ],
  );
}

Widget buildLoadingError(AsyncSnapshot<dynamic> snapshot) {
  assert(snapshot != null);

  return Center(
    child: snapshot.hasError
        ? Text(snapshot.error.toString())
        : CircularProgressIndicator(),
  );
}

Widget buildLoadingErrorScaffold(
  BuildContext context,
  AsyncSnapshot<dynamic> snapshot, {
  bool appBarElevated = false,
  String loadingTitle,
}) {
  assert(context != null);
  assert(snapshot != null);
  assert(appBarElevated != null);

  return Scaffold(
    appBar: AppBar(
      elevation: appBarElevated ? null : 0,
      backgroundColor: appBarElevated ? Theme.of(context).cardColor : null,
      title: Text(snapshot.hasError
          ? HpiL11n.get(context, 'error')
          : (loadingTitle ?? HpiL11n.get(context, 'loading'))),
    ),
    body: buildLoadingError(snapshot),
  );
}

Widget buildLoadingErrorSliver(AsyncSnapshot<dynamic> snapshot) {
  assert(snapshot != null);

  return SliverFillRemaining(
    child: buildLoadingError(snapshot),
  );
}

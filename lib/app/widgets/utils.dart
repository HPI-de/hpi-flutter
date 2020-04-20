import 'package:flutter/material.dart';
import 'package:hpi_flutter/core/core.dart';

import '../utils.dart';

Widget buildAppBarTitle({
  @required BuildContext context,
  @required Widget title,
  Widget subtitle,
}) {
  assert(context != null);
  assert(title != null);

  if (subtitle == null) {
    return title;
  }

  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      DefaultTextStyle(
        style: context.theme.textTheme.title.copyWith(
          color: Colors.black87,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        child: title,
      ),
      DefaultTextStyle(
        style: context.theme.textTheme.subhead,
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

  final s = context.s;
  return Scaffold(
    appBar: AppBar(
      elevation: appBarElevated ? null : 0,
      backgroundColor: appBarElevated ? context.theme.cardColor : null,
      title: Text(snapshot.hasError
          ? s.general_error
          : loadingTitle ?? s.general_loading),
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

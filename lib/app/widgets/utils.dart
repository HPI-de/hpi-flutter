import 'package:flutter/material.dart';
import 'package:hpi_flutter/core/localizations.dart';

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

  return snapshot.hasError
      ? buildError(null, snapshot.hasError)
      : Center(child: CircularProgressIndicator());
}

/// Builds a widget that shows an error to the user.
// The BuildContext is not really needed, but its a good pratice to pass it to
// build functions. This also allows us to directly pass in the function into
// widgets that accept builder functions, like the [CachedBuilder]:
//
// ```dart
// CachedBuilder(
//   controller: ...,
//   errorScreenBuilder: buildError,
//   errorBannerBuilder: buildError,
//   ...
// ),
// ```
Widget buildError(BuildContext _, dynamic error) =>
    Center(child: Text('$error'));

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

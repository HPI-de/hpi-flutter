import 'package:flutter/material.dart';

import '../localizations.dart';

@immutable
class StreamChip<T> extends StatelessWidget {
  const StreamChip({
    Key key,
    this.loadingLabel,
    @required this.stream,
    @required this.labelBuilder,
  })  : assert(stream != null),
        assert(labelBuilder != null),
        super(key: key);

  final Widget loadingLabel;
  final Stream<T> stream;
  final Widget Function(T) labelBuilder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) return Container();

        return Chip(
          label: snapshot.hasData
              ? labelBuilder(snapshot.data)
              : (loadingLabel ?? Text(HpiL11n.get(context, 'loading'))),
        );
      },
    );
  }
}

@immutable
class StreamActionChip<T> extends StatelessWidget {
  const StreamActionChip({
    Key key,
    this.loadingLabel,
    @required this.stream,
    @required this.labelBuilder,
    @required this.onPressed,
  })  : assert(stream != null),
        assert(labelBuilder != null),
        assert(onPressed != null),
        super(key: key);

  final Widget loadingLabel;
  final Stream<T> stream;
  final Widget Function(T) labelBuilder;
  final void Function(T) onPressed;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) return Container();

        return ActionChip(
          label: snapshot.hasData
              ? labelBuilder(snapshot.data)
              : (loadingLabel ?? Text(HpiL11n.get(context, 'loading'))),
          onPressed: () => onPressed(snapshot.data),
        );
      },
    );
  }
}

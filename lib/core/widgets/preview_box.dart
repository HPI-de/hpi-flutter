import 'package:flutter/material.dart';

@immutable
class PreviewBox extends StatelessWidget {
  const PreviewBox({
    @required this.background,
    @required this.title,
    @required this.caption,
    @required this.onTap,
  })  : assert(background != null),
        assert(title != null),
        assert(caption != null),
        assert(onTap != null);

  final Widget background;
  final Widget title;
  final Widget caption;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 16 / 9,
          child: background,
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black45],
            )),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                child: _buildOverlayContent(context),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    assert(context != null);

    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DefaultTextStyle(
            style:
                Theme.of(context).textTheme.body1.copyWith(color: Colors.white),
            maxLines: 3,
            child: title,
          ),
          DefaultTextStyle(
            style: Theme.of(context)
                .textTheme
                .caption
                .copyWith(color: Colors.white),
            maxLines: 1,
            child: caption,
          ),
        ],
      ),
    );
  }
}

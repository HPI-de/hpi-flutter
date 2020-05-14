import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/material.dart';

import 'scrim_around.dart';

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
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: ScrimAround(
                brightness: Brightness.dark,
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
            style: context.textTheme.bodyText2.copyWith(color: Colors.white),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            child: title,
          ),
          DefaultTextStyle(
            style: context.textTheme.caption.copyWith(color: Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            child: caption,
          ),
        ],
      ),
    );
  }
}

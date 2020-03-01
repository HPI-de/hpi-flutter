import 'package:flutter/material.dart';
import 'package:hpi_flutter/app/app.dart';

class ChipGroup extends StatelessWidget {
  const ChipGroup({
    this.title,
    @required this.children,
    this.leading,
  }) : assert(children != null);

  final Widget title;
  final Widget leading;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    Widget child = Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: <Widget>[
        if (leading != null && children.isNotEmpty) leading,
        ...children,
      ],
    );

    if (title != null && children.isNotEmpty) {
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DefaultTextStyle(
            style: context.theme.textTheme.overline,
            child: title,
          ),
          child,
        ],
      );
    }

    return child;
  }
}

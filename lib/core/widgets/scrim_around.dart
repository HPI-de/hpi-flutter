import 'package:flutter/material.dart';

class ScrimAround extends StatelessWidget {
  const ScrimAround({
    Key key,
    this.brightness = Brightness.light,
    this.child,
  })  : assert(brightness != null),
        super(key: key);

  final Brightness brightness;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: DecoratedBox(
            decoration: simpleBottomScrim(brightness),
            child: SizedBox(width: double.infinity,),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: scrimColor(brightness),
          ),
          child: child,
        ),
      ],
    );
  }

  static BoxDecoration simpleBottomScrim(Brightness brightness) {
    assert(brightness != null);

    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.transparent, scrimColor(brightness)],
      ),
    );
  }

  static Color scrimColor(Brightness brightness) {
    assert(brightness != null);

    return brightness == Brightness.dark
        ? Colors.black.withOpacity(0.5)
        : Colors.white.withOpacity(0.5);
  }
}

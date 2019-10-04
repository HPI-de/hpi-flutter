import 'package:flutter/widgets.dart';

@immutable
class ChipGroup extends StatelessWidget {
  const ChipGroup({@required this.children}) : assert(children != null);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: children,
    );
  }
}

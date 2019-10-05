import 'package:flutter/material.dart';
import 'package:hpi_flutter/core/localizations.dart';
import 'package:kt_dart/collection.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

@immutable
class AboutMyself extends StatefulWidget {
  @override
  _AboutMyselfState createState() => _AboutMyselfState();
}

class _AboutMyselfState extends State<AboutMyself> {
  KtList<DropdownMenuItem<Role>> _roleValues;
  Role _role = Role.student;

  KtList<DropdownMenuItem<CourseOfStudies>> _courseOfStudiesValues;
  CourseOfStudies _courseOfStudies = CourseOfStudies.baItse;

  int _semester = 1;

  int get _defaultSemesterCount =>
      _courseOfStudies == CourseOfStudies.baItse ? 6 : 4;

  @override
  Widget build(BuildContext context) {
    final l11n = HpiL11n.of(context);
    _roleValues ??= KtList.from(Role.values).map((r) => DropdownMenuItem(
          value: r,
          child: Text(l11n('onboarding/role.${enumToKey(r)}')),
        ));
    _courseOfStudiesValues ??=
        KtList.from(CourseOfStudies.values).map((c) => DropdownMenuItem(
              value: c,
              child: Text(l11n('onboarding/courseOfStudies.${enumToKey(c)}')),
            ));

    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline.copyWith(
            fontSize: 30,
            height: 1.4,
            color: Colors.white,
          ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: l11n('onboarding/aboutMyself.text.1')),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: _InlineDropdownButton<Role>(
                items: _roleValues,
                value: _role,
                onChanged: (r) => setState(() {
                  _role = r;
                }),
              ),
            ),
            if (_role == Role.student) ...[
              TextSpan(text: l11n('onboarding/aboutMyself.text.2')),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: _InlineDropdownButton<CourseOfStudies>(
                  items: _courseOfStudiesValues,
                  value: _courseOfStudies,
                  onChanged: (c) => setState(() {
                    _courseOfStudies = c;
                  }),
                ),
              ),
              TextSpan(text: l11n('onboarding/aboutMyself.text.3')),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: _InlineDropdownButton<int>(
                  items: KtList.from(
                    List.generate(
                      _defaultSemesterCount * 2,
                      (s) => DropdownMenuItem(
                        value: s + 1,
                        child: Text(
                          l11n('onboarding/aboutMyself.text.4', args: [s + 1]),
                        ),
                      ),
                    ),
                  ),
                  value: _semester,
                  onChanged: (s) => setState(() {
                    _semester = s;
                  }),
                ),
              ),
              TextSpan(text: l11n('onboarding/aboutMyself.text.5')),
            ],
            TextSpan(text: l11n('onboarding/aboutMyself.text.6')),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

enum Role {
  student,
  phdStudent,
  postdoc,
  prof,
  lecturer,
  staff,
}
enum CourseOfStudies {
  baItse,
  maCs,
  maDe,
  maDh,
  maItse,
}

class _InlineDropdownButton<T> extends StatelessWidget {
  const _InlineDropdownButton({
    Key key,
    @required this.items,
    this.value,
    @required this.onChanged,
  })  : assert(items != null),
        assert(onChanged != null),
        super(key: key);

  final KtList<DropdownMenuItem<T>> items;
  final T value;
  final void Function(T) onChanged;

  @override
  Widget build(BuildContext context) {
    final style = DefaultTextStyle.of(context).style;

    return DropdownButton(
      selectedItemBuilder: (context) => items
          .map((i) => DefaultTextStyle(
                style: style,
                child: i.child,
              ))
          .asList(),
      items: items
          .map((i) => DropdownMenuItem(
                key: i.key,
                value: i.value,
                child: DefaultTextStyle(
                  style: Theme.of(context).textTheme.body1,
                  child: i.child,
                ),
              ))
          .asList(),
      value: value,
      onChanged: onChanged,
      style: style,
      icon: Icon(
        OMIcons.arrowDropDown,
        color: style.color,
      ),
      underline: Container(
        height: 1,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: style.color.withOpacity(0.6),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

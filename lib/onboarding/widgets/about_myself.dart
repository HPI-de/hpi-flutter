import 'package:flutter/material.dart';
import 'package:hpi_flutter/app/widgets/utils.dart';
import 'package:hpi_flutter/core/localizations.dart';
import 'package:hpi_flutter/core/utils.dart';
import 'package:kt_dart/collection.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
class AboutMyself extends StatefulWidget {
  static const KEY_ROLE = 'role';
  static const KEY_COURSE_OF_STUDIES = 'courseOfStudies';
  static const KEY_SEMESTER = 'semester';

  const AboutMyself({
    Key key,
    this.sharedPreferencesPrefix = '',
  })  : assert(sharedPreferencesPrefix != null),
        super(key: key);

  final String sharedPreferencesPrefix;

  @override
  _AboutMyselfState createState() => _AboutMyselfState();
}

class _AboutMyselfState extends State<AboutMyself> {
  HpiL11n _l11n;

  KtList<DropdownMenuItem<Role>> _roleValues;
  KtList<DropdownMenuItem<CourseOfStudies>> _courseOfStudiesValues;

  void didChangeDependencies() {
    super.didChangeDependencies();

    _l11n = HpiL11n.of(context);
    _roleValues = KtList.from(Role.values).map((r) => DropdownMenuItem(
          value: r,
          child: Text(_l11n('onboarding/role.${enumToKey(r)}')),
        ));
    _courseOfStudiesValues =
        KtList.from(CourseOfStudies.values).map((c) => DropdownMenuItem(
              value: c,
              child: Text(_l11n('onboarding/courseOfStudies.${enumToKey(c)}')),
            ));
  }

  @override
  Widget build(BuildContext context) {
    final role =
        _getEnum(context, AboutMyself.KEY_ROLE, Role.values) ?? Role.student;
    final courseOfStudies = _getEnum(context, AboutMyself.KEY_COURSE_OF_STUDIES,
            CourseOfStudies.values) ??
        CourseOfStudies.baItse;
    final semester = _getInt(context, AboutMyself.KEY_SEMESTER) ?? 1;

    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline.copyWith(
            fontSize: 30,
            height: 1.4,
            color: Colors.white,
          ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: _l11n('onboarding/aboutMyself.text.1')),
            _buildDropdown<Role>(
              items: _roleValues,
              value: role,
              onChanged: (r) => _setEnum(context, AboutMyself.KEY_ROLE, r),
            ),
            if (role == Role.student) ...[
              TextSpan(text: _l11n('onboarding/aboutMyself.text.2')),
              _buildDropdown<CourseOfStudies>(
                items: _courseOfStudiesValues,
                value: courseOfStudies,
                onChanged: (c) {
                  _setEnum(context, AboutMyself.KEY_COURSE_OF_STUDIES, c);
                  _setInt(context, AboutMyself.KEY_SEMESTER,
                      semester.clamp(1, _maxSemesterCount(c)));
                },
              ),
              TextSpan(text: _l11n('onboarding/aboutMyself.text.3')),
              _buildDropdown<int>(
                  items: KtList.from(
                    List.generate(
                      _maxSemesterCount(courseOfStudies),
                      (s) => DropdownMenuItem(
                        value: s + 1,
                        child: Text(
                          _l11n('onboarding/aboutMyself.text.4', args: [s + 1]),
                        ),
                      ),
                    ),
                  ),
                  value: semester,
                  onChanged: (s) =>
                      _setInt(context, AboutMyself.KEY_SEMESTER, s)),
              TextSpan(text: _l11n('onboarding/aboutMyself.text.5')),
            ],
            TextSpan(text: _l11n('onboarding/aboutMyself.text.6')),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _setEnum(BuildContext context, String key, Object value) {
    assert(context != null);
    assert(key != null);

    Provider.of<SharedPreferences>(context)
        .setString(widget.sharedPreferencesPrefix + key, enumToString(value));
  }

  E _getEnum<E>(BuildContext context, String key, List<E> enumValues) {
    assert(context != null);
    assert(key != null);
    assert(enumValues != null);

    return stringToEnum(
        Provider.of<SharedPreferences>(context)
            .getString(widget.sharedPreferencesPrefix + key),
        enumValues);
  }

  void _setInt(BuildContext context, String key, int value) {
    assert(context != null);
    assert(key != null);

    Provider.of<SharedPreferences>(context)
        .setInt(widget.sharedPreferencesPrefix + key, value);
  }

  int _getInt<E>(BuildContext context, String key) {
    assert(context != null);
    assert(key != null);

    return Provider.of<SharedPreferences>(context)
        .getInt(widget.sharedPreferencesPrefix + key);
  }

  int _maxSemesterCount(CourseOfStudies cos) {
    assert(cos != null);
    return 2 * (cos == CourseOfStudies.baItse ? 6 : 4);
  }

  InlineSpan _buildDropdown<T>({
    @required KtList<DropdownMenuItem<T>> items,
    @required T value,
    @required void Function(T) onChanged,
  }) {
    assert(items != null);
    assert(value != null);
    assert(onChanged != null);

    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: _InlineDropdownButton<T>(
        items: items,
        value: value,
        onChanged: (v) {
          if (v != value)
            setState(() {
              onChanged(v);
            });
        },
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

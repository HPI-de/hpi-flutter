import 'package:flutter/material.dart';
import 'package:hpi_flutter/core/localizations.dart';
import 'package:hpi_flutter/core/utils.dart';
import 'package:kt_dart/collection.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
class AboutMyself extends StatefulWidget {
  static const _keyRole = 'onboarding.role';
  static const _keyCourseOfStudies = 'onboarding.courseOfStudies';
  static const _keySemester = 'onboarding.semester';

  static Role getRole(SharedPreferences sharedPreferences) {
    assert(sharedPreferences != null);
    return stringToEnum(sharedPreferences.getString(_keyRole), Role.values);
  }

  static Future<bool> _setRole(
      SharedPreferences sharedPreferences, Role value) {
    assert(sharedPreferences != null);
    return sharedPreferences.setString(_keyRole, enumToString(value));
  }

  static CourseOfStudies getCourseOfStudies(
      SharedPreferences sharedPreferences) {
    assert(sharedPreferences != null);
    return stringToEnum(sharedPreferences.getString(_keyCourseOfStudies),
        CourseOfStudies.values);
  }

  static Future<bool> _setCourseOfStudies(
    SharedPreferences sharedPreferences,
    CourseOfStudies value,
  ) {
    assert(sharedPreferences != null);
    return sharedPreferences.setString(
        _keyCourseOfStudies, enumToString(value));
  }

  static int getSemester(SharedPreferences sharedPreferences) {
    assert(sharedPreferences != null);
    return sharedPreferences.getInt(_keySemester);
  }

  static Future<bool> _setSemester(
    SharedPreferences sharedPreferences,
    int value,
  ) {
    assert(sharedPreferences != null);
    return sharedPreferences.setInt(_keySemester, value);
  }

  const AboutMyself({
    Key key,
  }) : super(key: key);

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
    final sharedPreferences = Provider.of<SharedPreferences>(context);
    var role = AboutMyself.getRole(sharedPreferences);
    if (role == null) {
      role = Role.student;
      AboutMyself._setRole(sharedPreferences, role);
    }
    var courseOfStudies = AboutMyself.getCourseOfStudies(sharedPreferences);
    if (courseOfStudies == null) {
      courseOfStudies = CourseOfStudies.baItse;
      AboutMyself._setCourseOfStudies(sharedPreferences, courseOfStudies);
    }
    var semester = AboutMyself.getSemester(sharedPreferences);
    if (semester == null) {
      semester = 1;
      AboutMyself._setSemester(sharedPreferences, semester);
    }

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
              onChanged: (r) => AboutMyself._setRole(sharedPreferences, r),
            ),
            if (role == Role.student) ...[
              TextSpan(text: _l11n('onboarding/aboutMyself.text.2')),
              _buildDropdown<CourseOfStudies>(
                items: _courseOfStudiesValues,
                value: courseOfStudies,
                onChanged: (c) {
                  AboutMyself._setCourseOfStudies(sharedPreferences, c);
                  AboutMyself._setSemester(sharedPreferences,
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
                      AboutMyself._setSemester(sharedPreferences, s)),
              TextSpan(text: _l11n('onboarding/aboutMyself.text.5')),
            ],
            TextSpan(text: _l11n('onboarding/aboutMyself.text.6')),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
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

import 'package:flutter/material.dart';
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/core/core.dart';

import 'package:outline_material_icons/outline_material_icons.dart';

class AboutMyself extends StatefulWidget {
  const AboutMyself({
    Key key,
  }) : super(key: key);

  static const _keyRole = 'onboarding.role';
  static const _keyCourseOfStudies = 'onboarding.courseOfStudies';
  static const _keySemester = 'onboarding.semester';

  static Role get role =>
      stringToEnum(sharedPreferences.getString(_keyRole), Role.values);

  static Future<bool> _setRole(Role value) {
    return sharedPreferences.setString(_keyRole, enumToString(value));
  }

  static CourseOfStudies get courseOfStudies => stringToEnum(
      sharedPreferences.getString(_keyCourseOfStudies), CourseOfStudies.values);

  static Future<bool> _setCourseOfStudies(CourseOfStudies value) {
    return sharedPreferences.setString(
        _keyCourseOfStudies, enumToString(value));
  }

  static int get semester => sharedPreferences.getInt(_keySemester);

  static Future<bool> _setSemester(int value) {
    return sharedPreferences.setInt(_keySemester, value);
  }

  @override
  _AboutMyselfState createState() => _AboutMyselfState();
}

class _AboutMyselfState extends State<AboutMyself> {
  List<DropdownMenuItem<Role>> _roleValues;
  List<DropdownMenuItem<CourseOfStudies>> _courseOfStudiesValues;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final s = context.s;
    _roleValues = [
      for (final role in Role.values)
        DropdownMenuItem(
          value: role,
          child: Text(s.onboarding_role(role)),
        ),
    ];
    _courseOfStudiesValues = [
      for (final courseOfStudies in CourseOfStudies.values)
        DropdownMenuItem(
          value: courseOfStudies,
          child: Text(s.onboarding_courseOfStudies(courseOfStudies)),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;

    var role = AboutMyself.role;
    if (role == null) {
      role = Role.student;
      AboutMyself._setRole(role);
    }
    var courseOfStudies = AboutMyself.courseOfStudies;
    if (courseOfStudies == null) {
      courseOfStudies = CourseOfStudies.baItse;
      AboutMyself._setCourseOfStudies(courseOfStudies);
    }
    var semester = AboutMyself.semester;
    if (semester == null) {
      semester = 1;
      AboutMyself._setSemester(semester);
    }

    return DefaultTextStyle(
      style: context.textTheme.headline.copyWith(
        fontSize: 30,
        height: 1.4,
        color: Colors.white,
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: s.onboarding_aboutMyself_text_1),
            _buildDropdown<Role>(
              items: _roleValues,
              value: role,
              onChanged: AboutMyself._setRole,
            ),
            if (role == Role.student) ...[
              TextSpan(text: s.onboarding_aboutMyself_text_2),
              _buildDropdown<CourseOfStudies>(
                items: _courseOfStudiesValues,
                value: courseOfStudies,
                onChanged: (c) {
                  AboutMyself._setCourseOfStudies(c);
                  AboutMyself._setSemester(
                      semester.clamp(1, _maxSemesterCount(c)).toInt());
                },
              ),
              TextSpan(text: s.onboarding_aboutMyself_text_3),
              _buildDropdown<int>(
                  items: List.generate(
                    _maxSemesterCount(courseOfStudies),
                    (semester) => DropdownMenuItem(
                      value: semester + 1,
                      child: Text(
                        s.onboarding_aboutMyself_text_4(semester + 1),
                      ),
                    ),
                  ),
                  value: semester,
                  onChanged: AboutMyself._setSemester),
              TextSpan(text: s.onboarding_aboutMyself_text_5),
            ],
            TextSpan(text: s.onboarding_aboutMyself_text_6),
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
    @required List<DropdownMenuItem<T>> items,
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
          if (v != value) {
            setState(() {
              onChanged(v);
            });
          }
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

  final List<DropdownMenuItem<T>> items;
  final T value;
  final void Function(T) onChanged;

  @override
  Widget build(BuildContext context) {
    final style = context.defaultTextStyle.style;

    return DropdownButton(
      items: [
        for (final item in items)
          DropdownMenuItem(
            key: item.key,
            value: item.value,
            child: DefaultTextStyle(
              style: context.textTheme.body1,
              child: item.child,
            ),
          ),
      ],
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

import 'package:flutter/material.dart' hide Route;
import 'package:hpi_flutter/app/widgets/hpi_theme.dart';
import 'package:hpi_flutter/app/widgets/utils.dart';
import 'package:hpi_flutter/core/localizations.dart';
import 'package:hpi_flutter/settings/widgets/settings_page.dart';
import 'package:kt_dart/collection.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../route.dart';
import 'about_myself.dart';
import 'onboarding_pager.dart';

class OnboardingPage extends StatefulWidget {
  static const _keyCompleted = 'onboarding.completed';
  static const _keyPrivacyPolicy = 'onboarding.privacyPolicy';
  static const _keyCrashReporting = 'onboarding.crashReporting';
  static final _privacyPolicyDate = DateTime.utc(2019, 10, 01);

  static bool isOnboardingCompleted(SharedPreferences sharedPreferences) {
    assert(sharedPreferences != null);
    return sharedPreferences.getInt(_keyCompleted) != null;
  }

  static Future<bool> clearOnboardingCompleted(
    SharedPreferences sharedPreferences,
  ) async {
    assert(sharedPreferences != null);
    return sharedPreferences.remove(_keyCompleted);
  }

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingPager(
        pages: KtList.from([
          _buildStartPage(),
          _buildPrivacyPolicyPage(),
          _buildAboutMyselfPage(),
        ]),
        onFinish: () async {
          await Provider.of<SharedPreferences>(context).setInt(
              OnboardingPage._keyCompleted,
              DateTime.now().millisecondsSinceEpoch);
          Navigator.of(context).pushReplacementNamed(Route.dashboard.name);
        },
      ),
    );
  }

  Page _buildStartPage() {
    return Page(
      color: Theme.of(context).accentColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: Image.asset('assets/logo/logo_captionWhite.png'),
            ),
          ),
          SizedBox(height: 96),
          Text(
            HpiL11n.get(context, 'onboarding/start.title'),
            style: Theme.of(context).textTheme.display1.copyWith(
                  fontSize: 30,
                  color: Colors.white,
                ),
          ),
          SizedBox(height: 32),
          Text(
            HpiL11n.get(context, 'onboarding/start.subtitle'),
            style: Theme.of(context)
                .textTheme
                .subtitle
                .copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Page _buildPrivacyPolicyPage() {
    final privacyPolicyText = Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: HpiL11n.get(context, 'onboarding/privacyPolicy.prefix'),
          ),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: FlatButton(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                HpiL11n.get(context, 'settings/about.privacyPolicy'),
                style: Theme.of(context)
                    .textTheme
                    .subhead
                    .copyWith(color: HpiTheme.of(context).tertiary),
              ),
              onPressed: () {
                PrivacyPolicyPage.showBottomSheet(context);
              },
            ),
          ),
          TextSpan(
            text: HpiL11n.get(context, 'onboarding/privacyPolicy.suffix'),
          ),
        ],
      ),
      style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.white),
      textAlign: TextAlign.left,
    );

    final privacyPolicyVersion = Provider.of<SharedPreferences>(context)
        .getInt(OnboardingPage._keyPrivacyPolicy);
    final privacyPolicyAccepted = privacyPolicyVersion != null &&
        !DateTime.fromMillisecondsSinceEpoch(privacyPolicyVersion, isUtc: true)
            .isBefore(OnboardingPage._privacyPolicyDate);
    final crashReportingAccepted = Provider.of<SharedPreferences>(context)
            .getBool(OnboardingPage._keyCrashReporting) ??
        false;

    final onPrivacyPolicyChanged = (BuildContext context, [bool newValue]) {
      newValue ??= !privacyPolicyAccepted;

      PageNotification(newValue && crashReportingAccepted).dispatch(context);
      setState(() {
        Provider.of<SharedPreferences>(context).setInt(
            OnboardingPage._keyPrivacyPolicy,
            newValue
                ? OnboardingPage._privacyPolicyDate.millisecondsSinceEpoch
                : null);
      });
    };

    final onCrashReportingChanged = (BuildContext context, [bool newValue]) {
      newValue ??= !crashReportingAccepted;

      PageNotification(privacyPolicyAccepted && newValue).dispatch(context);
      setState(() {
        Provider.of<SharedPreferences>(context)
            .setBool(OnboardingPage._keyCrashReporting, newValue);
      });
    };

    return Page(
      color: Theme.of(context).primaryColor,
      canContinue: privacyPolicyAccepted && crashReportingAccepted,
      child: Builder(
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400),
              child: Image.asset('assets/images/onboarding/mrNet.png'),
            ),
            SizedBox(height: 48),
            InkWell(
              onTap: () => onPrivacyPolicyChanged(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.ideographic,
                children: <Widget>[
                  Checkbox(
                    value: privacyPolicyAccepted,
                    onChanged: (v) => onPrivacyPolicyChanged(context, v),
                    activeColor: HpiTheme.of(context).tertiary,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[privacyPolicyText],
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () => onCrashReportingChanged(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                // crossAxisAlignment: CrossAxisAlignment.center,
                // textBaseline: TextBaseline.ideographic,
                children: <Widget>[
                  Checkbox(
                    value: crashReportingAccepted,
                    onChanged: (v) => onCrashReportingChanged(context, v),
                    activeColor: HpiTheme.of(context).tertiary,
                  ),
                  HpiL11n.text(context, 'onboarding/crashReporting'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Page _buildAboutMyselfPage() {
    return Page(
      color: HpiTheme.of(context).tertiary,
      child: DefaultTextStyle(
        style: DefaultTextStyle.of(context).style,
        textAlign: TextAlign.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              HpiL11n.get(context, 'onboarding/aboutMyself.title'),
              style: Theme.of(context).textTheme.title.copyWith(
                    color: Colors.white,
                  ),
            ),
            SizedBox(height: 32),
            FutureBuilder<SharedPreferences>(
              future: SharedPreferences.getInstance(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return buildLoadingError(snapshot);

                return AboutMyself();
              },
            ),
          ],
        ),
      ),
    );
  }
}

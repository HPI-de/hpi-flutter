import 'package:flutter/material.dart' hide Page, Route;
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/core/core.dart' hide Image;
import 'package:hpi_flutter/settings/settings.dart';
import 'package:pedantic/pedantic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_machine/time_machine.dart';

import 'about_myself.dart';
import 'onboarding_pager.dart';

class OnboardingPage extends StatefulWidget {
  static const _keyCompleted = 'onboarding.completed';
  static const _keyPrivacyPolicy = 'onboarding.privacyPolicy';
  static const _keyCrashReporting = 'onboarding.crashReporting';
  static final _privacyPolicyDate =
      LocalDate(2019, 10, 01).atMidnight().inUtc().toInstant();

  static bool get isOnboardingCompleted =>
      services.get<SharedPreferences>().getInt(_keyCompleted) != null;

  static Future<bool> clearOnboardingCompleted() =>
      services.get<SharedPreferences>().remove(_keyCompleted);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingPager(
        pages: [
          _buildStartPage(),
          _buildPrivacyPolicyPage(),
          _buildAboutMyselfPage(),
        ],
        onFinish: () async {
          await services.get<SharedPreferences>().setInt(
              OnboardingPage._keyCompleted, Instant.now().epochMilliseconds);
          unawaited(
              context.navigator.pushReplacementNamed(appSchemeUrl('main')));
        },
      ),
    );
  }

  Page _buildStartPage() {
    final s = context.s;

    return Page(
      color: context.theme.accentColor,
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
            s.onboarding_start_title,
            style: context.textTheme.headline4.copyWith(
              fontSize: 30,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 32),
          Text(
            s.onboarding_start_subtitle,
            style: context.textTheme.subtitle2.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Page _buildPrivacyPolicyPage() {
    final s = context.s;

    final privacyPolicyText = Text.rich(
      TextSpan(
        children: [
          TextSpan(text: s.onboarding_privacyPolicy_prefix),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: FlatButton(
              padding: EdgeInsets.symmetric(horizontal: 8),
              onPressed: () => PrivacyPolicyPage.showBottomSheet(context),
              child: Text(
                s.settings_about_privacyPolicy,
                style: context.textTheme.subtitle1
                    .copyWith(color: context.hpiTheme.tertiary),
              ),
            ),
          ),
          TextSpan(text: s.onboarding_privacyPolicy_suffix),
        ],
      ),
      style: context.textTheme.subtitle1.copyWith(color: Colors.white),
      textAlign: TextAlign.left,
    );

    final privacyPolicyVersion = services
        .get<SharedPreferences>()
        .getInt(OnboardingPage._keyPrivacyPolicy);
    final privacyPolicyAccepted = privacyPolicyVersion != null &&
        Instant.fromEpochMilliseconds(privacyPolicyVersion) >=
            OnboardingPage._privacyPolicyDate;
    final crashReportingAccepted = services
            .get<SharedPreferences>()
            .getBool(OnboardingPage._keyCrashReporting) ??
        false;

    void onPrivacyPolicyChanged(BuildContext context, {bool newValue}) {
      newValue ??= !privacyPolicyAccepted;

      PageNotification(canContinue: newValue && crashReportingAccepted)
          .dispatch(context);
      setState(() {
        services.get<SharedPreferences>().setInt(
            OnboardingPage._keyPrivacyPolicy,
            newValue
                ? OnboardingPage._privacyPolicyDate.epochMilliseconds
                : null);
      });
    }

    void onCrashReportingChanged(BuildContext context, {bool newValue}) {
      newValue ??= !crashReportingAccepted;

      PageNotification(canContinue: privacyPolicyAccepted && newValue)
          .dispatch(context);
      setState(() {
        services
            .get<SharedPreferences>()
            .setBool(OnboardingPage._keyCrashReporting, newValue);
      });
    }

    return Page(
      color: context.theme.primaryColor,
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
                    onChanged: (v) =>
                        onPrivacyPolicyChanged(context, newValue: v),
                    activeColor: context.hpiTheme.tertiary,
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
                    onChanged: (v) =>
                        onCrashReportingChanged(context, newValue: v),
                    activeColor: context.hpiTheme.tertiary,
                  ),
                  Text(context.s.onboarding_crashReporting),
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
      color: context.hpiTheme.tertiary,
      child: DefaultTextStyle.merge(
        textAlign: TextAlign.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              context.s.onboarding_aboutMyself_title,
              style: context.textTheme.headline6.copyWith(color: Colors.white),
            ),
            SizedBox(height: 32),
            FutureBuilder<SharedPreferences>(
              future: SharedPreferences.getInstance(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return buildLoadingError(snapshot);
                }

                return AboutMyself();
              },
            ),
          ],
        ),
      ),
    );
  }
}

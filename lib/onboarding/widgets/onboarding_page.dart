import 'package:flutter/material.dart' hide Route;
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/core/core.dart' hide Image;
import 'package:hpi_flutter/settings/settings.dart';
import 'package:kt_dart/collection.dart';
import 'package:pedantic/pedantic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_machine/time_machine.dart';

import '../../route.dart';
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
        pages: KtList.from([
          _buildStartPage(),
          _buildPrivacyPolicyPage(),
          _buildAboutMyselfPage(),
        ]),
        onFinish: () async {
          await services.get<SharedPreferences>().setInt(
              OnboardingPage._keyCompleted, Instant.now().epochMilliseconds);
          unawaited(
              context.navigator.pushReplacementNamed(Route.dashboard.name));
        },
      ),
    );
  }

  Page _buildStartPage() {
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
            HpiL11n.get(context, 'onboarding/start.title'),
            style: context.theme.textTheme.display1.copyWith(
              fontSize: 30,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 32),
          Text(
            HpiL11n.get(context, 'onboarding/start.subtitle'),
            style:
                context.theme.textTheme.subtitle.copyWith(color: Colors.white),
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
              onPressed: () => PrivacyPolicyPage.showBottomSheet(context),
              child: Text(
                HpiL11n.get(context, 'settings/about.privacyPolicy'),
                style: context.theme.textTheme.subhead
                    .copyWith(color: context.hpiTheme.tertiary),
              ),
            ),
          ),
          TextSpan(
            text: HpiL11n.get(context, 'onboarding/privacyPolicy.suffix'),
          ),
        ],
      ),
      style: context.theme.textTheme.subhead.copyWith(color: Colors.white),
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
      color: context.hpiTheme.tertiary,
      child: DefaultTextStyle.merge(
        textAlign: TextAlign.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              HpiL11n.get(context, 'onboarding/aboutMyself.title'),
              style: context.theme.textTheme.title.copyWith(
                color: Colors.white,
              ),
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

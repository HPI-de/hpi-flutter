import 'package:flutter/material.dart' hide Route;
import 'package:hpi_flutter/app/widgets/hpi_theme.dart';
import 'package:hpi_flutter/app/widgets/utils.dart';
import 'package:hpi_flutter/core/localizations.dart';
import 'package:kt_dart/collection.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../route.dart';
import 'about_myself.dart';
import 'onboarding_pager.dart';

class OnboardingPage extends StatefulWidget {
  static const KEY_COMPLETED = 'onboarding.completed';
  static const KEY_PRIVACY_POLICY = 'onboarding.privacyPolicy';
  static final privacyPolicyDate = DateTime.utc(2019, 10, 01);

  static bool isOnboardingCompleted(SharedPreferences sharedPreferences) {
    assert(sharedPreferences != null);
    return sharedPreferences.getInt(KEY_COMPLETED) != null;
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
          final sp = await SharedPreferences.getInstance();
          await sp.setInt(OnboardingPage.KEY_COMPLETED,
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
          FractionallySizedBox(
            widthFactor: 0.8,
            child: Image.asset('assets/logo/logo_captionWhite.png'),
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
                'Privacy Policy',
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
    );

    final acceptedVersion = Provider.of<SharedPreferences>(context)
        .getInt(OnboardingPage.KEY_PRIVACY_POLICY);
    final accepted = acceptedVersion != null &&
        !DateTime.fromMillisecondsSinceEpoch(acceptedVersion, isUtc: true)
            .isBefore(OnboardingPage.privacyPolicyDate);

    final onChanged = (BuildContext context, [bool newValue]) {
      newValue ??= !accepted;

      PageNotification(newValue).dispatch(context);
      setState(() {
        Provider.of<SharedPreferences>(context).setInt(
            OnboardingPage.KEY_PRIVACY_POLICY,
            newValue
                ? OnboardingPage.privacyPolicyDate.millisecondsSinceEpoch
                : null);
      });
    };

    return Page(
      color: Theme.of(context).primaryColor,
      canContinue: accepted,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset('assets/images/welcome_mrNet.png'),
          SizedBox(height: 48),
          Builder(
            builder: (context) => InkWell(
              onTap: () => onChanged(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.ideographic,
                children: <Widget>[
                  Checkbox(
                    value: accepted,
                    onChanged: (v) => onChanged(context, v),
                    activeColor: HpiTheme.of(context).tertiary,
                  ),
                  privacyPolicyText,
                ],
              ),
            ),
          ),
        ],
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

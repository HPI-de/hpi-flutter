import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart' hide Route;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hpi_flutter/core/localizations.dart';
import 'package:hpi_flutter/route.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/services/navigation.dart';
import 'app/widgets/hpi_theme.dart';
import 'app/widgets/utils.dart';
import 'onboarding/widgets/onboarding_page.dart';

Future<ByteData> fetchFont(String url) async {
  final response = await http.get(url);
  if (response.statusCode == 200)
    return ByteData.view(response.bodyBytes.buffer);
  else
    throw Exception('Failed to load font');
}

void main() async {
  var delegate = HpiLocalizationsDelegate();
  var fontLoader = FontLoader('Neo Sans')
    ..addFont(fetchFont(
        'https://hpi.de/fileadmin/templates/fonts/9de9709d-f77a-44ad-96b9-6fea586f7efb.ttf'));
  await fontLoader.load();

  // Used by feedback to capture the whole app
  final screenshotController = ScreenshotController();

  runApp(
    MultiProvider(
      providers: [
        Provider<NavigationService>(
          builder: (_) => NavigationService(),
        ),
        Provider<Uri>(
          builder: (_) => Uri.parse("172.18.132.7"),
        ),
        Provider<ScreenshotController>(
          builder: (_) => screenshotController,
        ),
      ],
      child: Screenshot(
        controller: screenshotController,
        child: HpiApp(
          hpiLocalizationsDelegate: delegate,
        ),
      ),
    ),
  );
}

const _brandColorRed = 0xFFB1063A;
const _brandColorRedSwatch = MaterialColor(
  _brandColorRed,
  <int, Color>{
    50: Color(0xFFFBE2E6),
    100: Color(0xFFF6B6C1),
    200: Color(0xFFEE8799),
    300: Color(0xFFE55872),
    400: Color(0xFFDD3656),
    500: Color(0xFFD4143D),
    600: Color(0xFFC50E3C),
    700: Color(_brandColorRed),
    800: Color(0xFF9E0037),
    900: Color(0xFF7C0033),
  },
);
const _brandColorOrange = 0xFFDD6108;
const _brandColorOrangeSwatch = MaterialColor(
  _brandColorOrange,
  <int, Color>{
    50: Color(0xFFFDF4E2),
    100: Color(0xFFFBE3B6),
    200: Color(0xFFF9D186),
    300: Color(0xFFF8BE56),
    400: Color(0xFFF7B033),
    500: Color(0xFFF6A21B),
    600: Color(0xFFF29716),
    700: Color(0xFFED8711),
    800: Color(0xFFE6780D),
    900: Color(_brandColorOrange),
  },
);
const _brandColorYellow = 0xFFF6A804;

class HpiApp extends StatelessWidget {
  final HpiLocalizationsDelegate hpiLocalizationsDelegate;

  const HpiApp({@required this.hpiLocalizationsDelegate, Key key})
      : assert(hpiLocalizationsDelegate != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = ThemeData(
      primarySwatch: _brandColorRedSwatch,
      accentColor: Color(_brandColorOrange),
      fontFamily: 'Neo Sans',
    );
    theme = theme.copyWith(
      textTheme: theme.textTheme.copyWith(
          overline: theme.textTheme.overline.copyWith(
            color: Colors.black.withOpacity(0.6),
            fontWeight: FontWeight.w500,
            fontSize: 10,
            letterSpacing: 1.5,
            height: 1.6,
          ),
          headline: theme.textTheme.headline.copyWith(
            fontFamily: 'Neo Sans',
          )),
    );
    var localizedTheme = ThemeData.localize(
      theme,
      theme.typography.geometryThemeFor(ScriptCategory.englishLike),
    );
    theme = theme.copyWith(
      chipTheme: theme.chipTheme.copyWith(
        backgroundColor: Colors.transparent,
        shape: StadiumBorder(side: BorderSide(color: Colors.black12)),
      ),
      appBarTheme: theme.appBarTheme.copyWith(
        actionsIconTheme: theme.iconTheme,
        brightness: Brightness.light,
        color: Colors.grey.shade50,
        iconTheme: theme.iconTheme,
        textTheme: localizedTheme.textTheme,
      ),
      floatingActionButtonTheme: theme.floatingActionButtonTheme.copyWith(
        backgroundColor: theme.primaryColor,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
    );
    theme = theme.copyWith(
      bottomAppBarTheme: theme.bottomAppBarTheme.copyWith(
        shape: AutomaticNotchedShape(
          BeveledRectangleBorder(),
          theme.floatingActionButtonTheme.shape,
        ),
      ),
    );

    return HpiTheme(
      tertiary: Color(0xFFF6A804),
      child: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return buildLoadingError(snapshot);

          final sharedPreferences = snapshot.data;
          // To show onboarding again, uncomment the following line:
          // sharedPreferences.remove(OnboardingPage.KEY_COMPLETED);

          return Provider<SharedPreferences>(
            builder: (_) => sharedPreferences,
            child: Builder(
              builder: (context) => MaterialApp(
                title: 'HPI',
                theme: theme,
                initialRoute: OnboardingPage.isOnboardingCompleted(context)
                    ? Route.dashboard.name
                    : Route.onboarding.name,
                onGenerateRoute: Route.generateRoute,
                navigatorObservers: [
                  NavigationObserver(Provider.of<NavigationService>(context)),
                ],
                localizationsDelegates: [
                  hpiLocalizationsDelegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                supportedLocales: hpiLocalizationsDelegate.supportedLanguages
                    .map((l) => Locale(l))
                    .asList(),
              ),
            ),
          );
        },
      ),
    );
  }
}

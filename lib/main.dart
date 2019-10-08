import 'dart:io';

import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart' hide Route;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hpi_flutter/core/localizations.dart';
import 'package:hpi_flutter/route.dart';
import 'package:hpi_flutter/crashreporting/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';

import 'app/services/navigation.dart';
import 'app/widgets/hpi_theme.dart';
import 'app/widgets/utils.dart';
import 'onboarding/widgets/onboarding_page.dart';

Future<ByteData> _downloadFontToCache(String filename, String url) async {
  final file = File('${(await getTemporaryDirectory()).path}/$filename');

  if (await file.exists()) {
    // We already downloaded a cached version of the font, so just use that.
    final bytes = file.readAsBytesSync();
    return ByteData.view(bytes.buffer);
  } else {
    // Download the font.
    final response = await http.get(url);
    if (response.statusCode == 200) {
      file.writeAsBytes(response.bodyBytes);
      return ByteData.view(response.bodyBytes.buffer);
    } else {
      throw Exception('Failed to load font');
    }
  }
}

void main() async {
  const fontBaseUrl = 'https://hpi.de/fileadmin/templates/fonts';
  const serverUrl = "172.18.132.7";

  // This captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (isInDebugMode) {
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode report to the application zone.
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  // run in custom zone for catching errors
  runZoned<Future<void>>(() async {
    var delegate = HpiLocalizationsDelegate();
    try {
      // We should load the different font files for bold and normal style into
      // the same font name with different weights, but it seems like this
      // feature is not supported yet: https://github.com/flutter/flutter/issues/42084
      // So, for now we only load the non-bold font.
      var fontLoader = FontLoader('Neo Sans')
        ..addFont(_downloadFontToCache('neo_sans.ttf',
            '$fontBaseUrl/9de9709d-f77a-44ad-96b9-6fea586f7efb.ttf'));
      //..addFont(_downloadFontToCache('neo_sans_bold.ttf',
      //    '$fontBaseUrl/9de9709d-f77a-44ad-96b9-6fea586f7efb.ttf'))
      await fontLoader.load();
    } catch (_) {
      // We do nothing here as it's not a big problem if the font isn't
      // downloaded yet—we can just use the default this time. Of course, we
      // automatically try to download the font the next time the app gets
      // started.
    }

    // Used by feedback to capture the whole app
    final screenshotController = ScreenshotController();

    runApp(
      MultiProvider(
        providers: [
          Provider<NavigationService>(
            builder: (_) => NavigationService(),
          ),
          Provider<Uri>(
            builder: (_) => Uri.parse(serverUrl),
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
  }, onError: (error, stackTrace) async {
    await reportError(error, stackTrace, Uri.parse(serverUrl));
  });
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
      cardTheme: theme.cardTheme.copyWith(
        shape: BeveledRectangleBorder(),
      ),
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
          // OnboardingPage.clearOnboardingCompleted(sharedPreferences);

          return Provider<SharedPreferences>(
            builder: (_) => sharedPreferences,
            child: MaterialApp(
              title: 'HPI',
              theme: theme,
              initialRoute:
                  OnboardingPage.isOnboardingCompleted(sharedPreferences)
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
          );
        },
      ),
    );
  }
}

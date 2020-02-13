import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart' hide Route;
import 'package:flutter/services.dart';
import 'package:grpc/grpc.dart';
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/course/course.dart';
import 'package:hpi_flutter/crashreporting/crashreporting.dart';
import 'package:hpi_flutter/feedback/feedback.dart';
import 'package:hpi_flutter/food/food.dart';
import 'package:hpi_flutter/myhpi/myhpi.dart';
import 'package:hpi_flutter/news/news.dart';
import 'package:hpi_flutter/openhpi/openhpi.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pedantic/pedantic.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/services/navigation.dart';

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
      unawaited(file.writeAsBytes(response.bodyBytes));
      return ByteData.view(response.bodyBytes.buffer);
    } else {
      throw Exception('Failed to load font');
    }
  }
}

void main() async {
  await runWithCrashReporting(() async {
    // Required for font caching
    WidgetsFlutterBinding.ensureInitialized();
    const fontBaseUrl = 'https://hpi.de/fileadmin/templates/fonts';
    const serverUrl = '172.20.20.6';

    // To show onboarding again, uncomment the following line:
    // await OnboardingPage.clearOnboardingCompleted();

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

    services
      ..registerSingletonAsync((_) => SharedPreferences.getInstance())
      ..registerSingleton(NavigationService())
      ..registerSingleton(Uri.parse(serverUrl))
      ..registerSingleton(
        ClientChannel(
          serverUrl,
          port: 443,
          options: ChannelOptions(
            credentials: ChannelCredentials.insecure(),
          ),
        ),
      )
      // Used by feedback to capture the whole app
      ..registerSingleton(ScreenshotController())
      ..registerFactory(() => _locale)
      // Most BLoCs require a reference to the current locale to retrieve
      // localized information from HPI Cloud. By registering them as factories,
      // we can adapt to locale changes during runtime.
      ..registerFactory(() => CourseBloc())
      ..registerFactory(() => CrashReportingBloc())
      ..registerFactory(() => FeedbackBloc())
      ..registerFactory(() => FoodBloc())
      ..registerFactory(() => MyHpiBloc())
      ..registerFactory(() => NewsBloc())
      ..registerSingleton(OpenHpiBloc());

    await services.allReady();

    runApp(
      Screenshot(
        controller: services.get<ScreenshotController>(),
        child: HpiApp(),
      ),
    );
  });
}

Locale _locale;
void onLocaleChanged(Locale newLocale) => _locale = newLocale;

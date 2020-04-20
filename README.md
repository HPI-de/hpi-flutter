# hpi_flutter

![Build & Lint](https://github.com/HPI-de/hpi-flutter/workflows/Build%20&%20Lint/badge.svg)

The inofficial HPI app, written in Flutter. Feel free to contribute :)

For getting started with flutter check:

- [Lab: Write your first Flutter app](https://flutter.io/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.io/docs/cookbook)

For help getting started with Flutter, view the [online documentation](https://flutter.io/docs), which offers tutorials, samples, guidance on mobile development, and a full API reference.


## How to: Run the app

- Run `flutter packages get`
- Run `flutter pub run intl_utils:generate` (or use the [Flutter Intl][flutter-intl] extension in VS Code)
- Run `flutter packages pub run build_runner build`
- Run `flutter run`


## L10n (Localization)

We recommend using [L42n](https://github.com/JonasWanke/l42n) for editing localization files, located in `lib/l10n`. Note that you still need to re-generate the dart files after editing these files using [Flutter Intl][flutter-intl].


[flutter-intl]: https://marketplace.visualstudio.com/items?itemName=localizely.flutter-intl

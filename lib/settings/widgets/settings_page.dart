import 'package:flutter/material.dart' hide Route;
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/core/core.dart' hide Image;
import 'package:hpi_flutter/feedback/feedback.dart';
import 'package:hpi_flutter/onboarding/onboarding.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:package_info/package_info.dart';

import '../../route.dart';
import 'scrollable_markdown.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: HpiAppBar(
        title: HpiL11n.text(context, 'settings'),
      ),
      body: Material(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(child: _MobileDevAd()),
            _AboutSection(),
          ],
        ),
      ),
    );
  }
}

class _MobileDevAd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final onPrimary = theme.colorScheme.onPrimary;
    final l11n = HpiL11n.of(context);

    final content = AboutMyself.role == Role.student
        ? _buildStudent(context, theme, onPrimary, l11n)
        : _buildNonStudent(context, theme, onPrimary, l11n);

    return Material(
      color: theme.primaryColor,
      child: content,
    );
  }

  Widget _buildStudent(
    BuildContext context,
    ThemeData theme,
    Color onPrimary,
    HpiL11n l11n,
  ) {
    assert(context != null);
    assert(theme != null);
    assert(onPrimary != null);
    assert(l11n != null);

    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              HpiL11n.get(context, 'settings/ad.title'),
              style: theme.textTheme.headline.copyWith(color: onPrimary),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    children: <Widget>[
                      Text(
                        HpiL11n.get(context, 'settings/ad.text'),
                        style: theme.textTheme.body1.copyWith(color: onPrimary),
                      ),
                      SizedBox(height: 16),
                      OutlineButton(
                        borderSide: BorderSide(
                          color: onPrimary.withOpacity(0.6),
                        ),
                        highlightedBorderColor: onPrimary,
                        textColor: onPrimary,
                        onPressed: () =>
                            tryLaunch('https://t.me/hpi_mobiledev'),
                        child: HpiL11n.text(context, 'settings/ad.button'),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8),
              Image.asset(
                'assets/logo/mobileDev_sheep.png',
                height: 192,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNonStudent(
    BuildContext context,
    ThemeData theme,
    Color onPrimary,
    HpiL11n l11n,
  ) {
    assert(context != null);
    assert(theme != null);
    assert(onPrimary != null);
    assert(l11n != null);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Text(
        HpiL11n.get(context, 'settings/ad.title.nonStudent'),
        style: theme.textTheme.subhead.copyWith(color: onPrimary),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  void _showImprint(BuildContext context) {
    final textTheme = context.theme.textTheme;

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        builder: (context, scrollController) => ListView(
          padding: const EdgeInsets.all(16),
          controller: scrollController,
          children: <Widget>[
            Text(
              HpiL11n.get(context, 'settings/about.imprint.desc'),
              style: textTheme.body1,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate.fixed(
        <Widget>[
          ListTile(
            leading: Icon(OMIcons.repeat),
            title: HpiL11n.text(context, 'settings/repeatOnboarding'),
            onTap: () {
              Navigator.pushNamed(context, Route.onboarding.name);
            },
          ),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              final version = snapshot.hasData
                  ? '${snapshot.data.version}+${snapshot.data.buildNumber}'
                  : HpiL11n.get(context, 'settings/about.version.error');
              return ListTile(
                leading: Icon(OMIcons.update),
                title: HpiL11n.text(context, 'settings/about.version'),
                subtitle: Text(version),
              );
            },
          ),
          ListTile(
            leading: Icon(OMIcons.people),
            title: HpiL11n.text(context, 'settings/about.contributors'),
            subtitle: Text(
                'Felix Auringer, Marcel Garus, Kirill Postnov, Matti Schmidt, Maximilian Stiede, Clemens Tiedt, Ronja Wagner, Jonas Wanke'),
          ),
          ListTile(
            leading: Icon(OMIcons.code),
            title: HpiL11n.text(context, 'settings/about.openSource'),
            trailing: Icon(OMIcons.openInNew),
            onTap: () => tryLaunch('https://github.com/HPI-de/hpi_flutter'),
          ),
          ListTile(
            leading: Icon(OMIcons.person),
            title: HpiL11n.text(context, 'settings/about.imprint'),
            onTap: () => _showImprint(context),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: _buildBottomButtons(context),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBottomButtons(BuildContext context) {
    assert(context != null);

    return <Widget>[
      FlatButton(
        onPressed: () {
          Navigator.pushNamed(context, Route.settingsPrivacyPolicy.name);
        },
        child: HpiL11n.text(context, 'settings/about.privacyPolicy'),
      ),
      Text('⋅', style: context.theme.textTheme.headline),
      FlatButton(
        onPressed: () {
          PackageInfo.fromPlatform()
              .then(
                (p) => '${p.version}+${p.buildNumber}',
                onError: (_) =>
                    HpiL11n.get(context, 'settings/about.version.error'),
              )
              .then((version) => showLicensePage(
                    context: context,
                    applicationName:
                        HpiL11n.get(context, 'settings/about.licenses.name'),
                    applicationVersion: version,
                    applicationIcon: Image.asset(
                      'assets/logo/logo.png',
                      width: 48,
                      height: 48,
                    ),
                    applicationLegalese: HpiL11n.get(
                        context, 'settings/about.licenses.legalese'),
                  ));
        },
        child: HpiL11n.text(context, 'settings/about.licenses'),
      ),
      Text('⋅', style: context.theme.textTheme.headline),
      FlatButton(
        onPressed: () {
          FeedbackDialog.show(context);
        },
        child: HpiL11n.text(context, 'feedback/action'),
      ),
    ];
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  static void showBottomSheet(BuildContext context) {
    assert(context != null);

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        builder: (context, scrollController) => FutureBuilder<String>(
          future: rootBundle.loadString('assets/privacyPolicy.md'),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return buildLoadingError(snapshot);
            }

            return ScrollableMarkdown(
              scrollController: scrollController,
              data: snapshot.data,
              onTapLink: tryLaunch,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: HpiAppBar(
        title: HpiL11n.text(context, 'settings/about.privacyPolicy'),
      ),
      body: FutureBuilder<String>(
        future: rootBundle.loadString('assets/privacyPolicy.md'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return buildLoadingError(snapshot);
          }

          return Markdown(
            data: snapshot.data,
            onTapLink: tryLaunch,
          );
        },
      ),
    );
  }
}

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
        title: Text(context.s.settings),
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

    final content = AboutMyself.role == Role.student
        ? _buildStudent(context, theme, onPrimary)
        : _buildNonStudent(context, theme, onPrimary);

    return Material(
      color: theme.primaryColor,
      child: content,
    );
  }

  Widget _buildStudent(
    BuildContext context,
    ThemeData theme,
    Color onPrimary,
  ) {
    assert(context != null);
    assert(theme != null);
    assert(onPrimary != null);
    final s = context.s;

    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              s.settings_ad_title,
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
                        s.settings_ad_text,
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
                        child: Text(s.settings_ad_button),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8),
              Image.asset('assets/logo/mobileDev_sheep.png', height: 192),
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
  ) {
    assert(context != null);
    assert(theme != null);
    assert(onPrimary != null);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Text(
        context.s.settings_ad_title_nonStudent,
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
              context.s.settings_about_imprint_desc,
              style: textTheme.body1,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;

    return SliverList(
      delegate: SliverChildListDelegate.fixed(
        <Widget>[
          ListTile(
            leading: Icon(OMIcons.repeat),
            title: Text(s.settings_repeatOnboarding),
            onTap: () {
              Navigator.pushNamed(context, Route.onboarding.name);
            },
          ),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              final version = snapshot.hasData
                  ? '${snapshot.data.version}+${snapshot.data.buildNumber}'
                  : s.settings_about_version_error;
              return ListTile(
                leading: Icon(OMIcons.update),
                title: Text(s.settings_about_version),
                subtitle: Text(version),
              );
            },
          ),
          ListTile(
            leading: Icon(OMIcons.people),
            title: Text(s.settings_about_contributors),
            subtitle: Text(
                'Felix Auringer, Marcel Garus, Kirill Postnov, Matti Schmidt, Maximilian Stiede, Clemens Tiedt, Ronja Wagner, Jonas Wanke'),
          ),
          ListTile(
            leading: Icon(OMIcons.code),
            title: Text(s.settings_about_openSource),
            trailing: Icon(OMIcons.openInNew),
            onTap: () => tryLaunch('https://github.com/HPI-de/hpi_flutter'),
          ),
          ListTile(
            leading: Icon(OMIcons.person),
            title: Text(s.settings_about_imprint),
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
    final s = context.s;

    return <Widget>[
      FlatButton(
        onPressed: () {
          Navigator.pushNamed(context, Route.settingsPrivacyPolicy.name);
        },
        child: Text(s.settings_about_privacyPolicy),
      ),
      Text('⋅', style: context.theme.textTheme.headline),
      FlatButton(
        onPressed: () {
          PackageInfo.fromPlatform()
              .then(
                (p) => '${p.version}+${p.buildNumber}',
                onError: (_) => s.settings_about_version_error,
              )
              .then((version) => showLicensePage(
                    context: context,
                    applicationName: s.settings_about_licenses_name,
                    applicationVersion: version,
                    applicationIcon: Image.asset(
                      'assets/logo/logo.png',
                      width: 48,
                      height: 48,
                    ),
                    applicationLegalese: s.settings_about_licenses_legalese,
                  ));
        },
        child: Text(s.settings_about_licenses),
      ),
      Text('⋅', style: context.theme.textTheme.headline),
      FlatButton(
        onPressed: () {
          FeedbackDialog.show(context);
        },
        child: Text(s.feedback_action),
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
        title: Text(context.s.settings_about_privacyPolicy),
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

import 'package:flutter/material.dart' hide Route;
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hpi_flutter/app/widgets/app_bar.dart';
import 'package:hpi_flutter/app/widgets/main_scaffold.dart';
import 'package:hpi_flutter/app/widgets/utils.dart';
import 'package:hpi_flutter/core/localizations.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../route.dart';

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
            _AboutSection(),
          ],
        ),
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate.fixed(
        <Widget>[
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
            subtitle: HpiL11n.text(context, 'settings/about.contributors.desc'),
          ),
          ListTile(
            leading: Icon(OMIcons.code),
            title: HpiL11n.text(context, 'settings/about.openSource'),
            trailing: Icon(OMIcons.openInBrowser),
            onTap: () {
              launch(HpiL11n.get(context, 'settings/about.openSource.link'));
            },
          ),
          ListTile(
            leading: Icon(OMIcons.person),
            title: HpiL11n.text(context, 'settings/about.imprint'),
            subtitle: SelectableText(
              HpiL11n.get(context, 'settings/about.imprint.desc'),
            ),
          ),
          ListTile(
            leading: Icon(OMIcons.notes),
            title: HpiL11n.text(context, 'settings/about.privacyPolicy'),
            onTap: () {
              Navigator.pushNamed(context, Route.settingsPrivacyPolicy.name);
            },
          ),
        ],
      ),
    );
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: HpiAppBar(
        title: HpiL11n.text(context, 'settings/about.privacyPolicy'),
      ),
      body: FutureBuilder<String>(
        future: rootBundle.loadString('assets/privacyPolicy.md'),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return buildLoadingErrorBody(context, snapshot);

          return Markdown(
            data: snapshot.data,
            onTapLink: (url) {
              launch(url);
            },
          );
        },
      ),
    );
  }
}

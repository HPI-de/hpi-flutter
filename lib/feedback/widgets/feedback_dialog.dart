import 'dart:typed_data';

import 'package:flutter/material.dart' hide Feedback;
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/core/core.dart';
import 'package:screenshot/screenshot.dart';

import '../bloc.dart';
import '../data.dart';

class FeedbackDialog extends StatefulWidget {
  static void show(
    BuildContext context, {
    String title = 'Feedback',
    String feedbackType,
  }) async {
    assert(context != null);

    var currentScreenshot = await services
        .get<ScreenshotController>()
        .capture()
        .then((screenshot) => screenshot.readAsBytes());

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: FeedbackDialog._(
              title: title,
              feedbackType: feedbackType,
              screenshot: currentScreenshot),
        ),
      ),
    );
  }

  const FeedbackDialog._({
    Key key,
    this.title = 'Feedback',
    this.feedbackType,
    this.screenshot,
  })  : assert(title != null),
        super(key: key);

  final String title;
  final String feedbackType;
  final Uint8List screenshot;

  @override
  _FeedbackDialogState createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog>
    with TickerProviderStateMixin {
  String message = "";
  bool includeContact = true;
  bool includeScreenshotAndLogs = true;
  bool isSending = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildFormContent(),
        ),
      ),
    );
  }

  List<Widget> _buildFormContent() {
    return [
      Text(
        widget.title,
        style: Theme.of(context).textTheme.display1,
      ),
      SizedBox(height: 16),
      TextFormField(
        minLines: 4,
        maxLines: 8,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: HpiL11n.get(context, 'feedback/message'),
        ),
        onChanged: (m) {
          message = m;
        },
        validator: (m) {
          if (isNullOrBlank(m)) {
            return HpiL11n.get(context, 'feedback/message.missing');
          }
          return null;
        },
      ),
      SizedBox(height: 16),
      // TODO: enable when login is implemented
      /* CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Text('Include your contact details'),
        subtitle: Text(
            'This will show us your name and e-mail address. Recommended e.g. for bug reports and questions'),
        value: includeContact,
        onChanged: (checked) => setState(() {
          includeContact = checked;
        }),
      ), */
      CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(HpiL11n.get(context, 'feedback/includeLogs')),
        subtitle: Text(HpiL11n.get(context, 'feedback/includeLogs.desc')),
        value: includeScreenshotAndLogs,
        onChanged: (checked) => setState(() {
          includeScreenshotAndLogs = checked;
        }),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: LoadingButton(
          text: HpiL11n.get(context, 'submit'),
          loadingText: HpiL11n.get(context, 'sending'),
          isLoading: isSending,
          onPressed: _send,
          color: Theme.of(context).primaryColor,
        ),
      ),
    ];
  }

  void _send() {
    if (!_formKey.currentState.validate()) return;

    setState(() {
      isSending = true;
      Uri screenUri = Uri.https('mobiledev.hpi.de',
          services.get<NavigationService>().lastKnownRoute.name);
      Feedback.create(
        message.trim(),
        screenUri,
        includeContact,
        includeScreenshotAndLogs,
        widget.screenshot,
        includeScreenshotAndLogs,
      ).then((f) {
        services.get<FeedbackBloc>().sendFeedback(f);
      }).then((f) {
        _onSent(true);
      }).catchError((e) {
        print(e);
        _onSent(false);
      });
      Future.delayed(Duration(seconds: 2)).then((_) => Navigator.pop(context));
    });
  }

  void _onSent(bool successful) {
    assert(successful != null);

    setState(() {
      isSending = false;
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          HpiL11n.get(context, successful ? 'feedback/sent' : 'error'),
        ),
      ));
    });
  }
}

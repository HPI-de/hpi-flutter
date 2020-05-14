import 'dart:typed_data';

import 'package:flutter/material.dart' hide Feedback;
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/core/core.dart';
import 'package:screenshot/screenshot.dart';

import '../bloc.dart';
import '../data.dart';

class FeedbackDialog extends StatefulWidget {
  const FeedbackDialog._({
    Key key,
    this.title = 'Feedback',
    this.feedbackType,
    this.screenshot,
  })  : assert(title != null),
        super(key: key);

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
              EdgeInsets.only(bottom: context.mediaQuery.viewInsets.bottom),
          child: FeedbackDialog._(
              title: title,
              feedbackType: feedbackType,
              screenshot: currentScreenshot),
        ),
      ),
    );
  }

  final String title;
  final String feedbackType;
  final Uint8List screenshot;

  @override
  _FeedbackDialogState createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog>
    with TickerProviderStateMixin {
  String message = '';
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
    final s = context.s;

    return [
      Text(
        widget.title,
        style: context.textTheme.headline4,
      ),
      SizedBox(height: 16),
      TextFormField(
        minLines: 4,
        maxLines: 8,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: s.feedback_message,
        ),
        onChanged: (m) {
          message = m;
        },
        validator: (m) {
          if (isNullOrBlank(m)) {
            return s.feedback_message_missing;
          }
          return null;
        },
      ),
      SizedBox(height: 16),
      // TODO(ctiedt): enable when login is implemented, https://github.com/HPI-de/hpi_flutter/issues/114
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
        title: Text(s.feedback_includeLogs),
        subtitle: Text(s.feedback_includeLogs_desc),
        value: includeScreenshotAndLogs,
        onChanged: (checked) => setState(() {
          includeScreenshotAndLogs = checked;
        }),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: FancyRaisedButton(
          onPressed: _send,
          isLoading: isSending,
          loadingChild: Text(s.general_sending),
          color: context.theme.primaryColor,
          child: Text(s.general_submit),
        ),
      ),
    ];
  }

  void _send() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      isSending = true;
      Uri screenUri =
          Uri.parse(mdWebUrl(services.get<NavigationService>().lastKnownRoute));
      Feedback.create(
        message.trim(),
        screenUri: screenUri,
        includeContact: includeContact,
        includeScreenshot: includeScreenshotAndLogs,
        screenshot: widget.screenshot,
        includeLogs: includeScreenshotAndLogs,
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
    final s = context.s;

    setState(() {
      isSending = false;
      context.scaffold.showSnackBar(SnackBar(
        content: Text(successful ? s.feedback_sent : s.general_error),
      ));
    });
  }
}

import 'package:flutter/material.dart' hide Feedback;
import 'package:hpi_flutter/app/services/navigation.dart';
import 'package:hpi_flutter/core/utils.dart';
import 'package:hpi_flutter/core/widgets/loading_button.dart';
import 'package:hpi_flutter/feedback/data/bloc.dart';
import 'package:hpi_flutter/feedback/data/feedback.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class FeedbackDialog extends StatefulWidget {
  static void show(BuildContext context,
      {String title = 'Feedback', String feedbackType}) {
    assert(context != null);

    showModalBottomSheet(
      context: context,
      builder: (context) => ProxyProvider<Uri, FeedbackBloc>(
        builder: (_, serverUrl, __) => FeedbackBloc(serverUrl),
        child: FeedbackDialog._(
          title: title,
          feedbackType: feedbackType,
        ),
      ),
    );
  }

  const FeedbackDialog._({Key key, this.title = 'Feedback', this.feedbackType})
      : assert(title != null),
        super(key: key);

  final String title;
  final String feedbackType;

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
          labelText: 'Your message',
        ),
        onChanged: (m) {
          message = m;
        },
        validator: (m) {
          if (isNullOrBlank(m)) return 'Please enter a message.';
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
        title: Text('Include screenshot and logs'),
        subtitle: Text('Recommended for bugs'),
        value: includeScreenshotAndLogs,
        onChanged: (checked) => setState(() {
          includeScreenshotAndLogs = checked;
        }),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: LoadingButton.submit(
          isSending: isSending,
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
      Uri screenUri = Uri.https("mobiledev.hpi.de",
          Provider.of<NavigationService>(context).lastKnownRoute.name);
      Feedback.create(
        message.trim(),
        screenUri,
        includeContact,
        includeScreenshotAndLogs,
        Provider.of<ScreenshotController>(context),
        includeScreenshotAndLogs,
      ).then((f) {
        Provider.of<FeedbackBloc>(context).sendFeedback(f);
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
          successful
              ? "Your fedback was submitted. Thanks!"
              : "An error occurred. Please try again.",
        ),
      ));
    });
  }
}

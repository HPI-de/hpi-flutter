import 'package:flutter/material.dart';

class FeedbackDialog extends StatefulWidget {
  final String title;
  final String feedbackType;

  const FeedbackDialog({Key key, this.title = 'Feedback', this.feedbackType})
      : super(key: key);
  @override
  _FeedbackDialogState createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog>
    with TickerProviderStateMixin {
  bool includeContact = false;
  bool sendLogs = false;
  Widget submitButtonChild =
      Text('Submit', style: TextStyle(color: Colors.white));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.title,
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: TextField(
              minLines: 4,
              maxLines: 8,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Your message'),
            ),
          ),
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: Text('Include your contact details'),
            subtitle: Text(
                'This will show us your name and e-mail address. Recommended e.g. for bug reports and questions'),
            value: includeContact,
            onChanged: (checked) {
              setState(() {
                includeContact = checked;
              });
            },
          ),
          Divider(),
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: Text('Include screenshots and logs'),
            subtitle: Text('Recommended for bugs'),
            value: sendLogs,
            onChanged: (checked) {
              setState(() {
                sendLogs = checked;
              });
            },
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: RaisedButton(
              color: Theme.of(context).primaryColor,
              child: submitButtonChild,
              onPressed: () {
                setState(() {
                  submitButtonChild = Container(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        backgroundColor: Colors.white,
                      ));
                  Future.delayed(Duration(seconds: 2))
                      .then((_) => Navigator.pop(context));
                });
              },
            ),
          )
        ],
      ),
    );
  }
}

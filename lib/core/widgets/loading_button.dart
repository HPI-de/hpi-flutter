import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  const LoadingButton({
    @required this.text,
    @required this.loadingText,
    @required this.isLoading,
    @required this.onPressed,
    this.color,
  })  : assert(text != null),
        assert(loadingText != null),
        assert(isLoading != null),
        assert(onPressed != null);
  const LoadingButton.submit({
    @required bool isSending,
    @required VoidCallback onPressed,
    Color color,
  }) : this(
          text: 'Submit',
          loadingText: 'Sending…',
          isLoading: isSending,
          onPressed: onPressed,
          color: color,
        );

  final String text;
  final String loadingText;
  final bool isLoading;
  final VoidCallback onPressed;

  final Color color;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: color,
      onPressed: isLoading ? null : onPressed,
      child: isLoading ? _buildLoadingContent() : _buildNotLoadingContent(),
    );
  }

  Widget _buildLoadingContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 16,
          width: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            backgroundColor: Colors.white,
          ),
        ),
        SizedBox(width: 8),
        Text(loadingText, style: TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _buildNotLoadingContent() {
    return Text(text, style: TextStyle(color: Colors.white));
  }
}

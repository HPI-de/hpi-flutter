import 'package:flutter/material.dart' hide Route;

class MainScaffold extends StatelessWidget {
  const MainScaffold({
    this.appBar,
    @required this.body,
    this.floatingActionButton,
  }) : assert(body != null);

  final PreferredSizeWidget appBar;
  final Widget body;
  final Widget floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: body,
    );
  }
}

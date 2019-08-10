import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:provider/provider.dart';

import 'news/widgets/news_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ClientChannel>(
          builder: (_) => ClientChannel(
            "172.18.132.7",
            port: 50061,
            options: ChannelOptions(
              credentials: ChannelCredentials.insecure(),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'HPI',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: NewsPage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(),
    );
  }
}

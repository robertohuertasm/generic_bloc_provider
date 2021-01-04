import 'dart:async';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: AppBloc(),
      child: MaterialApp(
        title: 'Yo Sleep',
        home: MainPage(),
        initialRoute: 'main',
        routes: {
          'main': (context) => MainPage(),
        },
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appBloc = BlocProvider.of<AppBloc>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder(
              stream: appBloc.text$,
              builder: (context, AsyncSnapshot<String> snapshot) {
                return Text(
                    snapshot.hasData ? snapshot.data ?? 'no data' : 'loading');
              },
            ),
            FlatButton(
              onPressed: () {
                var time = DateTime.now().toUtc().toIso8601String();
                appBloc.text.add('Pressed at $time');
              },
              child: Text('PRESS THIS'),
            )
          ],
        ),
      ),
    );
  }
}

class AppBloc extends Bloc {
  final _text$ = StreamController<String>();
  Stream<String> get text$ => _text$.stream;
  Sink<String> get text => _text$.sink;

  void dispose() {
    _text$.close();
  }
}

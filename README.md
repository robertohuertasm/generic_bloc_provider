# generic_bloc_provider

A generic BloC Provider for your Flutter apps.

## Getting Started

All your BloCs must extend the `Bloc` abstract class. This means that all of them should have a `dispose` function that will be executed whenever the life of the BloC comes to an end.

In this method, you should take care of closing all the `sinks` and resources.

Example of how to use it:

```dart
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
          children: <Widget>[
            Header(),
            RecordList(appBloc),
          ],
        ),
      ),
    );
  }
}

```

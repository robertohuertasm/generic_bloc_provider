# generic_bloc_provider

[![Build Status](https://travis-ci.com/robertohuertasm/generic_bloc_provider.svg?branch=master)](https://travis-ci.com/robertohuertasm/generic_bloc_provider)

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

## Attaching your context to the InheritedWidget

The `BlocProvider` class depends on `InheritedWidget`. Whenever you want to get your `BloC`, you can decide wether to attach the context of your widget to the `InheritedWidget` or not.

In order to control this behavior, the static method `of` has a boolean optional argument (which is true by default) deciding if your context will be attached or not.

Basically, if you don't provide it or you just set it to `true`, [inheritFromWidgetOfExactType](https://docs.flutter.io/flutter/widgets/BuildContext/inheritFromWidgetOfExactType.html) will be used. If you set it to `false` then [ancestorInheritedElementForWidgetOfExactType](https://docs.flutter.io/flutter/widgets/BuildContext/ancestorInheritedElementForWidgetOfExactType.html) will be used instead

## Customizing the update policy

If you want to change the way `updateShouldNotify` behaves you just have the option to provide a custom function to the `BlocProvider` constructor.

You will notice that there's an argument called `updateShouldNotifyOverride` which accepts a function receiving a `BloC` and the internal `InheritedWidget`:

```dart
bool Function(T bloc, _BlocProvider oldWidget);
```

This is the default implementation of the `updateShouldNotify` method:

```dart
@override
  bool updateShouldNotify(_BlocProvider oldWidget) =>
      updateShouldNotifyOverride != null
          ? updateShouldNotifyOverride(bloc, oldWidget)
          : oldWidget.bloc != bloc;
```

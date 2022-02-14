import 'package:flutter/material.dart';
import 'bloc.dart';

/// Function used to customize the update policy
typedef UpdateShouldNotify<T> = bool Function(T bloc, _BlocProvider oldWidget);

/// The `BlocProvider` class depends on `InheritedWidget`.
/// It accepts a bloc and a widget.
class BlocProvider<T extends Bloc> extends StatefulWidget {
  /// The  BLoC this provider will be hosting
  final T bloc;

  /// The widget that the [BlocProvider] will wrap
  final Widget child;

  /// Allows you to override the default update policy
  ///
  /// Default implementation:
  ///
  /// ```dart
  ///    @override
  ///    bool updateShouldNotify(_BlocProvider oldWidget) =>
  ///       updateShouldNotifyOverride != null
  ///           ? updateShouldNotifyOverride(bloc, oldWidget)
  ///           : oldWidget.bloc != bloc;
  /// ```
  final UpdateShouldNotify<T>? updateShouldNotifyOverride;

  /// Builds a [BlocProvider].
  ///
  /// [child] is the widget that the [BlocProvider] will wrap.
  /// [bloc] is the BLoC this provider will be hosting.
  /// [updateShouldNotifiyOverride] is an optional parameter that will allow you
  /// to override the default behaviour.
  /// This is the default implementation of the `updateShouldNotify` method:
  ///
  /// ```dart
  ///    @override
  ///    bool updateShouldNotify(_BlocProvider oldWidget) =>
  ///       updateShouldNotifyOverride != null
  ///           ? updateShouldNotifyOverride(bloc, oldWidget)
  ///           : oldWidget.bloc != bloc;
  /// ```
  BlocProvider({
    Key? key,
    required this.child,
    required this.bloc,
    this.updateShouldNotifyOverride,
  }) : super(key: key);

  /// Whenever you want to get your `BloC`, you can decide wether to attach the context of your widget to the `InheritedWidget` or not.
  /// In order to control this behavior, the static method `of` has an optional boolean argument (which is true by default) which determines wether your context will be attached or not.
  /// Basically, if you don't provide it or you just set it to `true`, [dependOnInheritedWidgetOfExactType](https://api.flutter.dev/flutter/widgets/BuildContext/dependOnInheritedWidgetOfExactType.html) will be used.
  /// If you set
  static T of<T extends Bloc>(BuildContext context,
          [bool attachContext = true]) =>
      _BlocProvider.of(context, attachContext);

  /// Creates the state
  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();
}

class _BlocProviderState<T extends Bloc> extends State<BlocProvider<T>> {
  @override
  Widget build(BuildContext context) {
    return _BlocProvider(
      bloc: widget.bloc,
      child: widget.child,
      updateShouldNotifyOverride: widget.updateShouldNotifyOverride,
    );
  }

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
}

class _BlocProvider<T extends Bloc> extends InheritedWidget {
  final T bloc;
  final Widget child;
  final UpdateShouldNotify<T>? updateShouldNotifyOverride;

  _BlocProvider({
    required this.bloc,
    required this.child,
    this.updateShouldNotifyOverride,
  }) : super(child: child);

  static T of<T extends Bloc>(BuildContext context, bool attachContext) {
    _BlocProvider<T>? blocProvider;

    if (attachContext) {
      blocProvider =
          context.dependOnInheritedWidgetOfExactType<_BlocProvider<T>>();
    } else {
      var element =
          context.getElementForInheritedWidgetOfExactType<_BlocProvider<T>>();
      if (element != null) {
        blocProvider = element.widget as _BlocProvider<T>;
      }
    }

    if (blocProvider == null) {
      final type = _typeOf<_BlocProvider<T>>();
      throw FlutterError('Unable to find BLoC of type $type.\n'
          'Context provided: $context');
    }
    return blocProvider.bloc;
  }

  static Type _typeOf<T>() => T;

  @override
  bool updateShouldNotify(_BlocProvider oldWidget) =>
      updateShouldNotifyOverride != null
          ? updateShouldNotifyOverride!(bloc, oldWidget)
          : oldWidget.bloc != bloc;
}

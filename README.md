FF bloc for creating awesome apps easy

# Why

- Event applyAsync - easy to extend and very fast for navigation by codebase.
- File structure like features is more useful for code generation and quick navigation when you write code.
- Work with all base state. Simple to understand and for use.
- Base abstraction for subscribe and dispose.
- Dispose by getit

# boilerplate

Use [[FF] Flutter Files](https://marketplace.visualstudio.com/items?itemName=gornivv.vscode-flutter-files) for code generation.

# Advanced

Example with override logger logic:

```dart

abstract class CustomBloc<Event extends CustomBlocEvent<State, Bloc<Event, State>>, State extends CustomState> extends FFBloc<Event, State> {
  CustomBloc({
    required super.initialState,
    required this.logger,
  });

  @nonVirtual
  final Logger logger;

  @override
  void onObserver({required Event event}) {
    logger.i('on event: ${event.toString()}', tag: runtimeType.toString());
  }

  @override
  void onErrorObserver({required Event event, required Object error, required StackTrace stackTrace}) {
    logger.e(
      error.toString(),
      exception: error,
      tag: event.runtimeType.toString(),
      stackTrace: stackTrace,
    );
  }

  @override
  void onTransitionObserver({required Transition<Event, State> transition}) {
    logger.i('onTransition: ${transition.toString()}', tag: runtimeType.toString());
  }
}


@immutable
abstract class CustomState<Self, DataT> extends FFState<Self, DataT> {
  const CustomState({
    required super.version,
    required super.isLoading,
    required super.data,
    required super.error,
});
```

FF bloc for creating awesome apps easy

[![Pub](https://img.shields.io/pub/v/ff_bloc.svg)](https://pub.dev/packages/ff_bloc)

## Import

```yaml
ff_bloc: 1.0.3
```

# Why

-   Event applyAsync - easy to extend and very fast for navigation by codebase.
-   File structure like features is more useful for code generation and quick navigation when you write code.
-   Work with all base state. Simple to understand and for use.
-   Base abstraction for subscribe and dispose.
-   Dispose by getit

# boilerplate

Use [[FF] Flutter Files](https://marketplace.visualstudio.com/items?itemName=gornivv.vscode-flutter-files) for code generation.

# Advanced

Example with override logger logic:

```dart

class YouAwesomeBloc extends FFBloc<YouAwesomeEvent, YouAwesomeState> {
  YouAwesomeBloc({
    required this.provider,
    super.initialState = const YouAwesomeState(),
  });

  final YouAwesomeProvider provider;

  @override
  Iterable<StreamSubscription>? initSubscriptions() {
    return <StreamSubscription>[
      // listen here
    ];
  }

  @override
  YouAwesomeState onErrorState(Object error) =>
      state.copy(error: error, isLoading: false);
}
```

```dart

class YouAwesomeState extends FFState<YouAwesomeState, YouAwesomeViewModel> {
  const YouAwesomeState({
    super.version = 0,
    super.isLoading = false,
    super.data,
    super.error,
  });

  @override
  StateCopyFactory<YouAwesomeState, YouAwesomeViewModel> getCopyFactory() => YouAwesomeState.new;
}

class YouAwesomeViewModel extends Equatable {
  const YouAwesomeViewModel({
    required this.items,
  });

  final List<YouAwesomeModel>? items;

  @override
  List<Object?> get props => [items];

  YouAwesomeViewModel copyWith({
    List<YouAwesomeModel>? items,
  }) {
    return  YouAwesomeViewModel(
        items: items ?? this.items,
      );
  }
}
```

```dart
class LoadYouAwesomeEvent extends YouAwesomeEvent {
  LoadYouAwesomeEvent({required this.id});
  final String? id;

  static const String _name = 'LoadYouAwesomeEvent';

  @override
  String toString() => _name;

  @override
  Stream<YouAwesomeState> applyAsync({required YouAwesomeBloc bloc}) async* {
    yield bloc.state.copyWithoutError(isLoading: true);
    final result = await bloc.provider.fetchAsync(id);
    yield bloc.state.copyWithoutError(
      isLoading: false,
      data: YouAwesomeViewModel(items: result),
    );
  }
}
```

```dart
@override
  Widget build(BuildContext context) {
    return BlocBuilder<YouAwesomeBloc, YouAwesomeState>(
      bloc: widget.bloc,
      builder: (
        BuildContext context,
        YouAwesomeState currentState,
      ) {
        return currentState.when(
          onLoading: ()=>const CircularProgressIndicator(),
          onEmpty: (data) =>  _Empty(),
          onData: (data) =>  _BodyList(data: data),
          onError: (e) =>  Center(
            child: Column(
              children: [
                Text(e.toString()),
                TextButton(
                  onPressed: _load,
                  child: const Text('ReLoad'),
                )
              ],
            ),
          ),
        );
      },
    );
```

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

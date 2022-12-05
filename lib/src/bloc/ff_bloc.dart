import 'dart:async';

import 'package:ff_bloc/src/bloc/ff_event.dart';
import 'package:ff_bloc/src/bloc/ff_state.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

abstract class FFBloc<Event extends FFBlocEvent<State, Bloc<Event, State>>,
    State extends FFState> extends Bloc<Event, State> implements Disposable {
  FFBloc({
    required State initialState,
  }) : super(initialState) {
    final subscriptions = initSubscriptions();
    if (subscriptions != null && subscriptions.isNotEmpty) {
      listeners.addAll(subscriptions);
    }
    initOnEvents();
  }

  @protected
  @nonVirtual
  final listeners = <StreamSubscription>[];

  @override
  @mustCallSuper
  Future onDispose() async {
    return close();
  }

  @override
  @mustCallSuper
  Future<void> close() async {
    for (final listener in listeners) {
      await listener.cancel();
    }
    return super.close();
  }

  @protected
  void initOnEvents() {
    on<Event>(
      (Event event, Emitter<State> emit) {
        onObserver(event: event);
        return emit.forEach<State>(
          event.applyAsync(bloc: this),
          onData: (state) => state,
          onError: (error, stackTrace) {
            // ignore: invalid_use_of_protected_member
            Bloc.observer.onError(this, error, stackTrace);

            onErrorObserver(error: error, event: event, stackTrace: stackTrace);
            return onErrorState(error);
          },
        );
      },
      transformer: transform,
    );
  }

  @protected
  Iterable<StreamSubscription>? initSubscriptions() {
    return null;
  }

  @protected
  State onErrorState(Object error);

  /// Transforms event stream. Default is `sequential`.
  @protected
  Stream<Event> transform(
      Stream<Event> events, Stream<Event> Function(Event) mapper) {
    return events.asyncExpand(mapper);
  }

  @override
  @protected
  @mustCallSuper
  void onTransition(Transition<Event, State> transition) {
    onTransitionObserver(transition: transition);
    super.onTransition(transition);
  }

  void onObserver({required Event event}) {}
  void onErrorObserver(
      {required Event event,
      required Object error,
      required StackTrace stackTrace}) {}
  void onTransitionObserver({required Transition<Event, State> transition}) {}
}

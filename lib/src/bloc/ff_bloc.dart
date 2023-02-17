import 'dart:async';

import 'package:ff_bloc/src/bloc/ff_event.dart';
import 'package:ff_bloc/src/bloc/ff_state.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

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
    /// Process events concurrently.
    ///
    /// **Note**: there may be event handler overlap and state changes will occur
    /// as soon as they are emitted. This means that states may be emitted in
    /// an order that does not match the order in which the corresponding events
    /// were added.
    // return concurrent<Event>().call(events, mapper);

    /// Process only one event and ignore (drop) any new events
    /// until the current event is done.
    ///
    /// **Note**: dropped events never trigger the event handler.
    // return droppable<Event>().call(events, mapper);

    /// Process only one event by cancelling any pending events and
    /// processing the new event immediately.
    ///
    /// Avoid using [restartable] if you expect an event to have
    /// immediate results -- it should only be used with asynchronous APIs.
    ///
    /// **Note**: there is no event handler overlap and any currently running tasks
    /// will be aborted if a new event is added before a prior one completes.
    // return restartable<Event>().call(events, mapper);

    /// Process events one at a time by maintaining a queue of added events
    /// and processing the events sequentially.
    ///
    /// **Note**: there is no event handler overlap and every event is guaranteed
    /// to be handled in the order it was received.
    return sequential<Event>().call(events, mapper);
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

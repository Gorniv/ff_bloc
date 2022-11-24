import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:ff_bloc/ff_bloc.dart';

import 'package:example/you_awesome/index.dart';

@immutable
abstract class YouAwesomeEvent implements FFBlocEvent<YouAwesomeState, YouAwesomeBloc> {}

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


class AddYouAwesomeEvent extends YouAwesomeEvent {
  static const String _name = 'AddYouAwesomeEvent';

  @override
  String toString() => _name;

  @override
  Stream<YouAwesomeState> applyAsync({required YouAwesomeBloc bloc}) async* {
    yield bloc.state.copyWithoutError(isLoading: true);
    final result = await bloc.provider.addMore(bloc.state.data?.items);
    yield bloc.state.copyWithoutError(
      isLoading: false,
      data: YouAwesomeViewModel(items: result),
    );
  }
}

class ClearYouAwesomeEvent extends YouAwesomeEvent {
  static const String _name = 'ClearYouAwesomeEvent';

  @override
  String toString() => _name;

  @override
  Stream<YouAwesomeState> applyAsync({required YouAwesomeBloc bloc}) async* {
    yield bloc.state.copyWithoutError(isLoading: true);
    yield bloc.state.copyWithoutData(
      isLoading: false,
    );
  }
}

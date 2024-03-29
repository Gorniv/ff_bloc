import 'dart:async';

import 'package:ff_bloc/ff_bloc.dart';

import 'package:example/you_awesome/index.dart';

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

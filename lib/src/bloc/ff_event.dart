import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

abstract class FFBlocEvent<State, B extends Bloc> {
  FFBlocEvent._();

  /// Implementation logic of event
  Stream<State> applyAsync({required B bloc});
}

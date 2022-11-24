import 'package:ff_bloc/ff_bloc.dart';

import 'package:example/you_awesome/index.dart';

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

import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class AuthorizationPage
    extends Page<AuthorizationPageState, Map<String, dynamic>>
    with TickerProviderMixin {
  AuthorizationPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<AuthorizationPageState>(
              adapter: null,
              slots: <String, Dependent<AuthorizationPageState>>{}),
          middleware: <Middleware<AuthorizationPageState>>[],
        );
}

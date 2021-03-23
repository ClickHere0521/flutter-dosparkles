import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class HelpPage extends Page<HelpPageState, Map<String, dynamic>>
    with TickerProviderMixin {
  HelpPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<HelpPageState>(
              adapter: null, slots: <String, Dependent<HelpPageState>>{}),
          middleware: <Middleware<HelpPageState>>[],
        );
}

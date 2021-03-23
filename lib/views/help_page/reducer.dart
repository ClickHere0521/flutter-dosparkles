import 'package:fish_redux/fish_redux.dart';

import 'package:com.floridainc.dosparkles/models/models.dart';

import 'action.dart';
import 'state.dart';

Reducer<HelpPageState> buildReducer() {
  return asReducer(
    <Object, Reducer<HelpPageState>>{
      HelpPageAction.action: _onAction,
    },
  );
}

HelpPageState _onAction(HelpPageState state, Action action) {
  final HelpPageState newState = state.clone();
  return newState;
}

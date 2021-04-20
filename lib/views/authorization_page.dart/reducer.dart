import 'package:fish_redux/fish_redux.dart';

import 'package:com.floridainc.dosparkles/models/models.dart';

import 'action.dart';
import 'state.dart';

Reducer<AuthorizationPageState> buildReducer() {
  return asReducer(
    <Object, Reducer<AuthorizationPageState>>{
      AuthorizationPageAction.action: _onAction,
    },
  );
}

AuthorizationPageState _onAction(AuthorizationPageState state, Action action) {
  final AuthorizationPageState newState = state.clone();
  return newState;
}

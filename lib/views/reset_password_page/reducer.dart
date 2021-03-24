import 'package:fish_redux/fish_redux.dart';

import 'package:com.floridainc.dosparkles/models/models.dart';

import 'action.dart';
import 'state.dart';

Reducer<ResetPasswordPageState> buildReducer() {
  return asReducer(
    <Object, Reducer<ResetPasswordPageState>>{
      ResetPasswordPageAction.action: _onAction,
    },
  );
}

ResetPasswordPageState _onAction(ResetPasswordPageState state, Action action) {
  final ResetPasswordPageState newState = state.clone();
  return newState;
}

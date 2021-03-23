import 'package:fish_redux/fish_redux.dart';

import 'package:com.floridainc.dosparkles/models/models.dart';

import 'action.dart';
import 'state.dart';

Reducer<NotificationsPageState> buildReducer() {
  return asReducer(
    <Object, Reducer<NotificationsPageState>>{
      NotificationsPageAction.action: _onAction,
    },
  );
}

NotificationsPageState _onAction(NotificationsPageState state, Action action) {
  final NotificationsPageState newState = state.clone();
  return newState;
}

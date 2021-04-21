import 'package:fish_redux/fish_redux.dart';

import 'package:com.floridainc.dosparkles/models/models.dart';

enum AuthorizationPageAction { action }

class AuthorizationPageActionCreator {
  static Action onAction() {
    return const Action(AuthorizationPageAction.action);
  }
}

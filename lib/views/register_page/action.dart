import 'package:fish_redux/fish_redux.dart';

import 'package:com.floridainc.dosparkles/models/models.dart';

enum RegisterPageAction { action }

class RegisterPageActionCreator {
  static Action onAction() {
    return const Action(RegisterPageAction.action);
  }
}

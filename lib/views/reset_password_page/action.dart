import 'package:fish_redux/fish_redux.dart';

import 'package:com.floridainc.dosparkles/models/models.dart';

enum ResetPasswordPageAction { action }

class ResetPasswordPageActionCreator {
  static Action onAction() {
    return const Action(ResetPasswordPageAction.action);
  }
}

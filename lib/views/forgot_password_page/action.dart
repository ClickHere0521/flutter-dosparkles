import 'package:fish_redux/fish_redux.dart';

import 'package:com.floridainc.dosparkles/models/models.dart';

enum ForgotPasswordPageAction { action }

class ForgotPasswordPageActionCreator {
  static Action onAction() {
    return const Action(ForgotPasswordPageAction.action);
  }
}

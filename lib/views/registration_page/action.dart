import 'package:fish_redux/fish_redux.dart';

import 'package:com.floridainc.dosparkles/models/models.dart';

enum RegistrationPageAction { action }

class RegistrationPageActionCreator {
  static Action onAction() {
    return const Action(RegistrationPageAction.action);
  }
}
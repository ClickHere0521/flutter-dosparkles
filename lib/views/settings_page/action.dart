import 'package:fish_redux/fish_redux.dart';

import 'package:com.floridainc.dosparkles/models/models.dart';

enum SettingsPageAction { action }

class SettingsPageActionCreator {
  static Action onAction() {
    return const Action(SettingsPageAction.action);
  }
}

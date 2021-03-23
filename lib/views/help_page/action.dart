import 'package:fish_redux/fish_redux.dart';

import 'package:com.floridainc.dosparkles/models/models.dart';

enum HelpPageAction { action }

class HelpPageActionCreator {
  static Action onAction() {
    return const Action(HelpPageAction.action);
  }
}

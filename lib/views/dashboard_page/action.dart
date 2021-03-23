import 'package:fish_redux/fish_redux.dart';

import 'package:com.floridainc.dosparkles/models/models.dart';

enum DashboardPageAction { action }

class DashboardPageActionCreator {
  static Action onAction() {
    return const Action(DashboardPageAction.action);
  }
}

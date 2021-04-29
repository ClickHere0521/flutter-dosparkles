import 'package:fish_redux/fish_redux.dart';

import 'package:com.floridainc.dosparkles/models/models.dart';

enum UploadVideoAction { action }

class UploadVideoActionCreator {
  static Action onAction() {
    return const Action(UploadVideoAction.action);
  }
}

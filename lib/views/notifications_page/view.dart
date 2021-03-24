import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';

import 'state.dart';

Widget buildView(
    NotificationsPageState state, Dispatch dispatch, ViewService viewService) {
  Adapt.initContext(viewService.context);
  return Scaffold(
    body: Container(),
  );
}
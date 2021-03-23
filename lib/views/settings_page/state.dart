import 'package:fish_redux/fish_redux.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/state.dart';
import 'package:flutter/material.dart';

abstract class SettingsPageState
    implements GlobalBaseState, Cloneable<SettingsPageState> {
  // @override
  // SettingsPageState clone() {
  //   return SettingsPageState();
  // }
}

SettingsPageState initState(Map<String, dynamic> args) {
  // return SettingsPageState();
}

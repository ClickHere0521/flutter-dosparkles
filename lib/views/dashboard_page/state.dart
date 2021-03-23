import 'package:fish_redux/fish_redux.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/state.dart';
import 'package:flutter/material.dart';

abstract class DashboardPageState
    implements GlobalBaseState, Cloneable<DashboardPageState> {
  // @override
  // DashboardPageState clone() {
  //   return DashboardPageState();
  // }
}

DashboardPageState initState(Map<String, dynamic> args) {
  // return DashboardPageState();
}

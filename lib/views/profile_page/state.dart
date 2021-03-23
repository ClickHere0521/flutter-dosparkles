import 'package:fish_redux/fish_redux.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/state.dart';
import 'package:flutter/material.dart';

abstract class ProfilePageState
    implements GlobalBaseState, Cloneable<ProfilePageState> {
  // @override
  // ProfilePageState clone() {
  //   return ProfilePageState();
  // }
}

ProfilePageState initState(Map<String, dynamic> args) {
  // return ProfilePageState();
}

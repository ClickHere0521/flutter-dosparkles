import 'package:com.floridainc.dosparkles/models/cart_item_model.dart';
import 'package:com.floridainc.dosparkles/utils/general.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/widgets.dart' hide Action;

import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/action.dart';

import 'package:com.floridainc.dosparkles/actions/api/graphql_client.dart';

import 'action.dart';
import 'state.dart';

Effect<ResetPasswordPageState> buildEffect() {
  return combineEffects(<Object, Effect<ResetPasswordPageState>>{
    ResetPasswordPageAction.action: _onAction,
    Lifecycle.initState: _onInit,
    Lifecycle.build: _onBuild,
    Lifecycle.dispose: _onDispose,
  });
}

void _onInit(Action action, Context<ResetPasswordPageState> ctx) async {}

void _onBuild(Action action, Context<ResetPasswordPageState> ctx) {}

void _onDispose(Action action, Context<ResetPasswordPageState> ctx) {}

void _onAction(Action action, Context<ResetPasswordPageState> ctx) {}

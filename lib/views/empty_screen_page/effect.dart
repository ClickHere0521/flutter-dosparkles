import 'package:com.floridainc.dosparkles/actions/api/graphql_client.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/action.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/routes/routes.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/widgets.dart' hide Action;
import 'package:graphql_flutter/graphql_flutter.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../utils/general.dart';
import 'action.dart';
import 'state.dart';
import 'package:toast/toast.dart';
import 'package:com.floridainc.dosparkles/actions/user_info_operate.dart';

Effect<EmptyScreenPageState> buildEffect() {
  return combineEffects(<Object, Effect<EmptyScreenPageState>>{
    EmptyScreenPageAction.action: _onAction,
    Lifecycle.initState: _onInit,
    Lifecycle.build: _onBuild,
    Lifecycle.dispose: _onDispose
  });
}

void _onInit(Action action, Context<EmptyScreenPageState> ctx) async {}

void _onBuild(Action action, Context<EmptyScreenPageState> ctx) {}

void _onDispose(Action action, Context<EmptyScreenPageState> ctx) {}

void _onAction(Action action, Context<EmptyScreenPageState> ctx) {}

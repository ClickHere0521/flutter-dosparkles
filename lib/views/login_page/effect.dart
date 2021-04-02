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

Effect<LoginPageState> buildEffect() {
  return combineEffects(<Object, Effect<LoginPageState>>{
    LoginPageAction.action: _onAction,
    LoginPageAction.loginclicked: _onLoginClicked,
    // LoginPageAction.signUp: _onSignUp,
    // LoginPageAction.googleSignIn: _onGoogleSignIn,
    // LoginPageAction.facebookSignIn: _onFacebookSignIn,
    Lifecycle.initState: _onInit,
    Lifecycle.build: _onBuild,
    Lifecycle.dispose: _onDispose
  });
}

void _onInit(Action action, Context<LoginPageState> ctx) async {
  ctx.state.accountFocusNode = FocusNode();
  ctx.state.pwdFocusNode = FocusNode();
  final Object ticker = ctx.stfState;
  ctx.state.animationController = AnimationController(
      vsync: ticker, duration: Duration(milliseconds: 2000));
  ctx.state.submitAnimationController = AnimationController(
      vsync: ticker, duration: Duration(milliseconds: 1000));
  ctx.state.accountTextController = TextEditingController();
  ctx.state.passWordTextController = TextEditingController();

  SharedPreferences.getInstance().then((_p) async {
    final savedToken = _p.getString('jwt') ?? '';
    if (savedToken.isNotEmpty) {
      await UserInfoOperate.whenLogin(savedToken.toString());
      await BaseGraphQLClient.instance.me();
      _goToMain(ctx);
    }
  });
}

void _onBuild(Action action, Context<LoginPageState> ctx) {
  Future.delayed(Duration(milliseconds: 150),
      () => ctx.state.animationController.forward());
}

void _onDispose(Action action, Context<LoginPageState> ctx) {
  ctx.state.animationController.dispose();
  ctx.state.accountFocusNode.dispose();
  ctx.state.pwdFocusNode.dispose();
  ctx.state.submitAnimationController.dispose();
  ctx.state.accountTextController.dispose();
  ctx.state.passWordTextController.dispose();
}

void _onAction(Action action, Context<LoginPageState> ctx) {}

Future _onLoginClicked(Action action, Context<LoginPageState> ctx) async {
  final _result = await _emailSignIn(action, ctx);

  if (_result == null) return;

  if (_result['jwt'].toString().isNotEmpty) {
    SharedPreferences.getInstance().then((_p) async {
      _p.setString("jwt", _result['jwt']);
      _p.setString("userId", _result['user']['id'].toString());
      print('jwt: ${_result['jwt'].toString()}');

      await UserInfoOperate.whenLogin(_result['jwt'].toString());
      _goToMain(ctx);
    });
  }
}

void _goToMain(Context<LoginPageState> ctx) async {
  await FirebaseMessaging.instance.getToken().then((String token) async {
    if (token != null) {
      print("_goToMain Push Messaging token: $token");

      await SharedPreferences.getInstance().then((_p) async {
        var userId = _p.getString("userId");
        await UserInfoOperate.savePushToken(userId, token);
      });
    }
  });

  var globalState = GlobalStore.store.getState();

  for (var i = 0; i < globalState.storesList.length; i++) {
    var store = globalState.storesList[i];
    if (globalState.user.storeFavorite['id'] == store.id) {
      GlobalStore.store.dispatch(
        GlobalActionCreator.setSelectedStore(store),
      );
      Navigator.of(ctx.context).pushReplacementNamed('storepage');
      return null;
    }
  }

  Navigator.of(ctx.context).pushReplacementNamed('storeselectionpage');

  // Navigator.of(ctx.context).pushReplacement(PageRouteBuilder(
  //     pageBuilder: (_, __, ___) {
  //       return Routes.routes.buildPage('mainpage', {
  //         'pages': List<Widget>.unmodifiable([
  //           Routes.routes.buildPage('chatpage', null),
  //           Routes.routes.buildPage('orderspage', null),
  //           Routes.routes.buildPage('notificationspage', null),
  //         ])
  //       });
  //     },
  //     settings: RouteSettings(name: 'mainpage')));
}

Future<Map<String, dynamic>> _emailSignIn(
    Action action, Context<LoginPageState> ctx) async {
  if (ctx.state.accountTextController.text != '' &&
      ctx.state.passWordTextController.text != '') {
    try {
      final _email = ctx.state.accountTextController.text.trim();
      final result = await BaseGraphQLClient.instance
          .loginWithEmail(_email, ctx.state.passWordTextController.text);
      print('resultException: ${result.hasException}, ${result.exception}');

      if (result.hasException) {
        Toast.show("Error occurred", ctx.context,
            duration: 3, gravity: Toast.BOTTOM);
        return null;
      }
      return result.data['login'];
    } on Exception catch (e) {
      print(e);
      if (e.toString() ==
              'DioError [DioErrorType.RESPONSE]: Http status error [400]' ||
          e.toString() ==
              'DioError [DioErrorType.RESPONSE]: Http status error [403]') {
        Toast.show("Wrong username or password", ctx.context,
            duration: 3, gravity: Toast.BOTTOM);
        ctx.state.submitAnimationController.reverse();
      } else {
        Toast.show(e.toString(), ctx.context,
            duration: 3, gravity: Toast.BOTTOM);
        ctx.state.submitAnimationController.reverse();
      }
    }
  }
  return null;
}

// Future _onSignUp(Action action, Context<LoginPageState> ctx) async {
//   Navigator.of(ctx.context)
//       .push(PageRouteBuilder(pageBuilder: (context, an, _) {
//     return FadeTransition(
//       opacity: an,
//       child: RegisterPage().buildPage(null),
//     );
//   })).then((results) {
//     if (results is PopWithResults) {
//       PopWithResults popResult = results;
//       if (popResult.toPage == 'mainpage')
//         Navigator.of(ctx.context).pop(results.results);
//     }
//   });
// }

// void _onGoogleSignIn(Action action, Context<LoginPageState> ctx) async {
//   ctx.state.submitAnimationController.forward();
//   try {
//     GoogleSignIn _googleSignIn = GoogleSignIn();
//     final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
//     if (googleUser == null)
//       return ctx.state.submitAnimationController.reverse();
//     final GoogleSignInAuthentication googleAuth =
//         await googleUser.authentication;
//     final AuthCredential credential = GoogleAuthProvider.getCredential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );
//     final FirebaseUser user =
//         (await _auth.signInWithCredential(credential)).user;
//     assert(user.email != null);
//     assert(user.displayName != null);
//     assert(!user.isAnonymous);
//     assert(await user.getIdToken() != null);

//     final FirebaseUser currentUser = await _auth.currentUser();
//     assert(user.uid == currentUser.uid);
//     if (user != null) {
//       UserInfoOperate.whenLogin(user, user.displayName);
//       Navigator.of(ctx.context).pop({'s': true, 'name': user.displayName});
//     } else {
//       ctx.state.submitAnimationController.reverse();
//       Toast.show("Google signIn fail", ctx.context,
//           duration: 3, gravity: Toast.BOTTOM);
//     }
//   } on Exception catch (e) {
//     ctx.state.submitAnimationController.reverse();
//     Toast.show(e.toString(), ctx.context, duration: 5, gravity: Toast.BOTTOM);
//   }
// }

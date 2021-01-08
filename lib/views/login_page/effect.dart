import 'package:dosparkles/globalbasestate/action.dart';
import 'package:dosparkles/globalbasestate/store.dart';
import 'package:dosparkles/models/app_user.dart';

import 'package:dosparkles/actions/api/graphql_client.dart';
import 'package:dosparkles/utils/general.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/widgets.dart' hide Action;
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:dosparkles/routes/routes.dart';
import 'action.dart';
import 'state.dart';
import 'package:toast/toast.dart';

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
  print('_onInit');
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
    print('savedToken: $savedToken');
    if (savedToken.isNotEmpty) {
      BaseGraphQLClient.instance.setToken(savedToken);

      print('me');
      final result = await BaseGraphQLClient.instance.me();
      GlobalStore.store.dispatch(GlobalActionCreator.setUser(AppUser(
          name: result.data['me']['user']['name'],
          email: result.data['me']['user']['email'])));

      _goToMain(ctx);
    }
  });
}

void _onBuild(Action action, Context<LoginPageState> ctx) {
  print('_onBuild');
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

  BaseGraphQLClient.instance.setToken(_result['jwt']);

  final result = await BaseGraphQLClient.instance.me();
  GlobalStore.store.dispatch(GlobalActionCreator.setUser(AppUser(
      name: result.data['me']['user']['name'],
      email: result.data['me']['user']['email'])));

  if (_result['jwt'].toString().isNotEmpty) {
    SharedPreferences.getInstance().then((_p) async {
      _p.setString("jwt", _result['jwt']);
      _p.setString("userId", _result['user']['id'].toString());

      _goToMain(ctx);
    });
  }
}

void _goToMain(Context<LoginPageState> ctx) async {
  print('_goToMain');
  // Navigator.of(ctx.context).pushReplacementNamed('order_details_page');

  await FirebaseMessaging.instance.getToken().then((String token) async {
    if (token != null) {
      print("_goToMain Push Messaging token: $token");

      await SharedPreferences.getInstance().then((_p) async {
        var userId = _p.getString("userId");
        // TODO: save push token
      });
    }
  });

  Navigator.of(ctx.context).pushReplacement(PageRouteBuilder(
      pageBuilder: (_, __, ___) {
        return Routes.routes.buildPage('mainpage', {
          'pages': List<Widget>.unmodifiable([
            Routes.routes.buildPage('chatpage', null),
            Routes.routes.buildPage('orderspage', null),
            Routes.routes.buildPage('notificationspage', null),
          ])
        });
      },
      settings: RouteSettings(name: 'mainpage')));
}

Future<Map<String, dynamic>> _emailSignIn(
    Action action, Context<LoginPageState> ctx) async {
  if (ctx.state.accountTextController.text != '' &&
      ctx.state.passWordTextController.text != '') {
    try {
      final _email = ctx.state.accountTextController.text.trim();
      final result = await BaseGraphQLClient.instance
          .loginWithEmail(_email, ctx.state.passWordTextController.text);
      printWrapped('loginResult: ' + result.data.toString());
      printWrapped('hasException: ' + result.hasException.toString());
      printWrapped('exception: ' + result.exception.toString());
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

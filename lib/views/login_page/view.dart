import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:com.floridainc.dosparkles/style/themestyle.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    LoginPageState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    body: Stack(
      children: <Widget>[
        _BackGround(controller: state.animationController),
        _LoginBody(
          animationController: state.animationController,
          submitAnimationController: state.submitAnimationController,
          accountFocusNode: state.accountFocusNode,
          pwdFocusNode: state.pwdFocusNode,
          accountTextController: state.accountTextController,
          passWordTextController: state.passWordTextController,
          dispatch: dispatch,
        ),
      ],
    ),
    appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), child: _AppBar()),
  );
}

class _BackGround extends StatelessWidget {
  final AnimationController controller;
  const _BackGround({this.controller});
  @override
  Widget build(BuildContext context) {
    Adapt.initContext(context);

    return Column(children: [
      Expanded(child: SizedBox()),
    ]);
  }
}

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(
          child: Text("Login"
              // AppLocalizations.of(context).loginPageTitle
              )),
      flexibleSpace: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [
                HexColor('#3D9FB0'),
                HexColor('#557084'),
              ],
              begin: const FractionalOffset(0.5, 0.5),
              end: const FractionalOffset(0.5, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
      ),
    );
  }
}

class _EmailEntry extends StatelessWidget {
  final AnimationController controller;
  final TextEditingController accountTextController;
  final TextEditingController passWordTextController;
  final FocusNode accountFocusNode;
  final FocusNode pwdFocusNode;
  final Function(String) onSubmit;
  const _EmailEntry(
      {this.controller,
      this.accountFocusNode,
      this.pwdFocusNode,
      this.accountTextController,
      this.passWordTextController,
      this.onSubmit});
  @override
  Widget build(BuildContext context) {
    final accountCurve = CurvedAnimation(
      parent: controller,
      curve: Interval(
        0.3,
        0.5,
        curve: Curves.ease,
      ),
    );
    final passwordCurve = CurvedAnimation(
      parent: controller,
      curve: Interval(
        0.4,
        0.6,
        curve: Curves.ease,
      ),
    );
    final _theme = ThemeStyle.getTheme(context);

    return Column(children: [
      SlideTransition(
        position:
            Tween(begin: Offset(0, 1), end: Offset.zero).animate(accountCurve),
        child: FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(accountCurve),
            child: Padding(
              padding: EdgeInsets.all(Adapt.px(40)),
              child: TextField(
                focusNode: accountFocusNode,
                controller: accountTextController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                style: TextStyle(fontSize: Adapt.px(35)),
                cursorColor: _theme.iconTheme.color,
                decoration: InputDecoration(
                    fillColor: Colors.transparent,
                    hintText: 'email',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    filled: true,
                    prefixStyle: TextStyle(fontSize: Adapt.px(35)),
                    focusedBorder: new UnderlineInputBorder(
                        borderSide: new BorderSide(color: Colors.black87))),
                onSubmitted: (s) {
                  accountFocusNode.nextFocus();
                },
              ),
            )),
      ),
      SlideTransition(
        position:
            Tween(begin: Offset(0, 1), end: Offset.zero).animate(passwordCurve),
        child: FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(passwordCurve),
          child: Padding(
            padding: EdgeInsets.all(Adapt.px(40)),
            child: TextField(
              focusNode: pwdFocusNode,
              controller: passWordTextController,
              style: TextStyle(fontSize: Adapt.px(35)),
              cursorColor: _theme.iconTheme.color,
              obscureText: true,
              decoration: InputDecoration(
                  fillColor: Colors.transparent,
                  hintText: 'password',
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  filled: true,
                  prefixStyle: TextStyle(fontSize: Adapt.px(35)),
                  focusedBorder: new UnderlineInputBorder(
                      borderSide: new BorderSide(color: Colors.black87))),
              onSubmitted: onSubmit,
            ),
          ),
        ),
      ),
    ]);
  }
}

class _SubmitButton extends StatelessWidget {
  final AnimationController controller;
  final Function onSubimt;
  const _SubmitButton({this.controller, this.onSubimt});
  @override
  Widget build(BuildContext context) {
    final submitWidth = CurvedAnimation(
      parent: controller,
      curve: Interval(
        0.0,
        0.5,
        curve: Curves.ease,
      ),
    );
    final loadCurved = CurvedAnimation(
      parent: controller,
      curve: Interval(
        0.5,
        1.0,
        curve: Curves.ease,
      ),
    );
    return AnimatedBuilder(
      animation: controller,
      builder: (ctx, w) {
        double buttonWidth = Adapt.screenW() * 0.8;
        return Container(
          margin: EdgeInsets.only(top: Adapt.px(60)),
          height: Adapt.px(100),
          child: Stack(
            children: <Widget>[
              Container(
                height: Adapt.px(100),
                width: Tween<double>(begin: buttonWidth, end: Adapt.px(100))
                    .animate(submitWidth)
                    .value,
                child: FlatButton(
                  color: HexColor("#182465"),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Adapt.px(50))),
                  child: Text('Sign In',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: Tween<double>(begin: Adapt.px(35), end: 0.0)
                              .animate(submitWidth)
                              .value)),
                  onPressed: onSubimt,
                ),
              ),
              ScaleTransition(
                scale: Tween(begin: 0.0, end: 1.0).animate(loadCurved),
                child: Container(
                  width: Adapt.px(100),
                  height: Adapt.px(100),
                  padding: EdgeInsets.all(Adapt.px(20)),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Adapt.px(50))),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class _LoginBody extends StatelessWidget {
  final Dispatch dispatch;
  final AnimationController animationController;
  final AnimationController submitAnimationController;
  final TextEditingController phoneTextController;
  final TextEditingController codeTextContraller;
  final TextEditingController accountTextController;
  final TextEditingController passWordTextController;
  final FocusNode accountFocusNode;
  final FocusNode pwdFocusNode;
  const _LoginBody({
    this.accountFocusNode,
    this.accountTextController,
    this.animationController,
    this.codeTextContraller,
    this.dispatch,
    this.passWordTextController,
    this.phoneTextController,
    this.pwdFocusNode,
    this.submitAnimationController,
  });
  @override
  Widget build(BuildContext context) {
    final cardCurve = CurvedAnimation(
      parent: animationController,
      curve: Interval(
        0,
        0.4,
        curve: Curves.ease,
      ),
    );
    final submitCurve = CurvedAnimation(
      parent: animationController,
      curve: Interval(
        0.5,
        0.7,
        curve: Curves.ease,
      ),
    );

    return Center(
      child: SlideTransition(
        position:
            Tween(begin: Offset(0, 1), end: Offset.zero).animate(cardCurve),
        child: Card(
          elevation: 10,
          child: Container(
            height: Adapt.screenH() / 2,
            width: Adapt.screenW() * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: _EmailEntry(
                      onSubmit: (s) =>
                          dispatch(LoginPageActionCreator.onLoginClicked()),
                      controller: animationController,
                      accountFocusNode: accountFocusNode,
                      pwdFocusNode: pwdFocusNode,
                      accountTextController: accountTextController,
                      passWordTextController: passWordTextController,
                    )),
                SlideTransition(
                    position: Tween(begin: Offset(0, 1), end: Offset.zero)
                        .animate(submitCurve),
                    child: FadeTransition(
                      opacity: Tween(begin: 0.0, end: 1.0).animate(submitCurve),
                      child: _SubmitButton(
                        controller: submitAnimationController,
                        onSubimt: () =>
                            dispatch(LoginPageActionCreator.onLoginClicked()),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

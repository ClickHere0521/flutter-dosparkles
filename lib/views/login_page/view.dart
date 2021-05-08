import 'dart:ui';

import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/widgets/connection_lost.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    LoginPageState state, Dispatch dispatch, ViewService viewService) {
  return _MainBody(state: state, dispatch: dispatch);
}

class _MainBody extends StatefulWidget {
  final LoginPageState state;
  final Dispatch dispatch;

  _MainBody({Key key, this.state, this.dispatch}) : super(key: key);

  @override
  __MainBodyState createState() => __MainBodyState();
}

class __MainBodyState extends State<_MainBody> {
  bool _isLostConnection = false;

  checkInternetConnectivity() {
    String _connectionStatus = GlobalStore.store.getState().connectionStatus;
    if (_connectionStatus == 'ConnectivityResult.none') {
      setState(() {
        _isLostConnection = true;
      });
    } else {
      setState(() {
        _isLostConnection = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    checkInternetConnectivity();

    return Container(
      color: HexColor("#F2F6FA"),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "images/background_lines_top.png",
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "images/background_lines_bottom.png",
              fit: BoxFit.contain,
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            appBar: null,
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
              ),
              child: _InnerPart(
                state: widget.state,
                dispatch: widget.dispatch,
              ),
            ),
          ),
          if (_isLostConnection) ConnectionLost(),
        ],
      ),
    );
  }
}

class _InnerPart extends StatefulWidget {
  final LoginPageState state;
  final Dispatch dispatch;

  _InnerPart({Key key, this.state, this.dispatch}) : super(key: key);

  @override
  __InnerPartState createState() => __InnerPartState();
}

class __InnerPartState extends State<_InnerPart> {
  final _formKey = GlobalKey<FormState>();
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        // height: MediaQuery.of(context).size.height -
        //     Scaffold.of(context).appBarMaxHeight,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.02,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.07),
              Image.asset("images/Group 319.png"),
              SizedBox(height: MediaQuery.of(context).size.height * 0.002),
              Text(
                "Welcome to Sparkle!",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w900,
                  fontFeatures: [FontFeature.enable('smcp')],
                  color: HexColor("#53586F"),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.002),
              Text(
                "Please sign in to continue",
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Column(
                children: [
                  TextFormField(
                    textAlign: TextAlign.left,
                    keyboardType: TextInputType.emailAddress,
                    controller: widget.state.accountTextController,
                    decoration: InputDecoration(
                      hintText: 'yourname@example.com',
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.black26,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 5),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#C4C6D2")),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#C4C6D2")),
                      ),
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        height: 0.7,
                        fontSize: 22,
                      ),
                    ),
                    onFieldSubmitted: (value) {
                      widget.dispatch(LoginPageActionCreator.onLoginClicked());
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field must not be empty';
                      } else if (!EmailValidator.validate(value)) {
                        return 'Please enter a valid Email address';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 21),
                  TextFormField(
                    textAlign: TextAlign.left,
                    obscureText: _hidePassword,
                    controller: widget.state.passWordTextController,
                    decoration: InputDecoration(
                      hintText: 'Your password',
                      hintStyle: TextStyle(fontSize: 16, color: Colors.black26),
                      contentPadding: EdgeInsets.symmetric(vertical: 5),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Password',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#C4C6D2")),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#C4C6D2")),
                      ),
                      labelStyle: TextStyle(
                        color: Colors.black,
                        height: 0.7,
                        fontSize: 22,
                      ),
                      suffixIcon: Padding(
                        padding:
                            EdgeInsetsDirectional.only(start: 12.0, top: 12.0),
                        child: InkWell(
                          child: Icon(
                            _hidePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black26,
                          ),
                          onTap: () {
                            setState(() {
                              _hidePassword = !_hidePassword;
                            });
                          },
                        ),
                      ),
                    ),
                    onFieldSubmitted: (value) {
                      widget.dispatch(LoginPageActionCreator.onLoginClicked());
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field must not be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      child: Text(
                        "Forgot password?",
                        style: TextStyle(fontSize: 15),
                      ),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed('forgot_passwordpage', arguments: null);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Column(
                children: [
                  Container(
                    width: 300.0,
                    height: 48.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(31.0),
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor:
                            MaterialStateProperty.all(HexColor("#6092DC")),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(31.0),
                          ),
                        ),
                      ),
                      child: Text(
                        'Sign in',
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          widget.dispatch(
                              LoginPageActionCreator.onLoginClicked());
                        }
                      },
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.018),
                  GestureDetector(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Don't have account yet? ",
                            style:
                                TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                          TextSpan(
                            text: "Sign Up",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed('registrationpage', arguments: null);
                    },
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Column(
                children: [
                  Text(
                    "Or sign in with",
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "images/Google_icon.png",
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: 16),
                      Image.asset(
                        "images/Snapchat_icon.png",
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: 16),
                      Image.asset(
                        "images/Group 84.png",
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: 16),
                      Image.asset(
                        "images/Group 85.png",
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

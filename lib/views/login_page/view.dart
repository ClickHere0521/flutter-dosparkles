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
  @override
  Widget build(BuildContext context) {
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
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
            ),
            body: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      "Welcome!",
                      style: TextStyle(fontSize: 32),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Please sign in to continue",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 50),
                    _InnerPart(state: widget.state, dispatch: widget.dispatch),
                  ],
                ),
              ),
            ),
          ),
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
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 15),
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
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            SizedBox(height: 25),
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
                labelStyle: TextStyle(
                  color: Colors.black,
                  height: 0.7,
                  fontSize: 22,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _hidePassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black26,
                  ),
                  onPressed: () {
                    setState(() {
                      _hidePassword = !_hidePassword;
                    });
                  },
                ),
              ),
              onFieldSubmitted: (value) {
                widget.dispatch(LoginPageActionCreator.onLoginClicked());
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            SizedBox(height: 15),
            Align(
              alignment: Alignment.centerRight,
              child: Text("Forgot password?", style: TextStyle(fontSize: 15)),
            ),
            SizedBox(height: 180),
            ButtonTheme(
              minWidth: 300.0,
              height: 48.0,
              child: RaisedButton(
                textColor: Colors.white,
                elevation: 0,
                color: HexColor("#6092DC"),
                child: Text(
                  'Sign in',
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    widget.dispatch(LoginPageActionCreator.onLoginClicked());
                  }
                },
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(31.0),
                ),
              ),
            ),
            SizedBox(height: 10),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Don't have account yet? ",
                    style: TextStyle(color: Colors.black54, fontSize: 16),
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
            SizedBox(height: 180),
            Column(
              children: [
                Text(
                  "Or sign in with",
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "images/Google_icon.png",
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 20),
                    Image.asset(
                      "images/Snapchat_icon.png",
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

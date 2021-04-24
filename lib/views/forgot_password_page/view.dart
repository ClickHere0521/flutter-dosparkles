import 'dart:ui';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../actions/api/graphql_client.dart';
import '../../utils/colors.dart';
import '../../utils/general.dart';
import 'state.dart';

Widget buildView(
  ForgotPasswordPageState state,
  Dispatch dispatch,
  ViewService viewService,
) {
  Adapt.initContext(viewService.context);
  return _MainBody();
}

class _MainBody extends StatefulWidget {
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
              centerTitle: true,
              elevation: 0.0,
              leadingWidth: 70.0,
              automaticallyImplyLeading: false,
              leading: InkWell(
                child: Image.asset("images/back_button.png"),
                onTap: () => Navigator.of(context).pop(),
              ),
              backgroundColor: Colors.transparent,
              title: Text(
                "Forgot Password?",
                style: TextStyle(
                  fontSize: 22,
                  color: HexColor("#53586F"),
                  fontWeight: FontWeight.w600,
                  fontFeatures: [FontFeature.enable('smcp')],
                ),
              ),
            ),
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
              ),
              child: _InnerPart(),
            ),
          ),
        ],
      ),
    );
  }
}

class _InnerPart extends StatefulWidget {
  @override
  __InnerPartState createState() => __InnerPartState();
}

class __InnerPartState extends State<_InnerPart> {
  final _formKey = GlobalKey<FormState>();
  String emailValue = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height -
            Scaffold.of(context).appBarMaxHeight,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Enter your email to reset your password",
                style: TextStyle(fontSize: 16),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.10,
                ),
                child: TextFormField(
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    setState(() => emailValue = value);
                  },
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.30,
                ),
                child: Column(
                  children: [
                    ButtonTheme(
                      minWidth: 300.0,
                      height: 48.0,
                      child: RaisedButton(
                        textColor: Colors.white,
                        elevation: 0,
                        color: HexColor("#6092DC"),
                        child: Text(
                          'Reset Password',
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        onPressed: () {
                          _onSubmit(_formKey, emailValue);
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
                            text: "Back to ",
                            style:
                                TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                          TextSpan(
                            text: "Sign in",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _onSubmit(formKey, emailValue) async {
  if (formKey.currentState.validate()) {
    try {
      QueryResult result =
          await BaseGraphQLClient.instance.forgotPassword(emailValue);
      if (result.hasException) print(result.exception);
    } catch (e) {
      print(e);
    }
  }
}

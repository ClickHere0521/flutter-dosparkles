import 'dart:ffi';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import '../../utils/colors.dart';
import 'state.dart';

Widget buildView(
  RegisterPageState state,
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
            resizeToAvoidBottomPadding: false,
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
            ),
            body: Container(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      "Register",
                      style: TextStyle(fontSize: 32),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Choose a way to register",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 75),
                    _InnerPart(),
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
  @override
  __InnerPartState createState() => __InnerPartState();
}

class __InnerPartState extends State<_InnerPart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(10.0),
            child: Ink(
              width: MediaQuery.of(context).size.width,
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 17,
                    child: Image.asset(
                      "images/apple_icon_small.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    left: 60,
                    child: Text(
                      "Continue with Apple",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () => null,
          ),
          SizedBox(height: 13),
          InkWell(
            borderRadius: BorderRadius.circular(10.0),
            child: Ink(
              width: MediaQuery.of(context).size.width,
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 17,
                    child: Image.asset(
                      "images/google_icon_small.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    left: 60,
                    child: Text(
                      "Continue with Google",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () => null,
          ),
          SizedBox(height: 13),
          InkWell(
            borderRadius: BorderRadius.circular(10.0),
            child: Ink(
              width: MediaQuery.of(context).size.width,
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 17,
                    child: Image.asset(
                      "images/snapchat_icon_small.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    left: 60,
                    child: Text(
                      "Continue with Snapchat",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () => null,
          ),
          SizedBox(height: 13),
          InkWell(
            borderRadius: BorderRadius.circular(10.0),
            child: Ink(
              width: MediaQuery.of(context).size.width,
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 17,
                    child: Image.asset(
                      "images/email_icon_small.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    left: 60,
                    child: Text(
                      "Continue with Email",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () => null,
          ),
          SizedBox(height: 34),
          Text("OR", style: TextStyle(fontSize: 17)),
          SizedBox(height: 17),
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
              onPressed: () {},
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(31.0),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "By contining you indicate thst you have read and agree our Teams of Service & Privacy Policy",
            style: TextStyle(color: Colors.black54, fontSize: 12, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

import 'dart:ui';

import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/widgets/connection_lost.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../actions/api/graphql_client.dart';
import '../../utils/colors.dart';
import '../../utils/general.dart';
import 'state.dart';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';

Widget buildView(
  ResetPasswordPageState state,
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
                "Change Password",
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
          if (_isLostConnection) ConnectionLost(),
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
  String oldValue = '';
  bool oldHide = true;
  String newValue = '';
  bool newHide = true;
  String repeatValue = '';
  bool repeatHide = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height -
          Scaffold.of(context).appBarMaxHeight,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Column(
                children: [
                  TextFormField(
                    textAlign: TextAlign.left,
                    obscureText: oldHide,
                    onChanged: (value) {
                      setState(() {
                        oldValue = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter here',
                      hintStyle: TextStyle(fontSize: 16, color: Colors.black26),
                      contentPadding: EdgeInsets.symmetric(vertical: 5),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#C4C6D2")),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#C4C6D2")),
                      ),
                      labelText: 'Old Password',
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
                            oldHide ? Icons.visibility_off : Icons.visibility,
                            color: Colors.black26,
                          ),
                          onTap: () {
                            setState(() {
                              oldHide = !oldHide;
                            });
                          },
                        ),
                      ),
                    ),
                    onFieldSubmitted: (value) {},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field must not be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  TextFormField(
                    textAlign: TextAlign.left,
                    obscureText: newHide,
                    onChanged: (value) {
                      setState(() {
                        newValue = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter here',
                      hintStyle: TextStyle(fontSize: 16, color: Colors.black26),
                      contentPadding: EdgeInsets.symmetric(vertical: 5),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'New Password',
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
                            newHide ? Icons.visibility_off : Icons.visibility,
                            color: Colors.black26,
                          ),
                          onTap: () {
                            setState(() {
                              newHide = !newHide;
                            });
                          },
                        ),
                      ),
                    ),
                    onFieldSubmitted: (value) {},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field must not be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  TextFormField(
                    textAlign: TextAlign.left,
                    obscureText: repeatHide,
                    onChanged: (value) {
                      setState(() {
                        repeatValue = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter here',
                      hintStyle: TextStyle(fontSize: 16, color: Colors.black26),
                      contentPadding: EdgeInsets.symmetric(vertical: 5),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        height: 0.7,
                        fontSize: 22,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#C4C6D2")),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#C4C6D2")),
                      ),
                      suffixIcon: Padding(
                        padding:
                            EdgeInsetsDirectional.only(start: 12.0, top: 12.0),
                        child: InkWell(
                          child: Icon(
                            repeatHide
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black26,
                          ),
                          onTap: () {
                            setState(() {
                              repeatHide = !repeatHide;
                            });
                          },
                        ),
                      ),
                    ),
                    onFieldSubmitted: (value) {},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field must not be empty';
                      } else if (value != newValue) {
                        return 'Password are not matching';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.06),
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
                        MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.disabled))
                        return HexColor("#C4C6D2");
                      return HexColor("#6092DC");
                    }),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(31.0),
                      ),
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: repeatValue != newValue ||
                          repeatValue.length == 0 ||
                          newValue.length == 0 ||
                          oldValue.length == 0
                      ? null
                      : () {
                          if (_formKey.currentState.validate()) {
                            _onSubmit(oldValue, newValue, repeatValue);
                          }
                        },
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.20),
            ],
          ),
        ),
      ),
    );
  }
}

void _onSubmit(oldValue, newValue, repeatValue) async {
  try {
    // QueryResult result =
    //     await BaseGraphQLClient.instance.forgotPassword(emailValue);
    // if (result.hasException) print(result.exception);
  } catch (e) {
    print(e);
  }
}

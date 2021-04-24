import 'dart:ui';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import '../../utils/colors.dart';
import 'state.dart';

Widget buildView(
  RegistrationPageState state,
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
              elevation: 0.0,
              centerTitle: true,
              leadingWidth: 70.0,
              automaticallyImplyLeading: false,
              leading: InkWell(
                child: Image.asset("images/back_button.png"),
                onTap: () => Navigator.of(context).pop(),
              ),
              backgroundColor: Colors.transparent,
              title: Text(
                "Create Account",
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
  String passwordValue = '';
  String firstNameValue = '';
  String lastNameValue = '';
  bool _hidePassword = false;
  bool checkboxValue = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Follow 2 easy steps to create an account",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.10),
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        setState(() => firstNameValue = value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter here',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.black26,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 5),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'First Name',
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
                  SizedBox(width: 23),
                  Flexible(
                    child: TextFormField(
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        setState(() => lastNameValue = value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter here',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.black26,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 5),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Last Name',
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
                ],
              ),
              SizedBox(height: 25),
              TextFormField(
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
              SizedBox(height: 25),
              TextFormField(
                textAlign: TextAlign.left,
                onChanged: (value) {
                  setState(() => passwordValue = value);
                },
                obscureText: _hidePassword,
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
                  suffixIcon: Padding(
                    padding: EdgeInsetsDirectional.only(start: 12.0, top: 12.0),
                    child: InkWell(
                      child: Icon(
                        _hidePassword ? Icons.visibility : Icons.visibility_off,
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              Row(
                children: <Widget>[
                  SizedBox(
                    height: 16.0,
                    width: 16.0,
                    child: Checkbox(
                      // checkColor: Colors.greenAccent,
                      // activeColor: Colors.red,
                      value: this.checkboxValue,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      onChanged: (bool value) {
                        setState(() {
                          this.checkboxValue = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 13),
                  Text(
                    'Agree with Terms & Conditions',
                    style: TextStyle(fontSize: 13.0),
                  ),
                ],
              ),
              SizedBox(height: 18),
              ButtonTheme(
                minWidth: 300.0,
                height: 48.0,
                child: RaisedButton(
                  textColor: Colors.white,
                  elevation: 0,
                  color: HexColor("#6092DC"),
                  child: Text(
                    'Next',
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
      // QueryResult result =
      //     await BaseGraphQLClient.instance.forgotPassword(emailValue);
      // if (result.hasException) print(result.exception);
    } catch (e) {
      print(e);
    }
  }
}

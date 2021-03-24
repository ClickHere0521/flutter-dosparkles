import 'dart:convert';

import 'package:com.floridainc.dosparkles/views/reset_password_page/state.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../actions/api/graphql_client.dart';
import '../../globalbasestate/store.dart';
import '../../utils/colors.dart';
import '../../utils/general.dart';

Widget buildView(
  ResetPasswordPageState state,
  Dispatch dispatch,
  ViewService viewService,
) {
  Adapt.initContext(viewService.context);
  return Scaffold(
    appBar: AppBar(
      title: Text("Reset Password"),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [HexColor('#3D9FB0'), HexColor('#557084')],
            begin: const FractionalOffset(0.5, 0.5),
            end: const FractionalOffset(0.5, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
      ),
    ),
    body: Container(
      color: HexColor('#3D9FB0'),
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(children: [
          SizedBox(height: 50),
          ResetForm(),
          BottomPart(),
        ]),
      ),
    ),
  );
}

class BottomPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          SizedBox(height: 20),
          Text("Or SignUp Using", style: TextStyle(fontSize: 20.0)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.fact_check_sharp, size: 40),
              SizedBox(width: 10),
              Icon(Icons.g_translate, size: 40),
            ],
          ),
          SizedBox(height: 20),
          Text(
            "Already Have an Account ?",
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(height: 20),
          TextButton(
            child: Text(
              "Log In",
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
            onPressed: () => null,
          )
        ],
      ),
    );
  }
}

class ResetForm extends StatefulWidget {
  @override
  ResetFormState createState() {
    return ResetFormState();
  }
}

class ResetFormState extends State<ResetForm> {
  final _formKey = GlobalKey<FormState>();
  String passwordValue = '';
  String repeatPassValue = '';

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width / 1.2,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 15),
              TextFormField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.visiblePassword,
                onChanged: (value) {
                  setState(() => passwordValue = value);
                },
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(fontSize: 20),
                  prefixIcon: Icon(Icons.email),
                  filled: true,
                  contentPadding: EdgeInsets.all(14),
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.visiblePassword,
                onChanged: (value) {
                  setState(() => repeatPassValue = value);
                },
                decoration: InputDecoration(
                  hintText: 'Retype Password',
                  hintStyle: TextStyle(fontSize: 20),
                  prefixIcon: Icon(Icons.email),
                  filled: true,
                  contentPadding: EdgeInsets.all(14),
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ButtonTheme(
                  minWidth: 220.0,
                  height: 45.0,
                  child: OutlineButton(
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    shape: StadiumBorder(),
                    borderSide: BorderSide(color: Colors.white, width: 2),
                    onPressed: () {
                      _onSubmit(_formKey, passwordValue, repeatPassValue);
                    },
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

void _onSubmit(formKey, passwordValue, repeatPassValue) async {
  if (formKey.currentState.validate()) {
    try {
      var user = await BaseGraphQLClient.instance.me();
      QueryResult result = await BaseGraphQLClient.instance.resetPassword(
        passwordValue,
        repeatPassValue,
        user.data['me']['id'],
      );

      print("____DATA____${result.data}");
      printWrapped(result.exception.toString());
    } catch (e) {
      print(e);
    }
  }
}

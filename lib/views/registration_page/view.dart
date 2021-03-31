import 'package:http/http.dart' as http;

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../actions/api/graphql_client.dart';
import '../../utils/colors.dart';
import '../../utils/general.dart';
import 'state.dart';
import 'dart:io';

Widget buildView(
    RegistrationPageState state, Dispatch dispatch, ViewService viewService) {
  Adapt.initContext(viewService.context);
  return Scaffold(
    appBar: AppBar(
      title: Text("Sign Up"),
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
          SignInForm(),
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
          SignInAppleWidget(),
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

class SignInAppleWidget extends StatefulWidget {
  @override
  _SignInAppleWidgetState createState() => _SignInAppleWidgetState();
}

class _SignInAppleWidgetState extends State<SignInAppleWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      child: SignInWithAppleButton(
        text: "Sign in",
        onPressed: () async {
          final credential = await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
            webAuthenticationOptions: WebAuthenticationOptions(
              // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
              clientId: 'com.aboutyou.dart_packages.sign_in_with_apple.example',
              redirectUri: Uri.parse(
                'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
              ),
            ),
          );

          print("______credential:$credential");

          // This is the endpoint that will convert an authorization code obtained
          // via Sign in with Apple into a session in your system
          final signInWithAppleEndpoint = Uri(
            scheme: 'https',
            host: 'flutter-sign-in-with-apple-example.glitch.me',
            path: '/sign_in_with_apple',
            queryParameters: <String, String>{
              'code': credential.authorizationCode,
              if (credential.givenName != null)
                'firstName': credential.givenName,
              if (credential.familyName != null)
                'lastName': credential.familyName,
              'useBundleId':
                  Platform.isIOS || Platform.isMacOS ? 'true' : 'false',
              if (credential.state != null) 'state': credential.state,
            },
          );

          final session = await http.Client().post(
            signInWithAppleEndpoint,
          );

          // If we got this far, a session based on the Apple ID credential has been created in your system,
          // and you can now set this as the app's session
          print("______session:$session");
        },
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  @override
  SignInFormState createState() {
    return SignInFormState();
  }
}

class SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  String emailValue = '';
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
              TextFormField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Name',
                  hintStyle: TextStyle(fontSize: 20),
                  prefixIcon: Icon(Icons.person),
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
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  setState(() => emailValue = value);
                },
                decoration: InputDecoration(
                  hintText: 'Email',
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
                  setState(() => passwordValue = value);
                },
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(fontSize: 20),
                  prefixIcon: Icon(Icons.vpn_key_sharp),
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
                  prefixIcon: Icon(Icons.vpn_key_sharp),
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
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Country',
                  hintStyle: TextStyle(fontSize: 20),
                  prefixIcon: Icon(Icons.location_on),
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
                      _onSubmit(
                        _formKey,
                        emailValue,
                        passwordValue,
                        repeatPassValue,
                      );
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

void _onSubmit(
  formKey,
  emailValue,
  passwordValue,
  repeatPassValue,
) async {
  if (formKey.currentState.validate()) {
    try {
      if (passwordValue == repeatPassValue) {
        QueryResult result =
            await BaseGraphQLClient.instance.signUp(emailValue, passwordValue);

        print("____DATA____${result.data}");
        printWrapped(result.exception.toString());
      }
    } catch (e) {
      print(e);
    }
  }
}

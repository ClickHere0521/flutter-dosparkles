// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();

class MyAppGoogle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo',
      home: MyHomePage(title: 'Firebase Auth Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<String> _message = Future<String>.value('');
  TextEditingController _smsCodeController = TextEditingController();
  String verificationId;
  final String testSmsCode = '888888';
  final String testPhoneNumber = '+1 408-555-6969';

  Future<String> _testSignInAnonymously() async {
    return 'signInAnonymously succeeded';
  }

  Future<String> _testSignInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    return 'signInWithGoogle succeeded: ';
  }

  Future<void> _testVerifyPhoneNumber() async {}

  Future<String> _testSignInWithPhoneNumber(String smsCode) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MaterialButton(
              child: const Text('Test signInAnonymously'),
              onPressed: () {
                setState(() {
                  _message = _testSignInAnonymously();
                });
              }),
          MaterialButton(
              child: const Text('Test signInWithGoogle'),
              onPressed: () {
                setState(() {
                  _message = _testSignInWithGoogle();
                });
              }),
          MaterialButton(
              child: const Text('Test verifyPhoneNumber'),
              onPressed: () {
                _testVerifyPhoneNumber();
              }),
          Container(
            margin: const EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 16.0,
              right: 16.0,
            ),
            child: TextField(
              controller: _smsCodeController,
              decoration: const InputDecoration(
                hintText: 'SMS Code',
              ),
            ),
          ),
          MaterialButton(
              child: const Text('Test signInWithPhoneNumber'),
              onPressed: () {
                if (_smsCodeController.text != null) {
                  setState(() {
                    _message =
                        _testSignInWithPhoneNumber(_smsCodeController.text);
                  });
                }
              }),
          FutureBuilder<String>(
              future: _message,
              builder: (_, AsyncSnapshot<String> snapshot) {
                return Text(snapshot.data ?? '',
                    style:
                        const TextStyle(color: Color.fromARGB(255, 0, 155, 0)));
              }),
        ],
      ),
    );
  }
}

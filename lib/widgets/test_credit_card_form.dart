import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';

class CreditCardFormCustom extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreditCardFormCustomState();
  }
}

class CreditCardFormCustomState extends State<CreditCardFormCustom> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Credit Card View Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CreditCardForm(
                        formKey: formKey,
                        obscureCvv: true,
                        obscureNumber: false,
                        cardHolderDecoration: InputDecoration(
                          hintText: 'Enter your cardholder name',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: HexColor("#C4C6D2")),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: HexColor("#C4C6D2")),
                          ),
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.black26,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 5),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Cardholder name',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            height: 0.7,
                            fontSize: 22,
                          ),
                        ),
                        cardNumberDecoration: InputDecoration(
                          hintText: 'Enter ',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: HexColor("#C4C6D2")),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: HexColor("#C4C6D2")),
                          ),
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.black26,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 5),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Card number',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            height: 0.7,
                            fontSize: 22,
                          ),
                        ),
                        expiryDateDecoration: InputDecoration(
                          hintText: 'Enter date',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: HexColor("#C4C6D2")),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: HexColor("#C4C6D2")),
                          ),
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.black26,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 5),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Expiry date',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            height: 0.7,
                            fontSize: 22,
                          ),
                        ),
                        cvvCodeDecoration: InputDecoration(
                          hintText: 'Enter CVV',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: HexColor("#C4C6D2")),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: HexColor("#C4C6D2")),
                          ),
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.black26,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 5),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'CVV',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            height: 0.7,
                            fontSize: 22,
                          ),
                        ),
                        onCreditCardModelChange: onCreditCardModelChange,
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          child: const Text(
                            'Validate',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'halter',
                              fontSize: 14,
                              package: 'flutter_credit_card',
                            ),
                          ),
                        ),
                        color: const Color(0xff1b447b),
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            print('valid!');
                          } else {
                            print('invalid!');
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}

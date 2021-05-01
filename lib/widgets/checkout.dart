import 'dart:ui';

import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Checkout extends StatefulWidget {
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  bool isNextPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        backgroundColor: Colors.white,
        title: Text(
          "Checkout",
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
        color: Colors.white,
        child: isNextPage ? _InnerCardPart() : _InnerPart(),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: double.infinity,
        constraints: BoxConstraints(maxHeight: 87.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.9),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16.0),
            topLeft: Radius.circular(16.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300],
              offset: Offset(0.0, -0.2), // (x, y)
              blurRadius: 10.0,
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: Container(
            width: 300.0,
            height: 48.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(31.0),
            ),
            child: ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(HexColor("#6092DC")),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(31.0),
                  ),
                ),
              ),
              child: Text(
                isNextPage ? "Pay now" : 'Continue To Payment',
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                setState(() {
                  isNextPage = true;
                });
              },
            ),
          ),
        ),
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
  String addressValue = '';
  String apartmentValue = '';
  String firstNameValue = '';
  String lastNameValue = '';
  bool checkboxValue = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("images/Group 203.png"),
                      Dash(
                        direction: Axis.horizontal,
                        length: 210,
                        dashLength: 10,
                        dashColor: HexColor("#C4C6D2"),
                      ),
                      Image.asset("images/Group 204.png"),
                    ],
                  ),
                  SizedBox(height: 7.0),
                  Container(
                    width: 320.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Shipping info",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            foreground: Paint()
                              ..shader = LinearGradient(
                                colors: [
                                  HexColor('#CBD3FD'),
                                  HexColor('#8DA3EA')
                                ],
                                begin: const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(1.0, 0.0),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp,
                              ).createShader(
                                  Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                          ),
                        ),
                        Text(
                          "Payment info",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            color: HexColor("#C4C6D2"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 28.0),
            Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    Scaffold.of(context).appBarMaxHeight * 2,
              ),
              decoration: BoxDecoration(
                color: HexColor("#FAFCFF"),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(32.0),
                  topLeft: Radius.circular(32.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300],
                    offset: Offset(0.0, -0.2), // (x, y)
                    blurRadius: 10.0,
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.0),
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
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
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
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
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
                    SizedBox(height: 20.0),
                    TextFormField(
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        setState(() => addressValue = value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your address',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.black26,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 5),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Address',
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
                    SizedBox(height: 10.0),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(14.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[300],
                            offset: Offset(0.0, 2.0), // (x, y)
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "4913, Sugar Pine, Boca Raton",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: HexColor("#0F142B"),
                            ),
                          ),
                          SizedBox(height: 6.0),
                          Text(
                            "Florida, United Stated",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: HexColor("#0F142B"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        setState(() => addressValue = value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your apartment',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.black26,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 5),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Apartment',
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
                    SizedBox(height: 23),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          height: 16.0,
                          width: 16.0,
                          child: Checkbox(
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
                          'Save this information for next time',
                          style: TextStyle(fontSize: 13.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InnerCardPart extends StatefulWidget {
  @override
  __InnerCardPartState createState() => __InnerCardPartState();
}

class __InnerCardPartState extends State<_InnerCardPart> {
  final _formKey = GlobalKey<FormState>();
  String addressValue = '';
  String apartmentValue = '';
  String firstNameValue = '';
  String lastNameValue = '';
  bool checkboxValue = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "images/Group 203.png",
                        color: Colors.white.withOpacity(.2),
                      ),
                      Dash(
                        direction: Axis.horizontal,
                        length: 210,
                        dashLength: 10,
                        dashColor: HexColor("#C4C6D2"),
                      ),
                      Image.asset("images/Group 203.png"),
                    ],
                  ),
                  SizedBox(height: 7.0),
                  Container(
                    width: 320.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Shipping info",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            foreground: Paint()
                              ..shader = LinearGradient(
                                colors: [
                                  HexColor('#CBD3FD'),
                                  HexColor('#8DA3EA')
                                ],
                                begin: const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(1.0, 0.0),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp,
                              ).createShader(
                                  Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                          ),
                        ),
                        Text(
                          "Payment info",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            foreground: Paint()
                              ..shader = LinearGradient(
                                colors: [
                                  HexColor('#CBD3FD'),
                                  HexColor('#8DA3EA')
                                ],
                                begin: const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(1.0, 0.0),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp,
                              ).createShader(
                                Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                              ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 28.0),
            Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    Scaffold.of(context).appBarMaxHeight * 2,
              ),
              decoration: BoxDecoration(
                color: HexColor("#FAFCFF"),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(32.0),
                  topLeft: Radius.circular(32.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300],
                    offset: Offset(0.0, -0.2), // (x, y)
                    blurRadius: 10.0,
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "TOTAL PRICE:",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700,
                            color: HexColor("#0F142B"),
                          ),
                        ),
                        Text(
                          "\$79.90",
                          style: TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.w900,
                            color: HexColor("#0F142B"),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.0),
                    TextFormField(
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        setState(() => addressValue = value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your cardholder name',
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Card number",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        SizedBox(height: 7.0),
                        TextFormField(
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            setState(() => addressValue = value);
                          },
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: ' Enter',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.black26,
                            ),
                            prefixIcon:
                                SvgPicture.asset("images/Group 208.svg"),
                            prefixIconConstraints: BoxConstraints(
                              maxWidth: 19.0,
                            ),
                            contentPadding: EdgeInsets.only(
                              top: 5.0,
                              bottom: 5.0,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
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
                              hintText: 'Enter date',
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.black26,
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 5),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: 'Expiry date',
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
                              hintText: 'Enter CVV',
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.black26,
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 5),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: 'CVV',
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
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

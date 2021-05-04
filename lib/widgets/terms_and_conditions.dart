import 'dart:ui';

import 'package:com.floridainc.dosparkles/actions/api/graphql_client.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

Future _fetchData() async {
  QueryResult result = await BaseGraphQLClient.instance.fetchAppContent();
  if (result.hasException) print(result.exception);

  return result.data['appContent']['termsAndConditions'];
}

Future<void> termsDialog(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          padding: EdgeInsets.only(left: 14.0, right: 14.0),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            insetPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
            elevation: 0.0,
            backgroundColor: Colors.white,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -18.0,
                  right: -11.0,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      child: Image.asset("images/close_button_terms.png"),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.80,
                  constraints: BoxConstraints(maxHeight: 648.0),
                  padding: EdgeInsets.only(bottom: 14.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 31.0, bottom: 22.0),
                        child: Center(
                          child: Text(
                            'Terms and Conditions'.toUpperCase(),
                            style: TextStyle(
                              color: HexColor("#6092DC"),
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              fontFeatures: [FontFeature.enable('smcp')],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.only(left: 14.0, right: 14.0),
                            child: FutureBuilder(
                              future: _fetchData(),
                              builder: (_, snapshot) {
                                if (snapshot.hasData && !snapshot.hasError) {
                                  return Text(
                                    snapshot.data,
                                    style: TextStyle(fontSize: 14.0),
                                  );
                                }
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                          ),
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
    },
  );
}

import 'package:com.floridainc.dosparkles/actions/api/graphql_client.dart';
import 'package:com.floridainc.dosparkles/actions/app_config.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/models/models.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:com.floridainc.dosparkles/widgets/connection_lost.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';
import 'state.dart';
import 'package:http/http.dart' as http;

Widget buildView(
    EmptyScreenPageState state, Dispatch dispatch, ViewService viewService) {
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

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              'Empty Screen',
            ),
          ),
          body: Container(
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
                    backgroundColor:
                        MaterialStateProperty.all(HexColor("#6092DC")),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(31.0),
                      ),
                    ),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    _onSubmit();
                  },
                ),
              ),
            ),
          ),
        ),
        if (_isLostConnection) ConnectionLost(),
      ],
    );
  }
}

void _onSubmit() async {
  AppUser globalUser = GlobalStore.store.getState().user;

  try {
    Response result = await http.post(
      '${AppConfig.instance.baseApiHost}/friend-invites/inviteRequest',
      body: {
        'id': globalUser.id,
        'phone': '+996707889512',
        'name': 'Eddie',
        'referralLink': '${globalUser.referralLink}',
      },
    );

    print(result.body);
  } catch (e) {
    print(e);
  }
}

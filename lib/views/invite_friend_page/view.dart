import 'dart:convert';
import 'dart:ui';

import 'package:com.floridainc.dosparkles/actions/api/graphql_client.dart';
import 'package:com.floridainc.dosparkles/actions/app_config.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/models/models.dart';
import 'package:com.floridainc.dosparkles/widgets/bottom_nav_bar.dart';
import 'package:com.floridainc.dosparkles/widgets/connection_lost.dart';
import 'package:com.floridainc.dosparkles/widgets/sparkles_drawer.dart';
import 'package:com.floridainc.dosparkles/widgets/terms_and_conditions.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flui/flui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/colors.dart';
import 'state.dart';

import 'package:http/http.dart' as http;

Future<PermissionStatus> _getContactPermission() async {
  PermissionStatus permission = await Permission.contacts.status;

  if (permission != PermissionStatus.granted &&
      permission != PermissionStatus.permanentlyDenied) {
    Future<Map<Permission, PermissionStatus>> permissionStatus =
        [Permission.contacts].request();
    var mapStatus = await permissionStatus;
    return mapStatus[Permission.contacts] ?? PermissionStatus.undetermined;
  } else {
    return permission;
  }
}

Future<bool> _askPermissions() async {
  PermissionStatus permissionStatus = await _getContactPermission();
  bool isAccepted = false;

  if (permissionStatus == PermissionStatus.granted)
    isAccepted = true;
  else
    isAccepted = false;

  return isAccepted;
}

Future<void> _congratulationsDialog(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: true,
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
            child: Container(
              height: 274.0,
              padding: EdgeInsets.only(top: 30.0, bottom: 19.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Congratulations'.toUpperCase(),
                    style: TextStyle(
                      color: HexColor("#6092DC"),
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      fontFeatures: [FontFeature.enable('smcp')],
                    ),
                  ),
                  SizedBox(height: 9.0),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    constraints: BoxConstraints(maxWidth: 328.0),
                    margin: EdgeInsets.only(left: 14.0, right: 14.0),
                    child: Column(
                      children: [
                        Text(
                          "All are invited.",
                          style: TextStyle(fontSize: 18.0),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "We will notify you if a friend  sign up.",
                          style: TextStyle(fontSize: 18.0),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 43.0),
                  Container(
                    child: Image.asset(
                      "images/convert_icon.png",
                      fit: BoxFit.contain,
                      width: 80.0,
                      height: 80.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget buildView(
    InviteFriendPageState state, Dispatch dispatch, ViewService viewService) {
  Adapt.initContext(viewService.context);
  return _FirstPage();
}

class _FirstPage extends StatefulWidget {
  @override
  __FirstPageState createState() => __FirstPageState();
}

class __FirstPageState extends State<_FirstPage> {
  AppUser globalUser = GlobalStore.store.getState().user;
  int currentPage = 0;
  bool _isFinalPage = false;
  bool _isLostConnection = false;

  Future fetchData() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    String chatsRaw = prefs.getString('chatsMap') ?? '{}';
    return json.decode(chatsRaw);
  }

  Stream fetchDataProcess() async* {
    while (true) {
      yield await fetchData();
      await Future<void>.delayed(Duration(seconds: 30));
    }
  }

  void _setCurrentPage(int page) {
    setState(() {
      currentPage = page;
    });
  }

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
  void initState() {
    super.initState();

    if (globalUser.invitesSent.length >= 10) {
      _isFinalPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    checkInternetConnectivity();

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 181.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [HexColor('#8FADEB'), HexColor('#7397E2')],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
        ),
        Scaffold(
          body: Container(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
            ),
            width: MediaQuery.of(context).size.width,
            constraints:
                BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            decoration: BoxDecoration(
              color: HexColor("#FAFCFF"),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32.0),
                topRight: Radius.circular(32.0),
              ),
            ),
            child: AnimatedCrossFade(
              duration: const Duration(seconds: 1),
              firstChild: _MainBody(
                currentPage: currentPage,
                setCurrentPage: _setCurrentPage,
              ),
              secondChild: _isFinalPage
                  ? _EndBody()
                  : _NextBody(
                      currentPage: currentPage,
                      setCurrentPage: _setCurrentPage,
                    ),
              crossFadeState: currentPage == 0
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
            ),
          ),
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(
              "Invite Friends",
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontFeatures: [FontFeature.enable('smcp')],
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leadingWidth: 70.0,
            automaticallyImplyLeading: false,
            leading: Builder(
              builder: (context) => IconButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                icon: Image.asset("images/offcanvas_icon.png"),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
          drawer: SparklesDrawer(),
          bottomNavigationBar: StreamBuilder(
            stream: fetchDataProcess(),
            builder: (_, snapshot) {
              return BottomNavBarWidget(
                prefsData: snapshot.data,
                initialIndex: 2,
              );
            },
          ),
        ),
        if (_isLostConnection) ConnectionLost(),
      ],
    );
  }
}

class _MainBody extends StatefulWidget {
  final int currentPage;
  final Function setCurrentPage;

  _MainBody({Key key, this.currentPage, this.setCurrentPage}) : super(key: key);

  @override
  __MainBodyState createState() => __MainBodyState();
}

class __MainBodyState extends State<_MainBody> {
  final AppUser globalUser = GlobalStore.store.getState().user;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 13.0),
          Container(
            width: double.infinity,
            height: 196.0,
            constraints: BoxConstraints(maxWidth: 325.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/Group 297.png"),
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 7.0),
          GestureDetector(
            child: Text(
              "Terms and Conditions",
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 10.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              termsDialog(context);
            },
          ),
          SizedBox(height: 6.0),
          Text(
            "GET A FREE GIFT",
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.red,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6.0),
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  spreadRadius: 3,
                  color: Colors.grey[200],
                  offset: Offset(0.0, 3.0),
                  blurRadius: 3,
                )
              ],
            ),
            child: Center(
                child: Text(
              "1",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                foreground: Paint()
                  ..shader = LinearGradient(
                    colors: [HexColor('#8FADEB'), HexColor('#7397E2')],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
              ),
            )),
          ),
          SizedBox(height: 7.0),
          Text(
            "Send your referral link",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6.0),
          Text(
            "to your friends",
            style: TextStyle(fontSize: 14.0),
          ),
          SizedBox(height: 33.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Image.asset(
                    "images/Group 287.png",
                    fit: BoxFit.contain,
                    width: 60.0,
                    height: 60.0,
                  ),
                  Text("WhatsApp"),
                ],
              ),
              SizedBox(width: 81.0),
              Column(
                children: [
                  Image.asset(
                    "images/Page 1.png",
                    fit: BoxFit.contain,
                    width: 60.0,
                    height: 60.0,
                  ),
                  Text("SMS"),
                ],
              ),
            ],
          ),
          SizedBox(height: 21.0),
          Container(
            constraints: BoxConstraints(maxWidth: 343.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Send your unique referral Link :"),
                SizedBox(height: 8.0),
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 40.0,
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: HexColor("#E8ECFF"),
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      child: Text(
                        globalUser.referralLink,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: HexColor("#6092DC"),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0.0,
                      child: Container(
                        height: 40.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22.0),
                          color: Colors.white,
                        ),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            elevation:
                                MaterialStateProperty.resolveWith<double>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return 0.0;
                                return 5.0;
                              },
                            ),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22.0),
                                side: BorderSide(color: Colors.transparent),
                              ),
                            ),
                            shadowColor:
                                MaterialStateProperty.all(Colors.grey[100]),
                          ),
                          child: RotatedBox(
                            quarterTurns: -1,
                            child: Icon(
                              Icons.logout_outlined,
                              color: HexColor("#53586F"),
                            ),
                          ),
                          onPressed: () async {
                            await Share.share(globalUser.referralLink);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Container(
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
                'Invite Friends',
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => _ContactsPage()),
                );
              },
            ),
          ),
          SizedBox(height: 21.0),
          Container(
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (widget.currentPage == 1)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      child: Text(
                        "PREVIOUS",
                        style: TextStyle(
                          color: HexColor("#6092DC"),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        widget.setCurrentPage(0);
                      },
                    ),
                  ),
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "images/Rectangle 51.png",
                        height: 8.0,
                      ),
                      SizedBox(width: 10.0),
                      Container(
                        width: 8.0,
                        height: 8.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: HexColor("#C4C6D2"),
                        ),
                      )
                    ],
                  ),
                ),
                if (widget.currentPage == 0)
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      child: Text(
                        "NEXT",
                        style: TextStyle(
                          color: HexColor("#6092DC"),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        widget.setCurrentPage(1);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NextBody extends StatefulWidget {
  final int currentPage;
  final Function setCurrentPage;

  _NextBody({
    Key key,
    this.currentPage,
    this.setCurrentPage,
  }) : super(key: key);

  @override
  __NextBodyState createState() => __NextBodyState();
}

class __NextBodyState extends State<_NextBody> {
  AppUser globalUser = GlobalStore.store.getState().user;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 18.0),
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  spreadRadius: 3,
                  color: Colors.grey[200],
                  offset: Offset(0.0, 3.0),
                  blurRadius: 3,
                )
              ],
            ),
            child: Center(
                child: Text(
              "2",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                foreground: Paint()
                  ..shader = LinearGradient(
                    colors: [HexColor('#8FADEB'), HexColor('#7397E2')],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
              ),
            )),
          ),
          SizedBox(height: 12.0),
          Text(
            "When 10 friends download our app",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6.0),
          Text(
            "using your referral link and sync.",
            style: TextStyle(fontSize: 14.0),
          ),
          SizedBox(height: 14.0),
          //
          Image.asset(
            "images/Group22.png",
            fit: BoxFit.contain,
            width: 102.0,
            height: 102.0,
          ),
          SizedBox(height: 11.0),
          Text(
            "${globalUser.invitesSent.length}/10",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              color: HexColor("#6092DC"),
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 6.0,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              separatorBuilder: (context, index) {
                return SizedBox(width: 2.0);
              },
              itemBuilder: (context, index) {
                if (index < globalUser.invitesSent.length)
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.08,
                    height: 6.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(6.0),
                      color: HexColor("#6092DC"),
                    ),
                  );

                return Container(
                  width: MediaQuery.of(context).size.width * 0.09,
                  height: 6.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(6.0),
                    color: HexColor("#EFF4FB"),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 35.0),
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  spreadRadius: 3,
                  color: Colors.grey[200],
                  offset: Offset(0.0, 3.0),
                  blurRadius: 3,
                )
              ],
            ),
            child: Center(
                child: Text(
              "3",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                foreground: Paint()
                  ..shader = LinearGradient(
                    colors: [HexColor('#8FADEB'), HexColor('#7397E2')],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
              ),
            )),
          ),
          SizedBox(height: 12.0),
          Text(
            "Start Inviting Now",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 25.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Image.asset(
                    "images/Group 287.png",
                    fit: BoxFit.contain,
                    width: 60.0,
                    height: 60.0,
                  ),
                  Text("WhatsApp"),
                ],
              ),
              SizedBox(width: 81.0),
              Column(
                children: [
                  Image.asset(
                    "images/Page 1.png",
                    fit: BoxFit.contain,
                    width: 60.0,
                    height: 60.0,
                  ),
                  Text("SMS"),
                ],
              ),
            ],
          ),
          SizedBox(height: 46.0),
          GestureDetector(
            child: Text(
              "Terms and Conditions",
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 10.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              termsDialog(context);
            },
          ),
          SizedBox(height: 16.0),
          Container(
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (widget.currentPage == 1)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      child: Text(
                        "PREVIOUS",
                        style: TextStyle(
                          color: HexColor("#6092DC"),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        widget.setCurrentPage(0);
                      },
                    ),
                  ),
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8.0,
                        height: 8.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: HexColor("#C4C6D2"),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Image.asset(
                        "images/Rectangle 51.png",
                        height: 8.0,
                      ),
                    ],
                  ),
                ),
                if (widget.currentPage == 0)
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      child: Text(
                        "NEXT",
                        style: TextStyle(
                          color: HexColor("#6092DC"),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        widget.setCurrentPage(1);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EndBody extends StatefulWidget {
  @override
  __EndBodyState createState() => __EndBodyState();
}

class __EndBodyState extends State<_EndBody> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 18.0),
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  spreadRadius: 3,
                  color: Colors.grey[200],
                  offset: Offset(0.0, 3.0),
                  blurRadius: 3,
                )
              ],
            ),
            child: Center(
                child: Text(
              "4",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                foreground: Paint()
                  ..shader = LinearGradient(
                    colors: [HexColor('#8FADEB'), HexColor('#7397E2')],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
              ),
            )),
          ),
          SizedBox(height: 12.0),
          Text(
            "You invited 10 friends",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6.0),
          Text(
            "and receive a gift",
            style: TextStyle(fontSize: 14.0),
          ),
          SizedBox(height: 31.0),
          Container(
            width: double.infinity,
            height: 196.0,
            constraints: BoxConstraints(maxWidth: 325.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/Group 297.png"),
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 8.0),
          GestureDetector(
            child: Text(
              "Terms and Conditions",
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 10.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              termsDialog(context);
            },
          ),
          SizedBox(height: 12.0),
          Text(
            "10/10",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              color: HexColor("#6092DC"),
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 10.0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (int i = 0; i < 10; i++)
                  Container(
                    width: MediaQuery.of(context).size.width * 0.08,
                    height: 6.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(6.0),
                      color: HexColor("#6092DC"),
                    ),
                  )
              ],
            ),
          ),
          SizedBox(height: 93.0),
          Container(
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
                'Receive',
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
              onPressed: () {},
            ),
          ),
          SizedBox(height: 21.0),
        ],
      ),
    );
  }
}

class _ContactsPage extends StatefulWidget {
  @override
  __ContactsPageState createState() => __ContactsPageState();
}

class __ContactsPageState extends State<_ContactsPage> {
  List<Map<String, dynamic>> contactsList = [];
  List<Map<String, dynamic>> filteredList;
  List<Map<String, dynamic>> checkedList;
  String searchValue = '';
  bool _isLoading = false;
  bool _isLostConnection = false;

  void _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  @override
  void initState() {
    super.initState();

    _askPermissions().then((value) {
      if (value) {
        ContactsService.getContacts().then((Iterable<Contact> contacts) async {
          String meId = GlobalStore.store.getState().user.id;
          QueryResult result =
              await BaseGraphQLClient.instance.fetchUserById(meId);
          if (result.hasException) print(result.exception);

          List invitesSent = result.data['users'][0]['invitesSent'];

          for (var contact in contacts) {
            if (contact.phones.isEmpty && contact.displayName == null) continue;
            String phoneValue = contact.phones.isNotEmpty
                ? contact.phones
                    .elementAt(0)
                    .value
                    .replaceAll(new RegExp(r"\s+\b|\b\s"), "")
                : '';

            bool invitesPresent = invitesSent != null && invitesSent.length > 0
                ? invitesSent
                    .where((invite) =>
                        invite['phone'] == phoneValue &&
                        invite['confirmed'] == true)
                    .isNotEmpty
                : [];

            contactsList.add({
              "phone": phoneValue,
              "name": contact.displayName != null ? contact.displayName : '',
              "checked": false,
              "invited": invitesPresent,
            });
            setState(() {});
          }
        });
      }
    });
  }

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

    setState(() {
      filteredList = contactsList.where((contact) {
        String name = contact['name'].toLowerCase();
        String value = searchValue.toLowerCase();
        return name.indexOf(value) != -1;
      }).toList();

      checkedList =
          contactsList.where((contact) => contact['checked'] == true).toList();
    });

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 181.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [HexColor('#8FADEB'), HexColor('#7397E2')],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
        ),
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0.0,
            leadingWidth: 70.0,
            automaticallyImplyLeading: false,
            leading: InkWell(
              child: Image.asset("images/back_button_white.png"),
              onTap: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Colors.transparent,
            title: Text(
              "Invite Friends",
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontFeatures: [FontFeature.enable('smcp')],
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  "15 Invites",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () {
                  List foundList = [];

                  for (int i = 0; i < filteredList.length; i++) {
                    var item = filteredList[i];

                    if (foundList.length == 15) break;
                    if (item['checked'] == true) continue;

                    item['checked'] = true;
                    foundList.add(item);
                  }

                  setState(() {});
                },
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          body: Container(
            padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: HexColor("#FAFCFF"),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32.0),
                topRight: Radius.circular(32.0),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22.0),
                            ),
                            shadowColor: Colors.black26,
                            elevation: 4.0,
                            child: Container(
                              height: 40.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22.0),
                              ),
                              child: TextField(
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.visiblePassword,
                                onChanged: (String value) {
                                  setState(() {
                                    searchValue = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Search friends',
                                  hintStyle: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black26,
                                  ),
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Icon(
                                      Icons.search,
                                      size: 26.0,
                                      color: Colors.black26,
                                    ),
                                  ),
                                  filled: true,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(
                                      top: 11.0, bottom: 11.0, right: 11.0),
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          ListView.separated(
                            itemCount: filteredList.length,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            separatorBuilder: (_, index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Divider(
                                color: Colors.white,
                                thickness: 2.0,
                                height: 0.0,
                              ),
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              Map contact = filteredList[index];

                              return GestureDetector(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50.0,
                                  color: HexColor("#FAFCFF"),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      FLAvatar(
                                        image: Image.asset(
                                          'images/user-male-circle.png',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                        width: 50.0,
                                        height: double.infinity,
                                      ),
                                      SizedBox(width: 13.0),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${contact['name']}",
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            contact['invited'] == true
                                                ? Text(
                                                    "You can resend in 3 days.",
                                                    style: TextStyle(
                                                        fontSize: 12.0),
                                                  )
                                                : SizedBox.shrink(child: null),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 13.0),
                                      contact['invited'] == true
                                          ? ElevatedButton(
                                              child: Text(
                                                'Resend',
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .resolveWith<Color>(
                                                  (Set<MaterialState> states) {
                                                    if (states.contains(
                                                      MaterialState.disabled,
                                                    )) return Colors.white;
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              onPressed: null,
                                            )
                                          : Image.asset(
                                              contact['checked']
                                                  ? 'images/Group 231.png'
                                                  : 'images/Group 230.png',
                                              fit: BoxFit.contain,
                                              width: 32.0,
                                              height: 32.0,
                                            ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    contact['checked'] = !contact['checked'];
                                  });
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            height: 75.0,
            color: Colors.white,
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
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled))
                          return HexColor("#C4C6D2");
                        return HexColor("#6092DC");
                      },
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(31.0),
                      ),
                    ),
                  ),
                  child: _isLoading
                      ? Container(
                          width: 25.0,
                          height: 25.0,
                          child: CircularProgressIndicator(),
                        )
                      : Text(
                          checkedList.length == 0
                              ? 'Invite Friends'
                              : 'Invite Friends (${checkedList.length})',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (checkedList.isNotEmpty) {
                            _onSubmit(checkedList, contactsList, _setLoading,
                                context);
                          }
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

void _onSubmit(
  List checkedList,
  List contactsList,
  Function _setLoading,
  BuildContext context,
) async {
  AppUser globalUser = GlobalStore.store.getState().user;

  if (checkedList.length == contactsList.length) {
    _congratulationsDialog(context);
  }

  List<Map<String, dynamic>> friendsList = [];
  for (int i = 0; i < checkedList.length; i++) {
    var contact = checkedList[i];

    if (contact['phone'] != null && contact['phone'] != '') {
      friendsList.add({
        'name': "${contact['name']}",
        'phone': "${contact['phone']}",
      });
    }
  }

  try {
    _setLoading(true);

    await http.post(
      '${AppConfig.instance.baseApiHost}/friend-invites/inviteRequest',
      body: {
        'id': "${globalUser.id}",
        'referralLink': "${globalUser.referralLink}",
        'data': json.encode(friendsList),
      },
    );

    _setLoading(false);
  } catch (e) {
    print(e);
  }
}

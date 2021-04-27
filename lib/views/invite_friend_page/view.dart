import 'dart:ui';

import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/widgets/sparkles_drawer.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flui/flui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../utils/colors.dart';
import 'state.dart';

String termsAndConditions =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mi feugiat enim eu, ultrices vitae consequat proin pulvinar tempor. Felis pharetra, dui, tellus nullam. Nisl, congue pulvinar orci, volutpat adipiscing viverra tincidunt lacinia. Senectus faucibus tristique sociis malesuada. Non vel a ac amet massa. Pellentesque diam tristique fringilla odio aliquet cursus velit et. Augue ac ac eget amet eu. Aliquam, suscipit ornare massa sit dui, mauris, elementum tempor. Ipsum ut iaculis ultrices sit nam condimentum dapibus tincidunt.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mi feugiat enim eu, ultrices vitae consequat proin pulvinar tempor. Felis pharetra, dui, tellus nullam. Nisl, congue pulvinar orci, volutpat adipiscing viverra tincidunt lacinia. Senectus faucibus tristique sociis malesuada. Non vel a ac amet massa. Pellentesque diam tristique fringilla odio aliquet cursus velit et. Augue ac ac eget amet eu. Aliquam, suscipit ornare massa sit dui, mauris, elementum tempor. Ipsum ut iaculis ultrices sit nam condimentum dapibus tincidunt.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mi feugiat enim eu, ultrices vitae consequat proin pulvinar tempor. Felis pharetra, dui, tellus nullam. Nisl, congue pulvinar orci, volutpat adipiscing viverra tincidunt lacinia. Senectus faucibus tristique sociis malesuada. Non vel a ac amet massa. Pellentesque diam tristique fringilla odio aliquet cursus velit et. Augue ac ac eget amet eu. Aliquam, suscipit ornare massa sit dui, mauris, elementum tempor. Ipsum ut iaculis ultrices sit nam condimentum dapibus tincidunt.";

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

int _checkIsInvited(List checkedList) {
  return checkedList.where((item) => item['invited'] == false).toList().length;
}

Future<void> _termsDialog(BuildContext context) async {
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
                        print("PRINT");
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
                            child: Text(
                              termsAndConditions,
                              style: TextStyle(fontSize: 14.0),
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
  int _selectedIndex = 2;
  int currentPage = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    if (index == 0) {
      var globalState = GlobalStore.store.getState();
      var storeFavorite = globalState.user.storeFavorite;

      if (storeFavorite != null)
        Navigator.of(context).pushReplacementNamed('storepage');
      else
        Navigator.of(context).pushReplacementNamed('storeselectionpage');
    } else if (index == 2) {
      Navigator.of(context).pushReplacementNamed('invite_friendpage');
    }
  }

  void _setCurrentPage(int page) {
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              secondChild: _NextBody(
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
            title: InkWell(
              onTap: () {
                _congratulationsDialog(context);
              },
              child: Text(
                "Invite Friends",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontFeatures: [FontFeature.enable('smcp')],
                ),
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
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, -0.2), // (x,y)
                  blurRadius: 10.0,
                ),
              ],
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  label: "",
                  icon: SvgPicture.asset(
                    'images/Vector.svg',
                    color: HexColor("#C4C6D2"),
                  ),
                  activeIcon: SvgPicture.asset(
                    'images/Vector.svg',
                    color: HexColor("#6092DC"),
                  ),
                ),
                BottomNavigationBarItem(
                  label: "",
                  icon: SvgPicture.asset(
                    'images/Group.svg',
                    color: HexColor("#C4C6D2"),
                  ),
                  activeIcon: SvgPicture.asset(
                    'images/Group.svg',
                    color: HexColor("#6092DC"),
                  ),
                ),
                BottomNavigationBarItem(
                  label: "",
                  icon: SvgPicture.asset(
                    'images/Group 41.svg',
                    color: HexColor("#C4C6D2"),
                  ),
                  activeIcon: SvgPicture.asset(
                    'images/Group 41.svg',
                    color: HexColor("#6092DC"),
                  ),
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          ),
        ),
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
              _termsDialog(context);
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
                        "https://2deg.rs/DOVID",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: HexColor("#6092DC"),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
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
                          onPressed: () {},
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

  _NextBody({Key key, this.currentPage, this.setCurrentPage}) : super(key: key);

  @override
  __NextBodyState createState() => __NextBodyState();
}

class __NextBodyState extends State<_NextBody> {
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
            "4/10",
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
                  if (i < 4)
                    Container(
                      width: MediaQuery.of(context).size.width * 0.08,
                      height: 6.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(6.0),
                        color: HexColor("#6092DC"),
                      ),
                    )
                  else
                    Container(
                      width: MediaQuery.of(context).size.width * 0.09,
                      height: 6.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(6.0),
                        color: HexColor("#EFF4FB"),
                      ),
                    )
              ],
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
              _termsDialog(context);
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
              _termsDialog(context);
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

  @override
  void initState() {
    super.initState();

    _askPermissions().then((value) {
      if (value) {
        ContactsService.getContacts().then((Iterable<Contact> contacts) {
          for (var contact in contacts) {
            if (contact.phones.isEmpty && contact.displayName == null) continue;

            contactsList.add({
              "phone": contact.phones.isNotEmpty
                  ? contact.phones.elementAt(0).value
                  : '',
              "name": contact.displayName != null ? contact.displayName : '',
              "checked": false,
              "invited": false,
            });
            setState(() {});
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    backgroundColor:
                        MaterialStateProperty.all(HexColor("#6092DC")),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(31.0),
                      ),
                    ),
                  ),
                  child: Text(
                    _checkIsInvited(checkedList) == 0
                        ? 'Invite Friends'
                        : 'Invite Friends (${_checkIsInvited(checkedList)})',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    if (checkedList.isNotEmpty) {
                      for (var i = 0; i < filteredList.length; i++) {
                        var contact = filteredList[i];

                        if (contact['checked'] == true &&
                            contact['invited'] == false) {
                          setState(() {
                            contact['invited'] = true;
                          });
                        }
                      }
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

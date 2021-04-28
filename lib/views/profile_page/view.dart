import 'dart:ui';

import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:com.floridainc.dosparkles/actions/api/graphql_client.dart';
import 'package:com.floridainc.dosparkles/actions/app_config.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:com.floridainc.dosparkles/views/profile_page/state.dart';
import 'package:com.floridainc.dosparkles/widgets/custom_switch.dart';
import 'package:com.floridainc.dosparkles/widgets/sparkles_drawer.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

Widget buildView(
    ProfilePageState state, Dispatch dispatch, ViewService viewService) {
  Adapt.initContext(viewService.context);
  return _FirstPage();
}

class _FirstPage extends StatefulWidget {
  @override
  __FirstPageState createState() => __FirstPageState();
}

class __FirstPageState extends State<_FirstPage> {
  int _selectedIndex = 0;
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
            child: _MainBody(),
          ),
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(
              "My Profile",
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
                ),
                BottomNavigationBarItem(
                  label: "",
                  icon: SvgPicture.asset(
                    'images/Group 249.svg',
                    // color: HexColor("#C4C6D2"),
                  ),
                ),
                BottomNavigationBarItem(
                  label: "",
                  icon: SvgPicture.asset(
                    'images/Group 41.svg',
                    color: HexColor("#C4C6D2"),
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
  final globalUser = GlobalStore.store.getState().user;

  @override
  __MainBodyState createState() => __MainBodyState();
}

class __MainBodyState extends State<_MainBody> {
  bool _switchValue = false;
  String selectedDate = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 30.0),
          Container(
            width: 82.0,
            height: 82.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: widget.globalUser.avatarUrl != null
                  ? Image.network(
                      widget.globalUser.avatarUrl,
                      width: double.infinity,
                      height: double.infinity,
                    )
                  : Image.asset(
                      "images/image-not-found.png",
                      width: double.infinity,
                      height: double.infinity,
                    ),
            ),
          ),
          SizedBox(height: 12.0),
          Text(
            widget.globalUser.name != null ? widget.globalUser.name : "User",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 30.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("images/bell_icon.svg"),
                SizedBox(width: 11.33),
                Text(
                  "Notifcations",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                Spacer(),
                CustomSwitch(
                  value: _switchValue,
                  onChanged: (bool value) {
                    setState(() {
                      _switchValue = value;
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 32.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("images/location_icon.svg"),
                  SizedBox(width: 11.33),
                  Text(
                    "Change Default Store",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 34.0,
                    height: 34.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 3,
                          color: Colors.grey[100],
                          offset: Offset(0.0, 3.0),
                          blurRadius: 3,
                        )
                      ],
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        "images/chevron_right.svg",
                        width: 10.0,
                        height: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed('storeselectionpage');
              },
            ),
          ),
          SizedBox(height: 32.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("images/lock_icon.svg"),
                  SizedBox(width: 11.33),
                  Text(
                    "Change Password",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 34.0,
                    height: 34.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 3,
                          color: Colors.grey[100],
                          offset: Offset(0.0, 3.0),
                          blurRadius: 3,
                        )
                      ],
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        "images/chevron_right.svg",
                        width: 10.0,
                        height: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed('reset_passwordpage');
              },
            ),
          ),
          SizedBox(height: 24.0),
          Container(
            width: double.infinity,
            height: double.infinity,
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
              maxHeight: MediaQuery.of(context).size.height -
                  Scaffold.of(context).appBarMaxHeight * 2,
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32.0),
                topRight: Radius.circular(32.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, -0.2), // (x,y)
                  blurRadius: 10.0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 23.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Order history".toUpperCase(),
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        color: HexColor("#6092DC"),
                      ),
                    ),
                    Stack(
                      children: [
                        Container(
                          width: 194.0,
                          height: 34.0,
                          padding: EdgeInsets.only(
                            top: 9.0,
                            bottom: 9.0,
                            left: 9.0,
                            right: 44.0,
                          ),
                          decoration: BoxDecoration(
                            color: HexColor("#F0F2FF"),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              selectedDate.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0.0,
                          child: Container(
                            width: 34.0,
                            height: 34.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22.0),
                              color: Colors.white,
                            ),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.all(0.0)),
                                elevation: MaterialStateProperty.all(5.0),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(color: Colors.transparent),
                                  ),
                                ),
                                shadowColor:
                                    MaterialStateProperty.all(Colors.grey[50]),
                              ),
                              child: SvgPicture.asset(
                                "images/Calendar.svg",
                                width: 16.0,
                                height: 16.0,
                              ),
                              onPressed: () {
                                showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1960),
                                  initialDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                ).then((date) {
                                  setState(() {
                                    selectedDate = DateFormat('LLLL yyyy')
                                        .format(
                                            DateTime.parse(date.toString()));
                                  });
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 17.0),
                Flexible(
                  fit: FlexFit.loose,
                  child: ListView.builder(
                    itemCount: 15,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 13.0, horizontal: 10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Text(
                                    "Order ID:",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Positioned(
                                    left: 104.0,
                                    child: Container(
                                      child: Text(
                                        "GY5678WEJ909211",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6.0),
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Text(
                                    "Status:",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Positioned(
                                    left: 104.0,
                                    child: Container(
                                      child: Text(
                                        "In Progress",
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 11.0),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  for (int i = 0; i < 2; i++)
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 11.0),
                                      child: Container(
                                        width: double.infinity,
                                        height: 60.0,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 60.0,
                                              height: double.infinity,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(16.0),
                                                child: Image.asset(
                                                  i == 0
                                                      ? "images/Image 9.png"
                                                      : "images/Image 11.png",
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 8.0),
                                            Expanded(
                                              child: Container(
                                                height: double.infinity,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      "Modal Launch +22% Conversion",
                                                      style: TextStyle(
                                                        fontSize: 14.0,
                                                        color:
                                                            HexColor("#53586F"),
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(height: 7.0),
                                                    RichText(
                                                      text: TextSpan(
                                                        style:
                                                            DefaultTextStyle.of(
                                                          context,
                                                        ).style,
                                                        children: [
                                                          TextSpan(
                                                            text: "\$39.95 ",
                                                            style: TextStyle(
                                                              fontSize: 20.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: HexColor(
                                                                  "#53586F"),
                                                            ),
                                                          ),
                                                          TextSpan(text: "x2")
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 11.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "TOTAL PRICE:",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "\$79.90",
                                    style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
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

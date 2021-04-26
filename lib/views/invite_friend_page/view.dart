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

Widget buildView(
    InviteFriendPageState state, Dispatch dispatch, ViewService viewService) {
  Adapt.initContext(viewService.context);
  return _FirstPage();
}

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

class _FirstPage extends StatefulWidget {
  @override
  __FirstPageState createState() => __FirstPageState();
}

class __FirstPageState extends State<_FirstPage> {
  int _selectedIndex = 2;

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
            padding: EdgeInsets.only(top: 13.0, left: 16.0, right: 16.0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
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
  @override
  __MainBodyState createState() => __MainBodyState();
}

class __MainBodyState extends State<_MainBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 243.0,
          height: 135.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/Mask Group.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
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
      ],
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

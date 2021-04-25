import 'dart:ui';

import 'package:contacts_service/contacts_service.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flui/flui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../utils/colors.dart';
import 'state.dart';

Widget buildView(
    InviteFriendPageState state, Dispatch dispatch, ViewService viewService) {
  Adapt.initContext(viewService.context);
  return _ContactsPage();
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

class _ContactsPage extends StatefulWidget {
  @override
  __ContactsPageState createState() => __ContactsPageState();
}

class __ContactsPageState extends State<_ContactsPage> {
  List<Map<String, dynamic>> contactsList = [];
  List checkedList = [];

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
            });
            setState(() {});
          }
        });
      }
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
                onPressed: () {},
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
                          ListView.builder(
                            itemCount: contactsList.length,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              Map contact = contactsList[index];

                              return ListTile(
                                title: Text(
                                  "${contact['name']}",
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                leading: FLAvatar(
                                  image: Image.asset(
                                    'images/image-not-found.png',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                  width: 50.0,
                                  height: 50.0,
                                ),
                                trailing: IconButton(
                                  icon: Image.asset(
                                    'images/Group 230.png',
                                    fit: BoxFit.contain,
                                    width: 32.0,
                                    height: 32.0,
                                  ),
                                  onPressed: () {
                                    List resultList = checkedList
                                        .where((dynamic item) =>
                                            item == contact['phone'].toString())
                                        .toList();

                                    print("111___$resultList");
                                  },
                                ),
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
                    'Invite Friends',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

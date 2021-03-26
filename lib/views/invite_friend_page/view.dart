import 'package:contacts_service/contacts_service.dart';
import 'package:fish_redux/fish_redux.dart';
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
  return Scaffold(
    appBar: AppBar(
      title: Text("Invite Friends"),
      centerTitle: true,
      actions: [
        TextButton(
          child: Text("Invite all", style: TextStyle(color: Colors.white)),
          onPressed: () => null,
        ),
      ],
      flexibleSpace: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [HexColor('#3D9FB0'), HexColor('#557084')],
            begin: const FractionalOffset(0.5, 0.5),
            end: const FractionalOffset(0.5, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
      ),
    ),
    body: Container(
      color: HexColor('#3D9FB0'),
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(children: [
          SizedBox(height: 30),
          MainPage(),
        ]),
      ),
    ),
  );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Map<String, dynamic>> contactsList = [];

  @override
  void initState() {
    _askPermissions().then((value) {
      if (value) {
        ContactsService.getContacts().then((Iterable<Contact> contacts) {
          for (var contact in contacts) {
            if (contact.phones.isEmpty && contact.emails.isEmpty) continue;

            contactsList.add({
              "phone": contact.phones.isNotEmpty
                  ? contact.phones.elementAt(0).value
                  : '',
              "email": contact.emails.isNotEmpty
                  ? contact.emails.elementAt(0).value
                  : '',
            });
            setState(() {});
          }
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width / 1.2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                hintText: 'Search Friends',
                hintStyle: TextStyle(fontSize: 20),
                prefixIcon: Icon(Icons.search),
                filled: true,
                contentPadding: EdgeInsets.all(14),
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            SizedBox(height: 30),
            ListView.builder(
              itemCount: contactsList.length,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                Map contact = contactsList[index];
                return ListTile(
                  title: Text(
                    "${contact['phone']}",
                    style: TextStyle(fontSize: 16),
                  ),
                  subtitle: Text(
                    "${contact['email']}",
                    style: TextStyle(fontSize: 13),
                  ),
                  leading: Icon(Icons.person),
                  trailing: TextButton(
                    child: Text(
                      "Invite",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => null,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
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
}

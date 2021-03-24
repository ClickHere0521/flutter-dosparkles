import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../actions/api/graphql_client.dart';
import '../../utils/colors.dart';
import '../../utils/general.dart';
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
            onPressed: () => null),
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

class MainPage extends StatelessWidget {
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
              itemCount: 6,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int i) {
                return ListTile(
                  title: Text(
                    "Example text $i",
                    style: TextStyle(fontSize: 22),
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
}

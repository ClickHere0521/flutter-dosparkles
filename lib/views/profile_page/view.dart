import 'package:com.floridainc.dosparkles/globalbasestate/action.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';

import 'state.dart';

Widget buildView(
    ProfilePageState state, Dispatch dispatch, ViewService viewService) {
  Adapt.initContext(viewService.context);

  return Scaffold(
    appBar: AppBar(
      title: Text("Profile"),
      centerTitle: true,
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
      child: MainBody(),
    ),
  );
}

class MainBody extends StatefulWidget {
  @override
  _MainBodyState createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            child: Text("Change default store"),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('storeselectionpage');
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}

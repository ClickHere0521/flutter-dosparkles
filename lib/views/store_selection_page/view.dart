import 'dart:ui';

import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/models/models.dart';
import 'package:com.floridainc.dosparkles/views/store_selection_page/action.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../actions/api/graphql_client.dart';
import '../../utils/colors.dart';
import '../../utils/general.dart';
import 'state.dart';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';

Widget buildView(
  StoreSelectionPageState state,
  Dispatch dispatch,
  ViewService viewService,
) {
  Adapt.initContext(viewService.context);
  return _MainBody(dispatch: dispatch);
}

class _MainBody extends StatefulWidget {
  final Dispatch dispatch;

  _MainBody({Key key, this.dispatch}) : super(key: key);

  @override
  __MainBodyState createState() => __MainBodyState();
}

class __MainBodyState extends State<_MainBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: HexColor("#F2F6FA"),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "images/background_lines_top.png",
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "images/background_lines_bottom.png",
              fit: BoxFit.contain,
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              centerTitle: true,
              elevation: 0.0,
              leadingWidth: 70.0,
              automaticallyImplyLeading: false,
              leading: InkWell(
                child: Image.asset("images/back_button.png"),
                onTap: () => Navigator.of(context).pop(),
              ),
              backgroundColor: Colors.transparent,
              title: Text(
                "Location",
                style: TextStyle(
                  fontSize: 22,
                  color: HexColor("#53586F"),
                  fontWeight: FontWeight.w600,
                  fontFeatures: [FontFeature.enable('smcp')],
                ),
              ),
            ),
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
              ),
              child: _InnerPart(dispatch: widget.dispatch),
            ),
          ),
        ],
      ),
    );
  }
}

class _InnerPart extends StatefulWidget {
  final stores = GlobalStore.store.getState().storesList;
  final Dispatch dispatch;

  _InnerPart({Key key, this.dispatch}) : super(key: key);

  @override
  __InnerPartState createState() => __InnerPartState();
}

class __InnerPartState extends State<_InnerPart> {
  final _formKey = GlobalKey<FormState>();
  String dropDownValue;

  void _onSubmit() async {
    for (var i = 0; i < widget.stores.length; i++) {
      StoreItem store = widget.stores[i];

      if (store.name == dropDownValue) {
        widget.dispatch(
          StoreSelectionPageActionCreator.onStoreSelected(store),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    widget.stores.sort((StoreItem a, StoreItem b) =>
        a.storeDistance.compareTo(b.storeDistance));

    dropDownValue = widget.stores[0].name;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height -
      //     Scaffold.of(context).appBarMaxHeight,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: HexColor("#EDEEF2"),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(22),
                      bottomLeft: Radius.circular(22),
                    ),
                  ),
                  child: TextField(
                    onChanged: (text) {},
                    style: TextStyle(color: Colors.black, fontSize: 14),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Enter message',
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 10,
                      ),
                      fillColor: Colors.white,
                      hintStyle: new TextStyle(color: Colors.grey),
                      labelStyle: new TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width * 0.78,
                ),
                InkWell(
                  child: Container(
                    width: 45,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: HexColor("#6092DC"),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(22),
                        bottomRight: Radius.circular(22),
                      ),
                    ),
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 25.0,
                    ),
                  ),
                  onTap: () {},
                )
              ],
            ),
            SizedBox(height: 17.0),
            Flexible(
              fit: FlexFit.loose,
              child: ListView.separated(
                itemCount: 10,
                separatorBuilder: (context, index) => SizedBox(height: 10.0),
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5.0,
                    shadowColor: Colors.grey[50],
                    child: Container(
                      width: double.infinity,
                      height: 85.0,
                      padding: EdgeInsets.all(6.0),
                      child: Row(
                        children: [
                          Container(
                            width: 73.0,
                            height: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: Image.asset(
                                index.isOdd
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Tifaany&Co.",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 5.0),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 15.0,
                                    child: Stack(
                                      alignment: Alignment.centerLeft,
                                      children: [
                                        SvgPicture.asset(
                                          "images/Group 2131.svg",
                                        ),
                                        Positioned(
                                          top: 0,
                                          left: 15.0,
                                          child: Text(
                                            "72 Street , NY lorem ipsum",
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 16.0,
                                    child: Stack(
                                      alignment: Alignment.centerLeft,
                                      children: [
                                        SvgPicture.asset(
                                          "images/Group (1).svg",
                                        ),
                                        Positioned(
                                          top: 0,
                                          left: 15.0,
                                          child: Text(
                                            "+92390202020",
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              color:
                                                  Colors.black.withOpacity(0.7),
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
    );
  }
}

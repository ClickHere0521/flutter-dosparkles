import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/models/models.dart';
import 'package:com.floridainc.dosparkles/views/store_selection_page/action.dart';
import 'package:com.floridainc.dosparkles/widgets/sparkles_drawer.dart';
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
  return _MainBodyPage(dispatch: dispatch);
}

class _MainBodyPage extends StatefulWidget {
  final Dispatch dispatch;

  const _MainBodyPage({this.dispatch});

  @override
  __MainBodyPageState createState() => __MainBodyPageState();
}

class __MainBodyPageState extends State<_MainBodyPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() => _selectedIndex = index);

    if (index == 0) {
      var globalState = GlobalStore.store.getState();
      var storeFavorite = globalState.user.storeFavorite;

      if (storeFavorite != null)
        Navigator.of(context).pushNamed('storepage', arguments: null);
      else
        Navigator.of(context).pushNamed('storeselectionpage', arguments: null);
    } else if (index == 1) {
      Navigator.of(context).pushNamed('emptyscreenpage', arguments: null);
    } else if (index == 2) {
      Navigator.of(context).pushNamed('invite_friendpage', arguments: null);
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
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: _InnerPart(
                dispatch: widget.dispatch,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.0),
          ),
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(
              "Choose your school",
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
            color: Colors.white,
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  label: "",
                  icon: SvgPicture.asset(
                    'images/Vector (1)121.svg',
                  ),
                  activeIcon: Container(
                    width: 60.0,
                    height: 35.0,
                    decoration: BoxDecoration(
                      color: HexColor("#6092DC").withOpacity(.1),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'images/Vector (1)121.svg',
                      ),
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  label: "",
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SvgPicture.asset(
                        'images/0 notification.svg',
                      ),
                      Positioned.fill(
                        top: -1.8,
                        right: 2.0,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            width: 10.0,
                            height: 10.0,
                            decoration: BoxDecoration(
                              color: HexColor("#6092DC"),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                "1",
                                style: TextStyle(
                                  fontSize: 7.0,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  activeIcon: Container(
                    width: 60.0,
                    height: 35.0,
                    decoration: BoxDecoration(
                      color: HexColor("#6092DC").withOpacity(.1),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'images/0 notification.svg',
                      ),
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  label: "",
                  icon: SvgPicture.asset(
                    'images/Group 25324245.svg',
                  ),
                  activeIcon: Container(
                    width: 60.0,
                    height: 35.0,
                    decoration: BoxDecoration(
                      color: HexColor("#6092DC").withOpacity(.1),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'images/Group 25324245.svg',
                      ),
                    ),
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
                itemCount: widget.stores.length,
                separatorBuilder: (context, index) => SizedBox(height: 10.0),
                itemBuilder: (context, index) {
                  return InkWell(
                    child: Card(
                      elevation: 5.0,
                      shadowColor: Colors.grey[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 85.0,
                        padding: EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 73.0,
                              height: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: CachedNetworkImage(
                                  imageUrl: widget.stores[index].thumbnail,
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
                                      widget.stores[index].name,
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
                                              widget.stores[index].address,
                                              style: TextStyle(
                                                fontSize: 13.0,
                                                color: Colors.black
                                                    .withOpacity(0.7),
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
                                              widget.stores[index].phone,
                                              style: TextStyle(
                                                fontSize: 13.0,
                                                color: Colors.black
                                                    .withOpacity(0.7),
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
                    ),
                    onTap: () {
                      widget.dispatch(
                        StoreSelectionPageActionCreator.onStoreSelected(
                          widget.stores[index],
                        ),
                      );
                    },
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

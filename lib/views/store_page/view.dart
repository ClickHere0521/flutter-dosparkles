import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:com.floridainc.dosparkles/actions/api/graphql_client.dart';
import 'package:com.floridainc.dosparkles/actions/app_config.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/models/date_formatter.dart';
import 'package:com.floridainc.dosparkles/models/models.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:com.floridainc.dosparkles/views/profile_page/state.dart';
import 'package:com.floridainc.dosparkles/views/store_page/action.dart';
import 'package:com.floridainc.dosparkles/views/store_page/state.dart';
import 'package:com.floridainc.dosparkles/widgets/bottom_nav_bar.dart';
import 'package:com.floridainc.dosparkles/widgets/confirm_video.dart';
import 'package:com.floridainc.dosparkles/widgets/custom_switch.dart';
import 'package:com.floridainc.dosparkles/widgets/sparkles_drawer.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:video_player/video_player.dart';

Widget buildView(
    StorePageState state, Dispatch dispatch, ViewService viewService) {
  Adapt.initContext(viewService.context);

  return state.listView
      ? _FirstListPage(
          dispatch: dispatch,
          state: state,
        )
      : _FirstProductPage(
          dispatch: dispatch,
          state: state,
        );
}

class _FirstProductPage extends StatefulWidget {
  final Dispatch dispatch;
  final StorePageState state;

  const _FirstProductPage({this.dispatch, this.state});

  @override
  __FirstProductPageState createState() => __FirstProductPageState();
}

class __FirstProductPageState extends State<_FirstProductPage> {
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

    return Stack(
      children: [
        Scaffold(
          body: _ProductView(
            dispatch: widget.dispatch,
            store: widget.state.selectedStore,
            productIndex: widget.state.productIndex,
          ),
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          extendBody: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            automaticallyImplyLeading: false,
            // actions: [
            //   Padding(
            //     padding: const EdgeInsets.only(right: 16.0),
            //     child: SvgPicture.asset("images/Share.svg"),
            //   ),
            // ],
            leadingWidth: 70.0,
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
          // bottomNavigationBar: StreamBuilder(
          //   stream: fetchDataProcess(),
          //   builder: (_, snapshot) {
          //     return BottomNavBarWidget(
          //       prefsData: snapshot.data,
          //       initialIndex: 0,
          //       isTransparentBackground: true,
          //     );
          //   },
          // ),
        ),
        if (_isLostConnection)
          Positioned.fill(
            child: SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 25.0,
                  color: Colors.black.withOpacity(.8),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_off,
                          color: Colors.white,
                          size: 14.0,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          "No internet connection",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.0,
                            decoration: TextDecoration.none,
                            wordSpacing: -4.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _FirstListPage extends StatefulWidget {
  final Dispatch dispatch;
  final StorePageState state;

  const _FirstListPage({this.dispatch, this.state});

  @override
  __FirstListPageState createState() => __FirstListPageState();
}

class __FirstListPageState extends State<_FirstListPage> {
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
            child: _MainBody(
              dispatch: widget.dispatch,
              store: widget.state.selectedStore,
            ),
            padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
          ),
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(
              widget.state.selectedStore.name,
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
                initialIndex: 0,
              );
            },
          ),
        ),
        if (_isLostConnection)
          Positioned.fill(
            child: SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 25.0,
                  color: Colors.black.withOpacity(.8),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_off,
                          color: Colors.white,
                          size: 14.0,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          "No internet connection",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.0,
                            decoration: TextDecoration.none,
                            wordSpacing: -4.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _MainBody extends StatelessWidget {
  final Dispatch dispatch;
  final StoreItem store;

  const _MainBody({this.dispatch, this.store});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: [
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15.0,
              crossAxisSpacing: 15.0,
              childAspectRatio: 0.7,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                ProductItem product = store.products[index];

                return InkWell(
                  child: Container(
                    // color: HexColor('#dfdada'),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[300],
                          offset: Offset(0.0, 0.0), // (x, y)
                          blurRadius: 10.0,
                        ),
                      ],
                    ),

                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: product.thumbnailUrl != null
                              ? CachedNetworkImage(
                                  imageUrl: product.thumbnailUrl,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  "images/image-not-found.png",
                                  fit: BoxFit.cover,
                                ),
                        ),
                        if (product.isNew)
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                width: double.infinity,
                                height: 20.0,
                                decoration: BoxDecoration(
                                  color: HexColor("#EB5757"),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16.0),
                                    topRight: Radius.circular(16.0),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "NEW",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: double.infinity,
                              height: 40.0,
                              padding: EdgeInsets.only(
                                top: 10.0,
                                bottom: 13.0,
                                left: 10,
                                right: 10.0,
                              ),
                              decoration: BoxDecoration(
                                color: HexColor("#0F142B").withOpacity(.7),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16.0),
                                  bottomRight: Radius.circular(16.0),
                                ),
                              ),
                              child: Text(
                                product.name,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    dispatch(
                      StorePageActionCreator.onProductIndexSelected(index),
                    );
                  },
                );
              },
              childCount: store.products.length,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductView extends StatefulWidget {
  final Dispatch dispatch;
  final AnimationController animationController;
  final StoreItem store;
  final int productIndex;

  _ProductView({
    Key key,
    this.animationController,
    this.dispatch,
    this.store,
    this.productIndex,
  }) : super(key: key);

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<_ProductView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _tabSelectedIndex;

  @override
  void initState() {
    super.initState();
    _tabSelectedIndex = widget.productIndex;
    _tabController =
        TabController(length: widget.store.products.length, vsync: this);
    _tabController
        .addListener(() => {_tabSelectedIndex = _tabController.index});
  }

  @override
  Widget build(BuildContext context) {
    List<ProductItem> items = List.empty(growable: true);
    for (var i = widget.productIndex; i < widget.store.products.length; i++) {
      items.add(widget.store.products[i]);
    }
    for (var i = 0; i < widget.productIndex; i++) {
      items.add(widget.store.products[i]);
    }

    var size = MediaQuery.of(context).size;
    return GestureDetector(
      // Using the DragEndDetails allows us to only fire once per swipe.
      onHorizontalDragEnd: (dragEndDetails) {
        if (dragEndDetails.primaryVelocity < 0) {
          // Page forwards
          widget.dispatch(StorePageActionCreator.onGoToProductPage(
              widget.store.products[_tabSelectedIndex]));
        } else if (dragEndDetails.primaryVelocity > 0) {
          // Page backwards
          widget.dispatch(StorePageActionCreator.onBackToAllProducts());
        }
      },
      child: RotatedBox(
        quarterTurns: 1,
        child: TabBarView(
          controller: _tabController,
          children: List.generate(items.length, (index) {
            return VideoPlayerItem(
                videoUrl: items[index].videoUrl,
                size: size,
                tabSelectedIndex: _tabSelectedIndex,
                dispatch: widget.dispatch,
                store: widget.store
                // name: items[index].name,
                // price: '\$${items[index].price}',
                );
          }),
        ),
      ),
    );
  }
}

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  // final String name;
  // final String price;
  final Size size;

  final int tabSelectedIndex;
  final Dispatch dispatch;
  final StoreItem store;

  VideoPlayerItem({
    Key key,
    @required this.size,
    this.tabSelectedIndex,
    this.dispatch,
    this.store,
    // this.name, this.price,
    this.videoUrl,
  }) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  VideoPlayerController _videoController;
  bool isShowPlaying = false;

  @override
  void initState() {
    super.initState();
    // printWrapped(widget.videoUrl);

    _videoController =
        VideoPlayerController.network(widget.videoUrl, useCache: true)
          ..initialize().then((value) {
            _videoController.setLooping(true);
            _videoController.play();
            setState(() {
              isShowPlaying = false;
            });
          });
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
  }

  // Widget isPlaying() {
  //   return _videoController.value.isPlaying && !isShowPlaying
  //       ? Container()
  //       : Icon(
  //           Icons.play_arrow,
  //           size: 80,
  //           color: Colors.white.withOpacity(0.5),
  //         );
  // }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          setState(() {
            _videoController.value.isPlaying
                ? _videoController.pause()
                : _videoController.play();
          });
        },
        child: RotatedBox(
          quarterTurns: -1,
          child: Container(
              height: widget.size.height,
              width: widget.size.width,
              child: Stack(
                children: [
                  Container(
                    height: widget.size.height,
                    width: widget.size.width,
                    child: Stack(
                      children: [
                        SizedBox.expand(
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: _videoController.value.size?.width ?? 0,
                              height: _videoController.value.size?.height ?? 0,
                              child: VideoPlayer(_videoController),
                            ),
                          ),
                        ),
                        // Center(
                        //   child: Container(
                        //     decoration: BoxDecoration(),
                        //     child: isPlaying(),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                  Container(
                    height: widget.size.height,
                    width: widget.size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        top: 20,
                        right: 16,
                        bottom: 26,
                      ),
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: LeftPanel(
                                  size: widget.size,
                                  tabSelectedIndex: widget.tabSelectedIndex,
                                  dispatch: widget.dispatch,
                                  store: widget.store
                                  // name: "${widget.name}",
                                  // price: "${widget.price}",
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )),
        ));
  }
}

class LeftPanel extends StatelessWidget {
  // final String name;
  // final String price;
  final Size size;
  final int tabSelectedIndex;
  final Dispatch dispatch;
  final StoreItem store;

  final globalUser = GlobalStore.store.getState().user;

  LeftPanel({
    Key key,
    @required this.size,
    this.tabSelectedIndex,
    this.dispatch,
    this.store,
    // this.name,
    // this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: globalUser.avatarUrl != null
                  ? DecorationImage(
                      image: NetworkImage(globalUser.avatarUrl),
                      fit: BoxFit.cover,
                    )
                  : DecorationImage(
                      image: AssetImage("images/user-male-circle.png"),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          SizedBox(height: 30.0),
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     Image.asset("images/Vector 23423432.png"),
          //     SizedBox(height: 6.5),
          //     Text(
          //       "4020",
          //       style: TextStyle(
          //         fontSize: 10.0,
          //         fontWeight: FontWeight.w600,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ],
          // ),
          // SizedBox(height: 25.0),
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     Image.asset("images/Group 2342342.png"),
          //     SizedBox(height: 6.5),
          //     Text(
          //       "234",
          //       style: TextStyle(
          //         fontSize: 10.0,
          //         fontWeight: FontWeight.w600,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ],
          // ),
          //  SizedBox(height: 15.0),
          GestureDetector(
            onTap: () {
              dispatch(StorePageActionCreator.onGoToProductPage(
                  store.products[tabSelectedIndex]));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("images/Vector (1)4234234.png"),
                SizedBox(height: 6.5),
                Text(
                  "BUY",
                  style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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

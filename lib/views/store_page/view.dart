import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/models/models.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:com.floridainc.dosparkles/views/store_page/action.dart';
import 'package:com.floridainc.dosparkles/views/store_page/state.dart';
import 'package:com.floridainc.dosparkles/widgets/bottom_nav_bar.dart';
import 'package:com.floridainc.dosparkles/widgets/connection_lost.dart';
import 'package:com.floridainc.dosparkles/widgets/sparkles_drawer.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:better_player/better_player.dart';

Widget buildView(
    StorePageState state, Dispatch dispatch, ViewService viewService) {
  Adapt.initContext(viewService.context);

  if (state.selectedStore != null &&
      state.selectedStore.products != null &&
      state.selectedStore.products.length > 0) {
    state.selectedStore.products.sort((ProductItem a, ProductItem b) {
      if (a.orderInList == null || b.orderInList == null) {
        return -1;
      }
      if (a.orderInList != null && b.orderInList != null) {
        return a.orderInList.compareTo(b.orderInList);
      }
      return null;
    });
  }

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
        if (_isLostConnection) ConnectionLost(),
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

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
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
                widget.state.selectedStore != null &&
                        widget.state.selectedStore.name != null
                    ? widget.state.selectedStore.name
                    : '',
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
            drawer: SparklesDrawer(activeRoute: "homepage"),
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
          if (_isLostConnection) ConnectionLost(),
        ],
      ),
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
                                product.name != null ? product.name : '',
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
              childCount: store != null && store.products != null
                  ? store.products.length
                  : 0,
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
  GlobalKey<BetterPlayerPlaylistState> _betterPlayerPlaylistStateKey =
      GlobalKey();
  TabController _tabController;
  int _tabSelectedIndex = 0;
  int _currentProductVideo = 0;
  bool _shouldAbsorb = true;
  List<BetterPlayerDataSource> _dataSourceList = [];

  BetterPlayerConfiguration _betterPlayerConfiguration;
  BetterPlayerPlaylistConfiguration _betterPlayerPlaylistConfiguration;

  bool isShowPlaying = false;

  BetterPlayerCacheConfiguration cacheConfiguration =
      BetterPlayerCacheConfiguration(
    useCache: true,
    maxCacheSize: 512 * 1024 * 1024,
    maxCacheFileSize: 512 * 1024 * 1024,
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.store.products.length,
      vsync: this,
    );

    _tabController.addListener(() {
      setState(() {
        _tabSelectedIndex = _tabController.index;
      });
    });

    _betterPlayerConfiguration = BetterPlayerConfiguration(
      showPlaceholderUntilPlay: true,
      autoPlay: true,
      aspectRatio: 9 / 16,
      controlsConfiguration:
          BetterPlayerControlsConfiguration(showControls: false),
    );
    _betterPlayerPlaylistConfiguration = BetterPlayerPlaylistConfiguration(
      loopVideos: true,
      nextVideoDelay: Duration(seconds: 0),
    );
  }

  void resetInformation() {
    _currentProductVideo = 0;
    if (mounted) setState(() {});
  }

  void setMediaList(List<ProductItem> items) {
    _dataSourceList.clear();

    for (int i = 0; i < items[_tabSelectedIndex].videoUrls.length; i++) {
      String asset = items[_tabSelectedIndex].videoUrls[i];

      _dataSourceList.add(
        BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          asset,
          cacheConfiguration: cacheConfiguration,
        ),
      );
    }

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<ProductItem> items = List.empty(growable: true);

    for (int i = widget.productIndex; i < widget.store.products.length; i++) {
      items.add(widget.store.products[i]);
    }
    for (int i = 0; i < widget.productIndex; i++) {
      items.add(widget.store.products[i]);
    }

    setMediaList(items);

    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        GestureDetector(
          // Using the DragEndDetails allows us to only fire once per swipe.
          onVerticalDragEnd: (dragEndDetails) {
            if (dragEndDetails.primaryVelocity < 0) {
              // Page up

              widget.dispatch(StorePageActionCreator.onGoToProductPage(
                  items[_tabSelectedIndex]));
            } else if (dragEndDetails.primaryVelocity > 0) {
              // Page down
              widget.dispatch(StorePageActionCreator.onBackToAllProducts());
            }
          },
          onHorizontalDragEnd: (dragEndDetails) {
            if (dragEndDetails.primaryVelocity < 0) {
              // Page forwards
              resetInformation();

              if (_tabController.index < items.length - 1 &&
                  _tabSelectedIndex < items.length - 1) {
                _tabController.index += 1;
              }
            } else if (dragEndDetails.primaryVelocity > 0) {
              // Page backwards
              resetInformation();

              if (_tabController.index == 0 && _tabController.offset == 0.0) {
                widget.dispatch(StorePageActionCreator.onBackToAllProducts());
                return;
              }

              if (_tabController.index >= 0 && _tabSelectedIndex >= 0) {
                _tabController.index -= 1;
              }
            }
          },
          onTap: () {
            if (_currentProductVideo <
                items[_tabSelectedIndex].videoUrls.length - 1) {
              _currentProductVideo += 1;
            } else {
              _currentProductVideo = 0;
            }

            if (items[_tabSelectedIndex].videoUrls.length > 1) {
              _betterPlayerPlaylistController
                  .setupDataSource(_currentProductVideo);
            }

            // List<int> idsArray = List.empty(growable: true);
            // int currentIndex = _tabSelectedIndex;
            // ProductItem currentProduct = items[currentIndex];

            // for (int i = 0; i < items.length; i++) {
            //   if (items[i].id == currentProduct.id) {
            //     currentIndex = i;
            //   }
            // }

            // List<ProductItem> sameProducts = items
            //     .where((ProductItem product) =>
            //         product.shineonImportId == currentProduct.shineonImportId)
            //     .toList()
            //     .where((el) => el.id != currentProduct.id)
            //     .toList();

            // for (int i = 0; i < items.length; i++) {
            //   for (int j = 0; j < sameProducts.length; j++) {
            //     if (items[i].id == sameProducts[j].id) {
            //       idsArray.add(i);
            //     }
            //   }
            // }

            // List<int> moreThanCurrentIdx =
            //     idsArray.where((el) => el > currentIndex).toList();

            // if (idsArray.isNotEmpty) {
            //   if (moreThanCurrentIdx.isNotEmpty) {
            //     setState(() {
            //       _tabController.index = moreThanCurrentIdx[0];
            //       _tabSelectedIndex = moreThanCurrentIdx[0];
            //     });
            //   } else {
            //     setState(() {
            //       _tabController.index = idsArray[0];
            //       _tabSelectedIndex = idsArray[0];
            //     });
            //   }
            // }
          },

          child: AbsorbPointer(
            absorbing: _shouldAbsorb,
            child: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: List.generate(items.length, (index) {
                return items[index] != null &&
                        items[index].videoUrls != null &&
                        items[index].videoUrls.length > 0
                    ? Center(
                        child: RotatedBox(
                          quarterTurns: 0,
                          child: Container(
                            height: size.height,
                            width: size.width,
                            child: Container(
                              height: size.height,
                              width: size.width,
                              child: Stack(
                                children: [
                                  SizedBox.expand(
                                    child: FittedBox(
                                      fit: BoxFit.cover,
                                      child: SizedBox(
                                        height: size.height,
                                        width: size.width,
                                        child: BetterPlayerPlaylist(
                                          key: _betterPlayerPlaylistStateKey,
                                          betterPlayerConfiguration:
                                              _betterPlayerConfiguration,
                                          betterPlayerPlaylistConfiguration:
                                              _betterPlayerPlaylistConfiguration,
                                          betterPlayerDataSourceList:
                                              _dataSourceList,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container();
              }),
            ),
          ),
        ),
        Container(
          height: size.height,
          width: size.width,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 16,
              bottom: 16,
              right: 16,
              left: 16,
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: RotatedBox(
                      quarterTurns: 0,
                      child: LeftPanel(
                        size: size,
                        tabSelectedIndex: _tabSelectedIndex,
                        dispatch: widget.dispatch,
                        store: widget.store,
                        items: items,
                        // name: "${widget.name}",
                        // price: "${widget.price}",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  BetterPlayerPlaylistController get _betterPlayerPlaylistController =>
      _betterPlayerPlaylistStateKey.currentState.betterPlayerPlaylistController;
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
  BetterPlayerController _betterPlayerController;

  bool isShowPlaying = false;

  @override
  void initState() {
    super.initState();

    BetterPlayerCacheConfiguration cacheConfiguration =
        BetterPlayerCacheConfiguration(
            useCache: true,
            maxCacheSize: 512 * 1024 * 1024,
            maxCacheFileSize: 512 * 1024 * 1024);

    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network, widget.videoUrl,
        cacheConfiguration: cacheConfiguration);

    _betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(
            autoPlay: true, looping: true, aspectRatio: 9 / 16),
        betterPlayerDataSource: betterPlayerDataSource);

    _betterPlayerController.setControlsEnabled(false);
  }

  @override
  void dispose() {
    super.dispose();
    _betterPlayerController.dispose();
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
    // onTap: () {
    // setState(() {
    //   _videoController.value.isPlaying
    //       ? _videoController.pause()
    //       : _videoController.play();
    // });
    //},

    return RotatedBox(
      quarterTurns: 0,
      child: Container(
        height: widget.size.height,
        width: widget.size.width,
        child: Container(
          height: widget.size.height,
          width: widget.size.width,
          child: Stack(
            children: [
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    height: widget.size.height,
                    width: widget.size.width,
                    child: BetterPlayer(
                      controller: _betterPlayerController,
                    ),
                  ),
                ),
              ),

              //                   SizedBox.expand(
              //                     child: FittedBox(
              //                       fit: BoxFit.cover,
              //                        child:  AspectRatio(
              //                        child:   BetterPlayer(
              //   controller: _betterPlayerController,
              // ),
              //   aspectRatio: 16 / 9,

              // ),
              //                       // child: SizedBox(
              //                       //   // width: _videoController.value.size?.width ?? 0,
              //                       //   // height: _videoController.value.size?.height ?? 0,
              //                       //   width: 500, widget.size.width,
              //                       //   height: 300, widget.size.height,
              //                       //   child:

              //                       //   // VideoPlayer(_videoController),
              //                       // ),
              //                     ),
              //                   ),
              // Center(
              //   child: Container(
              //     decoration: BoxDecoration(),
              //     child: isPlaying(),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

class LeftPanel extends StatelessWidget {
  // final String name;
  // final String price;
  final Size size;
  final int tabSelectedIndex;
  final Dispatch dispatch;
  final StoreItem store;
  final List<ProductItem> items;

  final globalUser = GlobalStore.store.getState().user;

  LeftPanel({
    Key key,
    @required this.size,
    this.tabSelectedIndex,
    this.dispatch,
    this.store,
    this.items,
    // this.name,
    // this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
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
            behavior: HitTestBehavior.translucent,
            onTap: () {
              dispatch(StorePageActionCreator.onGoToProductPage(
                  items[tabSelectedIndex]));
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

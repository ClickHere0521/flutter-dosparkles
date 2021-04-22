import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/models/models.dart';
import 'package:com.floridainc.dosparkles/utils/general.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:com.floridainc.dosparkles/style/themestyle.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:com.floridainc.dosparkles/widgets/sparkles_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:video_player/video_player.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    StorePageState state, Dispatch dispatch, ViewService viewService) {
  Adapt.initContext(viewService.context);

  return Scaffold(
    
    body: Stack(
      children: <Widget>[
        _BackGround(controller: state.animationController),
        AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: state.listView
                ? _ListView(
                    animationController: state.animationController,
                    dispatch: dispatch,
                    store: state.selectedStore,
                  )
                : _ProductView(
                    animationController: state.animationController,
                    dispatch: dispatch,
                    store: state.selectedStore,
                    productIndex: state.productIndex,
                  )),
      ],
    ),
    appBar: state.listView
        ? PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: _AppBar(title: state.selectedStore.name),
          )
        : null,
    drawer: state.listView ? SparklesDrawer() : null,
  );
}

class _BackGround extends StatelessWidget {
  final AnimationController controller;
  const _BackGround({this.controller});
  @override
  Widget build(BuildContext context) {
    Adapt.initContext(context);

    return Column(children: [
      Expanded(child: SizedBox()),
    ]);
  }
}

class _AppBar extends StatelessWidget {
  final String title;

  const _AppBar({this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(child: Text(title)),
      flexibleSpace: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [
                HexColor('#3D9FB0'),
                HexColor('#557084'),
              ],
              begin: const FractionalOffset(0.5, 0.5),
              end: const FractionalOffset(0.5, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
      ),
    );
  }
}

class _ListView extends StatelessWidget {
  final Dispatch dispatch;
  final AnimationController animationController;
  final StoreItem store;

  const _ListView({this.animationController, this.dispatch, this.store});
  @override
  Widget build(BuildContext context) {
    final cardCurve = CurvedAnimation(
      parent: animationController,
      curve: Interval(0, 0.4, curve: Curves.ease),
    );
    // printWrapped('store.products: ${store.products}');
    return Center(
      child: SlideTransition(
        position:
            Tween(begin: Offset(0, 1), end: Offset.zero).animate(cardCurve),
        child: Container(
          color: HexColor('#dfdada'),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: Adapt.screenH()),
              child: CustomScrollView(slivers: <Widget>[
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 11.0,
                    crossAxisSpacing: 11.0,
                    childAspectRatio: 0.8,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return InkWell(
                          child: Container(
                            color: HexColor('#dfdada'),
                            child: Stack(children: <Widget>[
                              Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    new Expanded(
                                      child: new CachedNetworkImage(
                                        imageUrl:
                                            store.products[index].thumbnailUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ]),
                              Center(
                                child: Container(
                                  width: 37,
                                  height: 54,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                    image: AssetImage("images/play.png"),
                                    fit: BoxFit.cover,
                                  )),
                                ),
                              ),
                            ]),
                          ),
                          onTap: () => {
                                dispatch(StorePageActionCreator
                                    .onProductIndexSelected(index)),
                              });
                    },
                    childCount: store.products.length,
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductView extends StatefulWidget {
  final Dispatch dispatch;
  final AnimationController animationController;
  final StoreItem store;
  final int productIndex;

  _ProductView(
      {Key key,
      this.animationController,
      this.dispatch,
      this.store,
      this.productIndex})
      : super(key: key);

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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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

  VideoPlayerItem(
      {Key key,
      @required this.size,
      // this.name, this.price,
      this.videoUrl})
      : super(key: key);

  final Size size;

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  VideoPlayerController _videoController;
  bool isShowPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
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
    // TODO: implement dispose
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
                children: <Widget>[
                  Container(
                    height: widget.size.height,
                    width: widget.size.width,
                    decoration: BoxDecoration(color: Colors.black),
                    child: Stack(
                      children: <Widget>[
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
                          left: 15, top: 20, right: 15, bottom: 10),
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                                child: Row(
                              children: <Widget>[
                                LeftPanel(
                                  size: widget.size,
                                  // name: "${widget.name}",
                                  // price: "${widget.price}",
                                ),
                              ],
                            ))
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
  const LeftPanel({
    Key key,
    @required this.size,
    // this.name,
    // this.price,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width - 30,
      height: size.height,
      decoration: BoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
              child: Text(
            'Scroll to see more product videos',
            style: TextStyle(color: Colors.white, fontSize: 14),
          )),
          Center(
              child: Text(
            'Swipe left to go to products',
            style: TextStyle(color: Colors.white, fontSize: 14),
          )),
          Spacer(),
          // Text(
          //   name,
          //   style: TextStyle(
          //       color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          // ),
          // SizedBox(
          //   height: 10,
          // ),
          // Text(
          //   price,
          //   style: TextStyle(color: Colors.white),
          // ),
          SizedBox(
            height: 5,
          ),
          Center(
              child: Text(
            'Swipe left for Shop Now',
            style: TextStyle(color: Colors.white, fontSize: 25),
          )),
        ],
      ),
    );
  }
}

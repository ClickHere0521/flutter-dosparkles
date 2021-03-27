import 'dart:convert';

import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/utils/general.dart';
import 'package:com.floridainc.dosparkles/widgets/test_image_picker.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:com.floridainc.dosparkles/models/models.dart';
import 'package:com.floridainc.dosparkles/widgets/sparkles_drawer.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    StoreSelectionPageState state, Dispatch dispatch, ViewService viewService) {
  Adapt.initContext(viewService.context);
  return Scaffold(
    body: Stack(
      children: <Widget>[
        _BackGround(controller: state.animationController),
        _MainBody(
            animationController: state.animationController,
            dispatch: dispatch,
            stores: state.storesList),
      ],
    ),
    appBar: PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: _AppBar(),
    ),
    drawer: SparklesDrawer(),
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
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(AppLocalizations.of(context).storeSelectionPageTitle),
        ],
      ),
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
            tileMode: TileMode.clamp,
          ),
        ),
      ),
    );
  }
}

class _MainBody extends StatefulWidget {
  final Dispatch dispatch;
  final AnimationController animationController;
  final List<StoreItem> stores;

  const _MainBody({
    this.animationController,
    this.dispatch,
    this.stores,
  });

  @override
  __MainBodyState createState() => __MainBodyState();
}

class __MainBodyState extends State<_MainBody> {
  List<StoreItem> stores;

  @override
  void initState() {
    setState(() => stores = GlobalStore.store.getState().storesList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cardCurve = CurvedAnimation(
      parent: widget.animationController,
      curve: Interval(0, 0.4, curve: Curves.ease),
    );
    const Key centerKey = ValueKey('bottom-sliver-list');

    if (stores != null) {
      stores.sort((StoreItem a, StoreItem b) =>
          a.storeDistance.compareTo(b.storeDistance));
    }

    return Center(
      child: SlideTransition(
        position:
            Tween(begin: Offset(0, 1), end: Offset.zero).animate(cardCurve),
        child: Container(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: Adapt.screenH()),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: CustomScrollView(
                      center: centerKey,
                      scrollDirection: Axis.vertical,
                      slivers: <Widget>[
                        SliverList(
                          key: centerKey,
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.0, vertical: 2.0),
                                child: InkWell(
                                  child: Container(
                                    alignment: Alignment.center,
                                    color: Colors.grey,
                                    height: 100,
                                    child: Text(
                                        'Store: ${stores[index] != null && stores[index].name != null ? stores[index].name : ''}'),
                                  ),
                                  onTap: () => {
                                    widget.dispatch(
                                      StoreSelectionPageActionCreator
                                          .onStoreSelected(stores[index]),
                                    ),
                                  },
                                ),
                              );
                            },
                            childCount: stores != null ? stores.length : 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

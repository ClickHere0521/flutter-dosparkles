import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:com.floridainc.dosparkles/style/themestyle.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:com.floridainc.dosparkles/widgets/sparkles_drawer.dart';

import 'package:com.floridainc.dosparkles/models/models.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:com.floridainc.dosparkles/widgets/touch_spin.dart';
import 'package:intl/intl.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    CartPageState state, Dispatch dispatch, ViewService viewService) {
  Adapt.initContext(viewService.context);
  return Scaffold(
    body: Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: Adapt.screenH(),
      color: HexColor('#50DDE1'),
      child: SingleChildScrollView(
        child: _MainBody(
          animationController: state.animationController,
          dispatch: dispatch,
          shoppingCart: state.shoppingCart,
        ),
      ),
    ),
    appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: _AppBar(dispatch: dispatch, shoppingCart: state.shoppingCart)),
    drawer: SparklesDrawer(),
  );
}

class _AppBar extends StatelessWidget {
  final List<CartItem> shoppingCart;
  final Dispatch dispatch;

  const _AppBar({this.shoppingCart, this.dispatch});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(child: Text(AppLocalizations.of(context).cartPageTitle)),
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
      actions: <Widget>[
        new Padding(
          padding: const EdgeInsets.all(10.0),
          child: new Container(
              height: 150.0,
              width: 30.0,
              child: new GestureDetector(
                onTap: () {
                  // if (shoppingCart.length > 0) {
                  //   dispatch(ProductPageActionCreator.onGoToCart());
                  // }
                },
                child: new Stack(
                  children: <Widget>[
                    new IconButton(
                      icon: new Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                      onPressed: () => null,
                    ),
                    shoppingCart.length == 0
                        ? new Container()
                        : new Positioned(
                            left: 5,
                            child: new Stack(
                              children: <Widget>[
                                new Icon(Icons.brightness_1,
                                    size: 20.0, color: HexColor('#FF0000')),
                                new Positioned(
                                    top: 3.0,
                                    right: 6.0,
                                    child: new Center(
                                      child: new Text(
                                        shoppingCart.length.toString(),
                                        style: new TextStyle(
                                            color: Colors.white,
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                              ],
                            )),
                  ],
                ),
              )),
        ),
      ],
    );
  }
}

class _MainBody extends StatelessWidget {
  final Dispatch dispatch;
  final AnimationController animationController;
  final List<CartItem> shoppingCart;

  const _MainBody({this.animationController, this.dispatch, this.shoppingCart});
  @override
  Widget build(BuildContext context) {
    final cardCurve = CurvedAnimation(
      parent: animationController,
      curve: Interval(
        0,
        0.4,
        curve: Curves.ease,
      ),
    );

    const Key centerKey = ValueKey('bottom-sliver-list');

    double totalAmount = 0;
    for (var i = 0; i < shoppingCart.length; i++) {
      totalAmount += shoppingCart[i].amount;
    }

    print('cart inside widget: ${shoppingCart.toString()}');

    return Center(
      child: SlideTransition(
        position:
            Tween(begin: Offset(0, 1), end: Offset.zero).animate(cardCurve),
        child: GestureDetector(
          // Using the DragEndDetails allows us to only fire once per swipe.
          onVerticalDragEnd: (dragEndDetails) {
            if (dragEndDetails.primaryVelocity < 0) {
              // Page up
            } else if (dragEndDetails.primaryVelocity > 0) {
              // Page down
              dispatch(CartPageActionCreator.onBackToProduct());
            }
          },
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 5),
                  child: Text(
                    'Item in your cart  is in high demand. Proceed to quickly to reserve',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.normal),
                  ),
                ),

                Container(
                  margin: EdgeInsets.symmetric(vertical: 5.0),
                  height: 200.0 * shoppingCart.length,
                  child: ListView.builder(
                    shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(5),
                    itemCount: shoppingCart.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(width: 1.0, color: Colors.white),
                            bottom: BorderSide(width: 1.0, color: Colors.white),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  shoppingCart[index].product != null &&
                                          shoppingCart[index]
                                                  .product
                                                  .thumbnailUrl !=
                                              null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: new CachedNetworkImage(
                                            imageUrl: shoppingCart[index]
                                                .product
                                                .thumbnailUrl,
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Container(),
                                  Expanded(
                                    child: new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          shoppingCart[index].product.name,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        Text(
                                          '\$${shoppingCart[index].amount}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(children: [
                                Spacer(),
                                TouchSpin(
                                    value: shoppingCart[index].count,
                                    onChanged: (val) {
                                      print('TouchSpin val: $val');

                                      dispatch(CartPageActionCreator
                                          .onSetProductCount(
                                              shoppingCart[index],
                                              val.toInt()));
                                    },
                                    min: 1,
                                    max: 100,
                                    step: 1,
                                    iconSize: 20.0,
                                    subtractIcon: Icon(Icons.remove),
                                    addIcon: Icon(Icons.add),
                                    iconPadding: EdgeInsets.all(0),
                                    textStyle: TextStyle(fontSize: 18),
                                    iconActiveColor: Colors.white,
                                    iconDisabledColor: Colors.grey,
                                    displayFormat: new NumberFormat("###")),
                                Spacer(),
                                InkWell(
                                  child: Container(
                                    width: 48,
                                    height: 46,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image:
                                              AssetImage("images/delete.png"),
                                          fit: BoxFit.contain),
                                    ),
                                  ),
                                  onTap: () {
                                    dispatch(
                                        CartPageActionCreator.onRemoveCartItem(
                                            shoppingCart[index]));
                                  },
                                ),
                              ])
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // SizedBox(
                //   height: 10,
                // ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 20),
                  child: Column(
                    children: [
                      Text(
                        'Summary',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Spacer(),
                          Text(
                            'Total:',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '   \$$totalAmount USD',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Shipping calculated at checkout',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Spacer(),
                          Column(
                            children: [
                              Container(
                                width: 45 * 1.2,
                                height: 25 * 1.2,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage("images/money.png"),
                                      fit: BoxFit.contain),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 60,
                                child: Text(
                                  '60-Days Satisfaction\nGuarantee With\nMoney Back',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            children: [
                              Container(
                                width: 25 * 1.2,
                                height: 25 * 1.2,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage("images/check.png"),
                                      fit: BoxFit.contain),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 60,
                                child: Text(
                                  '100% Secure\nCheckout',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            side: BorderSide(color: Colors.white)),
                        color: Colors.transparent,
                        textColor: Colors.white,
                        padding: EdgeInsets.only(
                            top: 12.0, bottom: 12.0, left: 30, right: 30),
                        onPressed: () async {
                          dispatch(CartPageActionCreator.onProceedToCheckout());
                        },
                        child: Row(
                          children: [
                            Spacer(),
                            Container(
                              width: 22 * 1.2,
                              height: 25 * 1.2,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("images/lock.png"),
                                    fit: BoxFit.contain),
                              ),
                            ),
                            Spacer(),
                            Text(
                              'Proceed To Checkout',
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Container(
                              width: 19 * 1.2,
                              height: 7 * 1.2,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("images/arrow-right.png"),
                                    fit: BoxFit.contain),
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Spacer(),
                          Container(
                            width: 53 * 1.4,
                            height: 22 * 1.4,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("images/applepay.png"),
                                  fit: BoxFit.contain),
                            ),
                          ),
                          Spacer(),
                          Container(
                            width: 53 * 1.4,
                            height: 22 * 1.4,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("images/paypal.png"),
                                  fit: BoxFit.contain),
                            ),
                          ),
                          Spacer(),
                          Container(
                            width: 53 * 1.4,
                            height: 22 * 1.4,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("images/gpay.png"),
                                  fit: BoxFit.contain),
                            ),
                          ),
                          Spacer()
                        ],
                      ),
                    ],
                  ),
                ),
                // Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

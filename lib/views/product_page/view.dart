import 'dart:convert';
import 'dart:ffi';

import 'package:com.floridainc.dosparkles/actions/api/graphql_client.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:com.floridainc.dosparkles/style/themestyle.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:com.floridainc.dosparkles/widgets/sparkles_drawer.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:com.floridainc.dosparkles/models/models.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:com.floridainc.dosparkles/widgets/touch_spin.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    ProductPageState state, Dispatch dispatch, ViewService viewService) {
  Adapt.initContext(viewService.context);
  // print('state.optionalMaterialSelected: $r{state.optionalMaterialSelected}');

  return Scaffold(
    body: Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: Adapt.screenH(),
      color: HexColor('#50DDE1'),
      child: MainBody(
        animationController: state.animationController,
        dispatch: dispatch,
        selectedProduct: state.selectedProduct,
        optionalMaterialSelected: state.optionalMaterialSelected,
        engraveInputs: state.engraveInputs,
        productQuantity: state.productQuantity,
      ),
    ),
    appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: _AppBar(
          shoppingCart: state.shoppingCart,
          dispatch: dispatch,
        )),
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
      title: Center(
          child: Text("Product"
              // AppLocalizations.of(context).productPageTitle
              )),
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
                if (shoppingCart.length > 0) {
                  dispatch(ProductPageActionCreator.onGoToCart());
                }
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
            ),
          ),
        ),
      ],
    );
  }
}

class MainBody extends StatefulWidget {
  final Dispatch dispatch;
  final AnimationController animationController;
  final ProductItem selectedProduct;
  final bool optionalMaterialSelected;
  final List<String> engraveInputs;
  final int productQuantity;

  MainBody(
      {this.animationController,
      this.dispatch,
      this.selectedProduct,
      this.optionalMaterialSelected,
      this.engraveInputs,
      this.productQuantity});

  @override
  _MainBodyState createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  @override
  Widget build(BuildContext context) {
    final cardCurve = CurvedAnimation(
      parent: widget.animationController,
      curve: Interval(0, 0.4, curve: Curves.ease),
    );

    // print('_MainBody optionalMaterialSelected: $optionalMaterialSelected');
    // print(
    //     'selectedProduct.price: ${selectedProduct.price} productQuantity: ${productQuantity}');
    // print('popup: $optionalMaterialSelected');

    int _productQuantity =
        widget.productQuantity == null ? 1 : widget.productQuantity;

    return Center(
      child: SlideTransition(
        position:
            Tween(begin: Offset(0, 1), end: Offset.zero).animate(cardCurve),
        child: GestureDetector(
          // Using the DragEndDetails allows us to only fire once per swipe.
          // onVerticalDragEnd: (dragEndDetails) {
          //   if (dragEndDetails.primaryVelocity < 0) {
          //     // Page up
          //   } else if (dragEndDetails.primaryVelocity > 0) {
          //     // Page down
          //     widget.dispatch(ProductPageActionCreator.onBackToProduct());
          //   }
          // },
          child: RefreshIndicator(
            onRefresh: () {
              return widget.dispatch(
                ProductPageActionCreator.onBackToProduct(),
              );
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    new Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        return new Image.network(
                          widget.selectedProduct.mediaUrls[index],
                          fit: BoxFit.fill,
                        );
                      },
                      itemCount: widget.selectedProduct.mediaUrls.length,
                      itemWidth: Adapt.screenW() * 0.6,
                      itemHeight: Adapt.screenW() * 0.6,
                      layout: SwiperLayout.STACK,
                      pagination: new SwiperPagination(
                        margin: new EdgeInsets.only(
                            top: Adapt.screenW() * 0.6 + 20),
                        builder: new DotSwiperPaginationBuilder(
                          color: Colors.grey,
                          activeColor: HexColor('#3D9FB0'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                        child: Text(
                      widget.selectedProduct.name,
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '\$${widget.selectedProduct.price}',
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                        widget.selectedProduct.showOldPrice
                            ? Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Text(
                                  '\$${widget.selectedProduct.oldPrice}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontStyle: FontStyle.italic,
                                      decoration: TextDecoration.lineThrough,
                                      shadows: <Shadow>[
                                        Shadow(
                                            offset: Offset(1, 1),
                                            blurRadius: 0,
                                            color: Colors.black),
                                        Shadow(
                                            offset: Offset(-1, -1),
                                            blurRadius: 0,
                                            color: Colors.black),
                                        Shadow(
                                            offset: Offset(1, -1),
                                            blurRadius: 0,
                                            color: Colors.black),
                                        Shadow(
                                            offset: Offset(-1, 1),
                                            blurRadius: 0,
                                            color: Colors.black),
                                      ]),
                                ),
                              )
                            : Container()
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Center(
                        child: Text(
                      'Quantity',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    TouchSpin(
                      value: _productQuantity,
                      onChanged: (val) {
                        print('TouchSpin val: $val');
                        // productQuantity = val.toInt();
                        widget.dispatch(
                            ProductPageActionCreator.onSetProductCount(
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
                      displayFormat: new NumberFormat("###"),
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
                          top: 12.0, bottom: 12.0, left: 50, right: 50),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return _ProductCustomization(
                                    dispatch: widget.dispatch,
                                    selectedProduct: widget.selectedProduct,
                                    productQuantity: widget.productQuantity,
                                    engraveInputs: widget.engraveInputs,
                                    optionalMaterialSelected:
                                        widget.optionalMaterialSelected,
                                  );
                                },
                              );
                            });
                      },
                      child: Text(
                        '\$${widget.selectedProduct.price * widget.productQuantity} - Add to Cart'
                            .toUpperCase(),
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
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
                              width: 48,
                              height: 46,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("images/usamade.png"),
                                    fit: BoxFit.contain),
                              ),
                            ),
                            Container(
                              height: 60,
                              child: Text(
                                'U.S.A made',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Column(
                          children: [
                            Container(
                              width: 48,
                              height: 46,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage("images/shippingfast.png"),
                                    fit: BoxFit.contain),
                              ),
                            ),
                            Container(
                              height: 60,
                              child: Text(
                                'Shipping Fast',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Column(
                          children: [
                            Container(
                              width: 48,
                              height: 46,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("images/guranteed.png"),
                                    fit: BoxFit.contain),
                              ),
                            ),
                            Container(
                              height: 60,
                              child: Text(
                                'Quality\nGuranteed',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            )
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                    Center(
                        child: Text(
                      'Swipe down to go to the product page',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      textAlign: TextAlign.center,
                    )),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductCustomization extends StatefulWidget {
  final Dispatch dispatch;
  final ProductItem selectedProduct;
  final int productQuantity;
  final bool optionalMaterialSelected;
  final List<String> engraveInputs;

  _ProductCustomization(
      {this.dispatch,
      this.selectedProduct,
      this.productQuantity,
      this.engraveInputs,
      this.optionalMaterialSelected});

  @override
  _ProductCustomizationState createState() => new _ProductCustomizationState(
        dispatch: dispatch,
        selectedProduct: selectedProduct,
        productQuantity: productQuantity,
        engraveInputs: engraveInputs,
        optionalMaterialSelected: optionalMaterialSelected,
      );
}

class _ProductCustomizationState extends State<_ProductCustomization> {
  Dispatch dispatch;
  ProductItem selectedProduct;
  int productQuantity;
  bool optionalMaterialSelected;
  List<String> engraveInputs;
  List<Asset> pickedImages = <Asset>[];
  List orderImageData = [];

  List<TextEditingController> engravingControllers;

  void setOrderImageData(images) {
    setState(() {
      orderImageData = images;
    });
  }

  _ProductCustomizationState({
    this.dispatch,
    this.selectedProduct,
    this.productQuantity,
    this.engraveInputs,
    this.optionalMaterialSelected,
  });

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: selectedProduct.properties['buyer_uploads'],
        enableCamera: true,
        selectedAssets: pickedImages,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Gallery",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      print(e);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    if (resultList.length == selectedProduct.properties['buyer_uploads'])
      _sendRequest(resultList, setOrderImageData);

    setState(() {
      pickedImages = resultList;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(
        '_ProductCustomization optionalMaterialSelected: $optionalMaterialSelected');

    int engravingsCount = 0;

    if (selectedProduct != null &&
        selectedProduct.properties != null &&
        selectedProduct.properties['engravings'] != null) {
      var engravings = selectedProduct.properties['engravings'];
      if (engravings is int) {
        engravingsCount = engravings;
      } else {
        engravingsCount = int.tryParse(engravings) ?? 0;
      }
    }

    if (engravingsCount > 0) {
      engravingControllers = List.empty(growable: true);
      for (var i = 0; i < engravingsCount; i++) {
        var controller = TextEditingController();
        if (engraveInputs != null && engraveInputs.length > i) {
          controller..text = engraveInputs[i];
        }
        engravingControllers.add(controller);
      }
    }

    print('engravingsCount: $engravingsCount');

    return Dialog(
      clipBehavior: Clip.none,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      selectedProduct.name,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      'Made in USA',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  //
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        (selectedProduct.showOldPrice
                            ? Padding(
                                padding: const EdgeInsets.only(left: 0.0),
                                child: Text(
                                  '\$${selectedProduct.oldPrice}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontStyle: FontStyle.italic,
                                      decoration: TextDecoration.lineThrough,
                                      shadows: <Shadow>[
                                        Shadow(
                                            offset: Offset(1, 1),
                                            blurRadius: 0,
                                            color: Colors.red),
                                        Shadow(
                                            offset: Offset(-1, -1),
                                            blurRadius: 0,
                                            color: Colors.red),
                                        Shadow(
                                            offset: Offset(1, -1),
                                            blurRadius: 0,
                                            color: Colors.red),
                                        Shadow(
                                            offset: Offset(-1, 1),
                                            blurRadius: 0,
                                            color: Colors.red),
                                      ]),
                                ),
                              )
                            : Container()),
                        //
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            '\$${selectedProduct.price}',
                            style: TextStyle(color: Colors.black, fontSize: 35),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //
                  selectedProduct.engraveAvailable ||
                          selectedProduct.optionalFinishMaterialEnabled
                      ? RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: 'Add a ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal),
                              children: <TextSpan>[
                                selectedProduct.engraveAvailable
                                    ? TextSpan(
                                        text: 'personal message'.toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : TextSpan(),
                                selectedProduct.engraveAvailable &&
                                        selectedProduct
                                            .optionalFinishMaterialEnabled
                                    ? TextSpan(
                                        text: ' and ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal))
                                    : TextSpan(),
                                selectedProduct.optionalFinishMaterialEnabled
                                    ? TextSpan(
                                        text: 'gold finish'.toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : TextSpan(),
                              ]),
                        )
                      : Container(),
                  //
                  selectedProduct.engraveAvailable && engravingsCount > 0
                      ? Column(
                          children: [
                            SizedBox(
                              height: 30,
                            ),

                            Text(
                              '1. Engrave  Personal Message',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal),
                            ),
                            SizedBox(
                              height: 10,
                            ),

                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text: '50% Off - One-time Offer ! ',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '\n( ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    TextSpan(
                                        text: selectedProduct
                                                .showOldEngravePrice
                                            ? '\$${selectedProduct.engraveOldPrice} '
                                            : '',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                            decoration:
                                                TextDecoration.lineThrough)),
                                    TextSpan(
                                      text: ' \$${selectedProduct.price} ',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ')',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ]),
                            ),
                            //
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                selectedProduct.engraveExampleUrl != null
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: new CachedNetworkImage(
                                          imageUrl:
                                              selectedProduct.engraveExampleUrl,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Container(),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 8.0),
                                  width: Adapt.screenW() - 200,
                                  height: 60.0 * engravingsCount,
                                  child: ListView.builder(
                                    itemCount: engravingsCount,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.all(5),
                                        child: TextField(
                                          maxLength: 16,
                                          controller:
                                              engravingControllers[index],
                                          onChanged: (content) {
                                            var engravingListActual =
                                                List<String>.empty(
                                                    growable: true);
                                            for (var i = 0;
                                                i < engravingControllers.length;
                                                i++) {
                                              engravingListActual.add(
                                                  engravingControllers[i].text);
                                            }
                                            dispatch(ProductPageActionCreator
                                                .onSetEngravingInputs(
                                                    engravingListActual));
                                          },
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            counterText: '',
                                            hintText: 'Your Words Here',
                                            hintStyle: TextStyle(fontSize: 16),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                  width: 1.0,
                                                  color: Colors.black),
                                            ),
                                            filled: true,
                                            contentPadding: EdgeInsets.all(16),
                                            fillColor: Colors.white,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Container(),

                  //
                  selectedProduct.optionalFinishMaterialEnabled
                      ? Column(
                          children: [
                            SizedBox(
                              height: 30,
                            ),

                            Text(
                              '2. ${selectedProduct.optionalFinishMaterial}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal),
                            ),
                            SizedBox(
                              height: 10,
                            ),

                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text: '50% Off - One-time Offer ! ',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '\n( ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    TextSpan(
                                        text: selectedProduct
                                                .showOldEngravePrice
                                            ? '\$${selectedProduct.optionalFinishMaterialPrice} '
                                            : '',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                        )),
                                    TextSpan(
                                      text: ')',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ]),
                            ),
                            //
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                selectedProduct.engraveExampleUrl != null
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: new CachedNetworkImage(
                                          imageUrl: selectedProduct
                                              .optionalMaterialExampleUrl,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Container(),
                                InkWell(
                                  onTap: () {
                                    print(
                                        'optionalMaterialSelected: $optionalMaterialSelected !optionalMaterialSelected: ${!optionalMaterialSelected}');
                                    dispatch(ProductPageActionCreator
                                        .onSetOptionMaterialSelected(
                                            !optionalMaterialSelected));

                                    var engravingListActual =
                                        List<String>.empty(growable: true);
                                    for (var i = 0;
                                        i < engravingControllers.length;
                                        i++) {
                                      engravingListActual
                                          .add(engravingControllers[i].text);
                                    }
                                    setState(() {
                                      optionalMaterialSelected =
                                          !optionalMaterialSelected;
                                      engraveInputs = engravingListActual;
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Text(
                                        'Add ${selectedProduct.optionalFinishMaterial}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  optionalMaterialSelected ==
                                                          true
                                                      ? "images/checkblue.png"
                                                      : "images/checkgrey.png"),
                                              fit: BoxFit.contain),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Container(),
                  SizedBox(height: 20),
                  widget.selectedProduct.uploadsAvailable == false
                      ? SizedBox.shrink(child: null)
                      : Container(
                          height: 160.0,
                          child: buildGridView(
                            pickedImages,
                            widget.selectedProduct.properties['buyer_uploads'],
                          ),
                        ),
                  SizedBox(height: 20),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: BorderSide(color: Colors.grey)),
                    color: Colors.transparent,
                    textColor: Colors.red,
                    padding: EdgeInsets.only(
                      top: 12.0,
                      bottom: 12.0,
                      left: 50,
                      right: 50,
                    ),
                    onPressed: orderImageData.length <
                                widget.selectedProduct
                                    .properties['buyer_uploads'] &&
                            widget.selectedProduct.uploadsAvailable == true
                        ? null
                        : () async {
                            await dispatch(
                              ProductPageActionCreator.onAddToCart(
                                selectedProduct,
                                productQuantity,
                                orderImageData,
                              ),
                            );
                            dispatch(ProductPageActionCreator.onGoToCart());
                          },
                    child: Text(
                      'Customize and Proceed',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  //
                ],
              ),
            ),
          ),
          Positioned(
            right: -20.0,
            top: -20.0,
            width: 50,
            height: 50,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: RawMaterialButton(
                elevation: 2.0,
                fillColor: Colors.white,
                child: Icon(
                  Icons.close,
                  size: 26.0,
                ),
                padding: EdgeInsets.all(0.0),
                shape: CircleBorder(),
                onPressed: () => null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGridView(List<Asset> images, int buyUploads) {
    int diff = buyUploads - images.length;

    return GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        childAspectRatio: 1,
        children: <Widget>[
          for (var asset in images)
            Card(
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: <Widget>[
                  AssetThumb(asset: asset, width: 300, height: 300),
                ],
              ),
            ),
          for (int i = 0; i < diff; i++)
            Card(
              color: Colors.grey[300],
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () => loadAssets(),
              ),
            ),
        ]);
  }
}

void _sendRequest(imagesList, Function setOrderImageData) async {
  Uri uri = Uri.parse('https://backend.dosparkles.com/upload');

  MultipartRequest request = http.MultipartRequest("POST", uri);

  for (var i = 0; i < imagesList.length; i++) {
    var asset = imagesList[i];

    ByteData byteData = await asset.getByteData();
    List<int> imageData = byteData.buffer.asUint8List();

    MultipartFile multipartFile = MultipartFile.fromBytes(
      'files',
      imageData,
      filename: '${asset.name}',
      contentType: MediaType("image", "jpg"),
    );
    request.files.add(multipartFile);
  }

  http.Response response = await http.Response.fromStream(await request.send());
  List imagesResponse = json.decode(response.body);
  // var listOfIds = imagesResponse.map((image) => "\"${image['id']}\"");

  List<Map<String, String>> orderImageData = imagesResponse
      .map((image) => {'url': "${image['url']}", 'id': "${image['id']}"})
      .toList();

  setOrderImageData(orderImageData);
}

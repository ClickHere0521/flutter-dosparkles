import 'dart:ui';

import 'package:com.floridainc.dosparkles/widgets/swiper_widget.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:http/http.dart' as http;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';

import 'package:com.floridainc.dosparkles/models/models.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:com.floridainc.dosparkles/views/product_page/action.dart';

import 'package:com.floridainc.dosparkles/widgets/sparkles_drawer.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ProductDetailsImage extends StatefulWidget {
  final Dispatch dispatch;
  final ProductItem selectedProduct;
  final bool optionalMaterialSelected;
  final List<String> engraveInputs;
  final int productQuantity;

  ProductDetailsImage({
    this.dispatch,
    this.selectedProduct,
    this.optionalMaterialSelected,
    this.engraveInputs,
    this.productQuantity,
  });

  @override
  _ProductDetailsImageState createState() => _ProductDetailsImageState();
}

class _ProductDetailsImageState extends State<ProductDetailsImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _MainBody(
        dispatch: widget.dispatch,
        selectedProduct: widget.selectedProduct,
        optionalMaterialSelected: widget.optionalMaterialSelected,
        engraveInputs: widget.engraveInputs,
        productQuantity: widget.productQuantity,
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "Product Details",
          style: TextStyle(
            fontSize: 22,
            color: HexColor("#53586F"),
            fontWeight: FontWeight.w600,
            fontFeatures: [FontFeature.enable('smcp')],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        leadingWidth: 70.0,
        automaticallyImplyLeading: false,
        actions: [
          Center(
            child: Container(
              width: 34.0,
              height: 34.0,
              margin: EdgeInsets.only(right: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[200],
                    offset: Offset(0.0, 0.0), // (x, y)
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  "images/Group 2424.svg",
                  color: HexColor("#B3C1F2"),
                ),
              ),
            ),
          ),
        ],
        leading: Builder(
          builder: (context) => IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            icon: Container(
              width: 34.0,
              height: 34.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[200],
                    offset: Offset(0.0, 0.0), // (x, y)
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  "images/Group 934534.svg",
                  color: HexColor("#B3C1F2"),
                ),
              ),
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: SparklesDrawer(),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: double.infinity,
        constraints: BoxConstraints(maxHeight: 75.0),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.9),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(32.0),
            topLeft: Radius.circular(32.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300],
              offset: Offset(0.0, -0.2), // (x,y)
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Center(
          // child: Container(
          //   width: 300.0,
          //   height: 42.0,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(31.0),
          //   ),
          //   child: ElevatedButton(
          //     style: ButtonStyle(
          //       elevation: MaterialStateProperty.all(0.0),
          //       backgroundColor: MaterialStateProperty.all(HexColor("#6092DC")),
          //       shape: MaterialStateProperty.all(
          //         RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(31.0),
          //         ),
          //       ),
          //     ),
          //     child: Text(
          //       'Upload your photo',
          //       style: TextStyle(
          //         fontSize: 17.0,
          //         fontWeight: FontWeight.normal,
          //         color: Colors.white,
          //       ),
          //     ),
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => _ProductCustomization(
          //             dispatch: widget.dispatch,
          //             selectedProduct: widget.selectedProduct,
          //             productQuantity: widget.productQuantity,
          //             engraveInputs: widget.engraveInputs,
          //             optionalMaterialSelected: widget.optionalMaterialSelected,
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: 42.0,
                  constraints: BoxConstraints(
                    maxWidth: 163.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(31.0),
                  ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0.0),
                      backgroundColor:
                          MaterialStateProperty.all(HexColor("#F4F6FD")),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(31.0),
                          side: BorderSide(
                            width: 1.0,
                            color: HexColor("#6092DC"),
                          ),
                        ),
                      ),
                    ),
                    child: Text(
                      'Change image',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        color: HexColor("#6092DC"),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => _ProductCustomization(
                            dispatch: widget.dispatch,
                            selectedProduct: widget.selectedProduct,
                            productQuantity: widget.productQuantity,
                            engraveInputs: widget.engraveInputs,
                            optionalMaterialSelected:
                                widget.optionalMaterialSelected,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 7.0),
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: 42.0,
                  constraints: BoxConstraints(
                    maxWidth: 163.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(31.0),
                  ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0.0),
                      backgroundColor:
                          MaterialStateProperty.all(HexColor("#6092DC")),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(31.0),
                        ),
                      ),
                    ),
                    child: Text(
                      'Add to cart',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => _ProductCustomization(
                            dispatch: widget.dispatch,
                            selectedProduct: widget.selectedProduct,
                            productQuantity: widget.productQuantity,
                            engraveInputs: widget.engraveInputs,
                            optionalMaterialSelected:
                                widget.optionalMaterialSelected,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MainBody extends StatefulWidget {
  final Dispatch dispatch;
  final ProductItem selectedProduct;
  final bool optionalMaterialSelected;
  final List<String> engraveInputs;
  final int productQuantity;

  _MainBody({
    this.dispatch,
    this.selectedProduct,
    this.optionalMaterialSelected,
    this.engraveInputs,
    this.productQuantity,
  });

  @override
  __MainBodyState createState() => __MainBodyState();
}

class __MainBodyState extends State<_MainBody> {
  int currentTab = 0;

  @override
  Widget build(BuildContext context) {
    int _productQuantity =
        widget.productQuantity == null ? 1 : widget.productQuantity;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("images/Group 203.png"),
                  Dash(
                    direction: Axis.horizontal,
                    length: 90,
                    dashLength: 10,
                    dashColor: HexColor("#C4C6D2"),
                  ),
                  Image.asset("images/Group 204.png"),
                  Dash(
                    direction: Axis.horizontal,
                    length: 90,
                    dashLength: 10,
                    dashColor: HexColor("#C4C6D2"),
                  ),
                  Image.asset("images/Group 204.png"),
                ],
              ),
              SizedBox(height: 7.0),
              Container(
                width: 320.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Upload Photo",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: [HexColor('#CBD3FD'), HexColor('#5d74bc')],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(1.0, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp,
                          ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                      ),
                    ),
                    Text(
                      "Confirm Design",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: HexColor("#C4C6D2"),
                      ),
                    ),
                    Text(
                      "Customization",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: HexColor("#C4C6D2"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          SwiperWidget(productMedia: widget.selectedProduct.mediaUrls),
          SizedBox(height: 21.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 40.0,
                    constraints: BoxConstraints(
                      maxWidth: 155.0,
                    ),
                    decoration: BoxDecoration(
                      color: HexColor("#CCD4FE"),
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: HexColor("#B3C1F2")),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[300],
                          offset: Offset(0.0, 0.0), // (x,y)
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 42.5,
                              height: 42.5,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.asset(
                                  "images/image 535435.png",
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ),
                            SizedBox(width: 5.5),
                            Text(
                              "Stainless",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: HexColor("#53586F"),
                              ),
                            ),
                          ],
                        ),
                        Positioned.fill(
                          top: -7.0,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              width: 18.0,
                              height: 18.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  "images/checed_icon.svg",
                                  width: 11.0,
                                  height: 8.0,
                                  color: HexColor("#6092DC"),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 11.0),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 40.0,
                    constraints: BoxConstraints(
                      maxWidth: 155.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[300],
                          offset: Offset(0.0, 0.0), // (x,y)
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 42.5,
                              height: 42.5,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.asset(
                                  "images/image 12424.png",
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ),
                            SizedBox(width: 5.5),
                            Text(
                              "18K Gold Fish",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: HexColor("#53586F"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     Container(
          //       width: 80.0,
          //       height: 64.0,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(10.0),
          //         gradient: LinearGradient(
          //           colors: [HexColor('#E3D3FF'), HexColor('#C2A2FA')],
          //           begin: const FractionalOffset(0.0, 0.0),
          //           end: const FractionalOffset(1.0, 0.0),
          //           stops: [0.0, 1.0],
          //           tileMode: TileMode.clamp,
          //         ),
          //       ),
          //       child: Center(
          //         child: SvgPicture.asset(
          //           "images/Group 12231221.svg",
          //           width: 70.0,
          //           height: 52.0,
          //           color: Colors.white,
          //           fit: BoxFit.contain,
          //         ),
          //       ),
          //     ),
          //     Container(
          //       width: 80.0,
          //       height: 64.0,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(10.0),
          //         gradient: LinearGradient(
          //           colors: [HexColor('#E3D3FF'), HexColor('#C2A2FA')],
          //           begin: const FractionalOffset(0.0, 0.0),
          //           end: const FractionalOffset(1.0, 0.0),
          //           stops: [0.0, 1.0],
          //           tileMode: TileMode.clamp,
          //         ),
          //       ),
          //       child: Center(
          //         child: SvgPicture.asset(
          //           "images/Group 123.svg",
          //           width: 70.0,
          //           height: 52.0,
          //           color: Colors.white,
          //           fit: BoxFit.contain,
          //         ),
          //       ),
          //     ),
          //     Container(
          //       width: 80.0,
          //       height: 64.0,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(10.0),
          //         gradient: LinearGradient(
          //           colors: [HexColor('#E3D3FF'), HexColor('#C2A2FA')],
          //           begin: const FractionalOffset(0.0, 0.0),
          //           end: const FractionalOffset(1.0, 0.0),
          //           stops: [0.0, 1.0],
          //           tileMode: TileMode.clamp,
          //         ),
          //       ),
          //       child: Center(
          //         child: SvgPicture.asset(
          //           "images/Group 126.svg",
          //           width: 70.0,
          //           height: 52.0,
          //           color: Colors.white,
          //           fit: BoxFit.contain,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          SizedBox(height: 19.0),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: HexColor("#FAFCFF"),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(32.0),
                topLeft: Radius.circular(32.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300],
                  offset: Offset(0.0, -0.2), // (x, y)
                  blurRadius: 10.0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 19.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 37.0),
                  child: Text(
                    widget.selectedProduct.name,
                    style: TextStyle(
                      color: HexColor("#53586F"),
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 21.0),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "${widget.selectedProduct.oldPrice} ",
                            style: TextStyle(
                              color: HexColor("#53586F").withOpacity(.5),
                              fontSize: 18.0,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          TextSpan(
                            text: "${widget.selectedProduct.price}",
                            style: TextStyle(
                              color: HexColor("#53586F"),
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.0),
                    Text(
                      "You Save: \$40 (50%)",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: HexColor("#27AE60"),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        child: Container(
                          width: double.infinity,
                          height: 36.0,
                          constraints: BoxConstraints(
                            maxWidth: 188.0,
                          ),
                          decoration: currentTab == 0
                              ? BoxDecoration(
                                  color: HexColor("#FAFCFF"),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(16.0),
                                    bottomRight: Radius.circular(16.0),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[300],
                                      offset: Offset(0.0, 5.0), // (x, y)
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                )
                              : null,
                          child: Center(
                            child: Text(
                              "Product Details",
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700,
                                color: currentTab == 0
                                    ? HexColor("#53586F")
                                    : HexColor("#C4C6D2"),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            currentTab = 0;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Expanded(
                      child: GestureDetector(
                        child: Container(
                          width: double.infinity,
                          height: 36.0,
                          constraints: BoxConstraints(
                            maxWidth: 188.0,
                          ),
                          decoration: currentTab == 1
                              ? BoxDecoration(
                                  color: HexColor("#FAFCFF"),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16.0),
                                    bottomLeft: Radius.circular(16.0),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[300],
                                      offset: Offset(0.0, 5.0), // (x, y)
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                )
                              : null,
                          child: Center(
                            child: Text(
                              "Delivery Time",
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700,
                                color: currentTab == 1
                                    ? HexColor("#53586F")
                                    : HexColor("#C4C6D2"),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            currentTab = 1;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                currentTab == 1
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          widget.selectedProduct.productDetails != null
                              ? widget.selectedProduct.productDetails
                              : "",
                          style: TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w300,
                            height: 1.35,
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          widget.selectedProduct.deliveryTime != null
                              ? widget.selectedProduct.deliveryTime
                              : "",
                          style: TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w300,
                            height: 1.35,
                          ),
                        ),
                      ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ],
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

  _ProductCustomization({
    this.dispatch,
    this.selectedProduct,
    this.productQuantity,
    this.engraveInputs,
    this.optionalMaterialSelected,
  });

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

  List<TextEditingController> engravingControllers;

  _ProductCustomizationState({
    this.dispatch,
    this.selectedProduct,
    this.productQuantity,
    this.engraveInputs,
    this.optionalMaterialSelected,
  });

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
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            elevation: 0.0,
            actions: [
              GestureDetector(
                child: Image.asset("images/close_button_terms.png"),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          bottomNavigationBar: Container(
            height: 83.0,
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 300.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(31.0),
                  ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor:
                          MaterialStateProperty.all(HexColor("#6092DC")),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(31.0),
                        ),
                      ),
                    ),
                    child: Text(
                      'Customize and Proceed',
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      await dispatch(
                        ProductPageActionCreator.onAddToCart(
                          selectedProduct,
                          productQuantity,
                        ),
                      );
                      dispatch(ProductPageActionCreator.onGoToCart());
                    },
                  ),
                ),
              ],
            ),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 125.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 261.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.selectedProduct.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 9.0),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "\$${widget.selectedProduct.oldPrice}",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(.5),
                                    fontSize: 18.0,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                TextSpan(
                                  text: "\$${widget.selectedProduct.price}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 13.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: double.infinity,
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  decoration: BoxDecoration(
                    color: HexColor("#FAFCFF"),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32.0),
                      topRight: Radius.circular(32.0),
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 21),
                          Container(
                            constraints: BoxConstraints(maxWidth: 307.0),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Add a ",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                      color: HexColor("#53586F"),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "personal message ",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w800,
                                      color: HexColor("#839BE7"),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "and ",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                      color: HexColor("#53586F"),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "gold finish",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w800,
                                      color: HexColor("#839BE7"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 45.0),
                          if (widget.selectedProduct.engraveAvailable &&
                              engravingsCount > 0)
                            Container(
                              height: 145.0,
                              width: double.infinity,
                              constraints: BoxConstraints(maxWidth: 343.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey[300],
                                    offset: Offset(0.0, 2.0), // (x,y)
                                    blurRadius: 5.0,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 75.0,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12.0),
                                        bottomLeft: Radius.circular(12.0),
                                      ),
                                      child: widget.selectedProduct
                                                  .engraveExampleUrl !=
                                              null
                                          ? CachedNetworkImage(
                                              imageUrl: selectedProduct
                                                  .engraveExampleUrl,
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              "images/image-not-found.png",
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Engrave Personal Message",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600,
                                              color: HexColor("#53586F"),
                                            ),
                                          ),
                                          SizedBox(height: 8.0),
                                          Text(
                                            "50% Off - One - Time Offer !",
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: HexColor("#EB5757"),
                                            ),
                                          ),
                                          SizedBox(height: 10.0),
                                          RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "\$${widget.selectedProduct.engraveOldPrice} ",
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: HexColor("#53586F")
                                                        .withOpacity(.5),
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      "\$${widget.selectedProduct.engravePrice}",
                                                  style: TextStyle(
                                                    fontSize: 22.0,
                                                    fontWeight: FontWeight.w800,
                                                    color: HexColor("#53586F"),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 9.0),
                                          Container(
                                            height: 55.0,
                                            child: ListView.separated(
                                              itemCount: engravingsCount,
                                              shrinkWrap: true,
                                              padding: EdgeInsets.zero,
                                              separatorBuilder: (_, __) {
                                                return SizedBox(height: 5.0);
                                              },
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  width: double.infinity,
                                                  constraints: BoxConstraints(
                                                    maxWidth: 240.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: HexColor("#FAFCFF"),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            22.0),
                                                  ),
                                                  child: TextField(
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14.0,
                                                    ),
                                                    onChanged: (content) {
                                                      var engravingListActual =
                                                          List<String>.empty(
                                                              growable: true);
                                                      for (var i = 0;
                                                          i <
                                                              engravingControllers
                                                                  .length;
                                                          i++) {
                                                        engravingListActual.add(
                                                            engravingControllers[
                                                                    i]
                                                                .text);
                                                      }
                                                      dispatch(ProductPageActionCreator
                                                          .onSetEngravingInputs(
                                                              engravingListActual));
                                                    },
                                                    controller:
                                                        engravingControllers[
                                                            index],
                                                    decoration: InputDecoration(
                                                      isDense: true,
                                                      hintText:
                                                          'Enter your words here',
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                        top: 7.0,
                                                        bottom: 7.0,
                                                        left: 12.0,
                                                      ),
                                                      hintStyle: TextStyle(
                                                        color:
                                                            HexColor("#C4C6D2"),
                                                        fontSize: 14.0,
                                                      ),
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      border:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(height: 20.0),
                          if (widget
                              .selectedProduct.optionalFinishMaterialEnabled)
                            Container(
                              height: 145.0,
                              width: double.infinity,
                              constraints: BoxConstraints(maxWidth: 343.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey[300],
                                    offset: Offset(0.0, 2.0), // (x,y)
                                    blurRadius: 5.0,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 75.0,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12.0),
                                        bottomLeft: Radius.circular(12.0),
                                      ),
                                      child: widget.selectedProduct
                                                  .optionalMaterialExampleUrl !=
                                              null
                                          ? CachedNetworkImage(
                                              imageUrl: widget.selectedProduct
                                                  .optionalMaterialExampleUrl,
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              "images/image-not-found.png",
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "2.18K Gold Finish",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600,
                                              color: HexColor("#53586F"),
                                            ),
                                          ),
                                          SizedBox(height: 8.0),
                                          Text(
                                            "50% Off - One - Time Offer !",
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: HexColor("#EB5757"),
                                            ),
                                          ),
                                          SizedBox(height: 10.0),
                                          RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "\$${widget.selectedProduct.optionalFinishMaterialOldPrice} ",
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: HexColor("#53586F")
                                                        .withOpacity(.5),
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      "\$${widget.selectedProduct.optionalFinishMaterialPrice}",
                                                  style: TextStyle(
                                                    fontSize: 22.0,
                                                    fontWeight: FontWeight.w800,
                                                    color: HexColor("#53586F"),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 9.0),
                                          Container(
                                            width: double.infinity,
                                            height: 32.0,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 14.0),
                                            constraints: BoxConstraints(
                                              maxWidth: 240.0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: HexColor("#FAFCFF"),
                                              borderRadius:
                                                  BorderRadius.circular(22.0),
                                            ),
                                            child: InkWell(
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 32,
                                                    height: double.infinity,
                                                    child:
                                                        !optionalMaterialSelected
                                                            ? SvgPicture.asset(
                                                                "images/Vector5.svg",
                                                              )
                                                            : SvgPicture.asset(
                                                                "images/Group 170.svg",
                                                              ),
                                                  ),
                                                  Expanded(
                                                    child: Center(
                                                      child: Text(
                                                        "Add 18K Gold Finish ",
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                          color: HexColor(
                                                              "#53586F"),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              onTap: () {
                                                print(
                                                    'optionalMaterialSelected: $optionalMaterialSelected !optionalMaterialSelected: ${!optionalMaterialSelected}');
                                                dispatch(ProductPageActionCreator
                                                    .onSetOptionMaterialSelected(
                                                        !optionalMaterialSelected));

                                                var engravingListActual =
                                                    List<String>.empty(
                                                        growable: true);
                                                for (var i = 0;
                                                    i <
                                                        engravingControllers
                                                            .length;
                                                    i++) {
                                                  engravingListActual.add(
                                                      engravingControllers[i]
                                                          .text);
                                                }
                                                setState(() {
                                                  optionalMaterialSelected =
                                                      !optionalMaterialSelected;
                                                  engraveInputs =
                                                      engravingListActual;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:com.floridainc.dosparkles/actions/app_config.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:com.floridainc.dosparkles/widgets/sparkles_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class OrderProductDetailsWidget extends StatefulWidget {
  final product;

  const OrderProductDetailsWidget({Key key, this.product}) : super(key: key);

  @override
  _OrderProductDetailsWidgetState createState() =>
      _OrderProductDetailsWidgetState();
}

class _OrderProductDetailsWidgetState extends State<OrderProductDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _MainBody(
        product: widget.product,
      ),
      backgroundColor: Colors.white,
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
        backgroundColor: Colors.white,
        title: Text(
          "Details of product",
          style: TextStyle(
            fontSize: 22,
            color: HexColor("#53586F"),
            fontWeight: FontWeight.w600,
            fontFeatures: [FontFeature.enable('smcp')],
          ),
        ),
      ),
      drawer: SparklesDrawer(),
    );
  }
}

class _MainBody extends StatefulWidget {
  final product;

  _MainBody({this.product});

  @override
  __MainBodyState createState() => __MainBodyState();
}

class __MainBodyState extends State<_MainBody> {
  var productMedia;
  int currentTab = 0;

  @override
  void initState() {
    super.initState();

    productMedia = widget.product['media']
        .map(
          (item) => AppConfig.instance.baseApiHost + item['url'].toString(),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20.0),
          Swiper(
            itemBuilder: (BuildContext context, int index) {
              return Image.network(
                productMedia[index],
                fit: BoxFit.fill,
              );
            },
            itemCount: productMedia.length,
            itemWidth: Adapt.screenW() * 0.6,
            itemHeight: Adapt.screenW() * 0.6,
            layout: SwiperLayout.STACK,
            pagination: SwiperPagination(
              margin: EdgeInsets.only(top: Adapt.screenW() * 0.6 + 20),
              builder: DotSwiperPaginationBuilder(
                color: Colors.grey,
                activeColor: HexColor('#3D9FB0'),
              ),
            ),
          ),
          SizedBox(height: 21.0),
          Container(
            height: 70.0,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              separatorBuilder: (context, index) => SizedBox(width: 14.0),
              itemCount: productMedia.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      width: 70.0,
                      height: 70.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: CachedNetworkImage(
                          imageUrl: productMedia[index],
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    index == 2
                        ? Positioned.fill(
                            child: Container(
                              width: 70.0,
                              height: 70.0,
                              color: Colors.white.withOpacity(.4),
                            ),
                          )
                        : SizedBox.shrink(child: null),
                  ],
                );
              },
            ),
          ),
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
                    widget.product['name'],
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
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          TextSpan(
                            text: "\$${widget.product['price']} ",
                            style: TextStyle(
                              color: HexColor("#53586F"),
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: "\$${widget.product['oldPrice']}",
                            style: TextStyle(
                              color: HexColor("#53586F").withOpacity(.5),
                              fontSize: 18.0,
                              decoration: TextDecoration.lineThrough,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Purchase This  Best - Seller and We Guarantee it will Exceed Your Highest Expectations. Purchase This Best - Seller and We Guarantee it will Exceed Your Highest Expectations! Purchase This  Best - Seller and We Guarantee it will Exceed Your Highest Expectations !",
                        style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w300,
                          height: 1.35,
                        ),
                      ),
                    ],
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

class _CustomBody extends StatefulWidget {
  final product;

  _CustomBody({this.product});

  @override
  __CustomBodyState createState() => __CustomBodyState();
}

class __CustomBodyState extends State<_CustomBody> {
  var productMedia;
  int currentTab = 0;

  @override
  void initState() {
    super.initState();

    productMedia = widget.product['media']
        .map(
          (item) => AppConfig.instance.baseApiHost + item['url'].toString(),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20.0),
          Swiper(
            itemBuilder: (BuildContext context, int index) {
              return Image.network(
                productMedia[index],
                fit: BoxFit.fill,
              );
            },
            itemCount: productMedia.length,
            itemWidth: Adapt.screenW() * 0.6,
            itemHeight: Adapt.screenW() * 0.6,
            layout: SwiperLayout.STACK,
            pagination: SwiperPagination(
              margin: EdgeInsets.only(top: Adapt.screenW() * 0.6 + 20),
              builder: DotSwiperPaginationBuilder(
                color: Colors.grey,
                activeColor: HexColor('#3D9FB0'),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Container(
            height: 71.0,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.asset(
                        "images/image 2.png",
                        fit: BoxFit.cover,
                        width: 70.0,
                        height: double.infinity,
                      ),
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
                SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "your Uploaded image".toUpperCase(),
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: HexColor("#C4C6D2"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "your metal".toUpperCase(),
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          color: HexColor("#C4C6D2"),
                        ),
                      ),
                      SizedBox(height: 12.0),
                      Container(
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
                    ],
                  ),
                ),
                SizedBox(width: 11.0),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Engraving".toUpperCase(),
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          color: HexColor("#C4C6D2"),
                        ),
                      ),
                      SizedBox(height: 12.0),
                      Container(
                        width: double.infinity,
                        height: 40.0,
                        constraints: BoxConstraints(
                          maxWidth: 155.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: HexColor("#CCD4FE"),
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
                          alignment: Alignment.center,
                          children: [
                            Text(
                              "Engraving name",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: HexColor("#53586F"),
                              ),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
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
                    "${widget.product['name']} ",
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
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          TextSpan(
                            text: "\$${widget.product['price']} ",
                            style: TextStyle(
                              color: HexColor("#53586F"),
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: "\$${widget.product['oldPrice']} ",
                            style: TextStyle(
                              color: HexColor("#53586F").withOpacity(.5),
                              fontSize: 18.0,
                              decoration: TextDecoration.lineThrough,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w600,
                          height: 1.35,
                        ),
                      ),
                      Text(
                        "Surprise someone you love with this unique and elegant jewelry item 🎁.",
                        style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w300,
                          height: 1.35,
                        ),
                      ),
                      Text(
                        "We say 'UNIQUE' because each piece is different when you provide your photo.",
                        style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w300,
                          height: 1.35,
                        ),
                      ),
                      Text(
                        "This hand-crafted piece will never fade and is built to last!",
                        style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w300,
                          height: 1.35,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        "Specifics",
                        style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w600,
                          height: 1.35,
                        ),
                      ),
                      Text(
                        "Made in the U.S.A",
                        style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w300,
                          height: 1.35,
                        ),
                      ),
                      Text(
                        "316 Steel or 18k Gold Finish",
                        style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w300,
                          height: 1.35,
                        ),
                      ),
                      Text(
                        "Adjustable Necklace Chain Measures 18'-22'",
                        style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w300,
                          height: 1.35,
                        ),
                      ),
                      Text(
                        "Water-Resistant",
                        style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w300,
                          height: 1.35,
                        ),
                      ),
                    ],
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

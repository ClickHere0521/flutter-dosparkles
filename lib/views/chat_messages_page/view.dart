import 'dart:ui';

import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:com.floridainc.dosparkles/actions/api/graphql_client.dart';
import 'package:com.floridainc.dosparkles/actions/app_config.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/models/models.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:com.floridainc.dosparkles/widgets/order_product_details.dart';
import 'package:com.floridainc.dosparkles/widgets/sparkles_drawer.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flui/flui.dart';

import 'dart:async';
import 'state.dart';

Widget _changeOrderButton(BuildContext context, String orderId) {
  bool isPublic = GlobalStore.store.getState().user.role == 'Public';

  Future getInitialData() async {
    QueryResult result = await BaseGraphQLClient.instance.fetchOrder(orderId);
    return result.data['orders'][0];
  }

  return FutureBuilder(
      future: getInitialData(),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            !snapshot.hasError &&
            snapshot.data['status'] == 'cancelled' &&
            snapshot.data['rejectedReason'] != null &&
            snapshot.data['rejectedReason'] != "" &&
            isPublic) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 29.0),
              Container(
                width: 120.0,
                height: 30.0,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      HexColor("#27AE60"),
                    ),
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                    elevation: MaterialStateProperty.all(0.0),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27.0),
                      ),
                    ),
                  ),
                  child: Text(
                    "Change order",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => _ChangeOrder(
                          order: snapshot.data,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
        return SizedBox.shrink(child: null);
      });
}

Widget buildView(
    ChatMessagesPageState state, Dispatch dispatch, ViewService viewService) {
  final pages = [
    BubblePage(
      chatId: state.chatId,
      userId: state.userId,
      conversationName: state.conversationName,
    )
  ];

  Widget _buildPage(Widget page) {
    return page;
  }

  return Scaffold(
    body: FutureBuilder(
        future: _checkContextInit(
          Stream<double>.periodic(Duration(milliseconds: 50),
              (x) => MediaQuery.of(viewService.context).size.height),
        ),
        builder: (_, snapshot) {
          if (snapshot.hasData) if (snapshot.data > 0) {
            Adapt.initContext(viewService.context);
            return PageView.builder(
              physics: NeverScrollableScrollPhysics(),
              controller: state.pageController,
              allowImplicitScrolling: false,
              itemCount: pages.length,
              itemBuilder: (context, index) {
                return _buildPage(pages[index]);
              },
            );
          }
          return Container();
        }),
  );
}

Future<double> _checkContextInit(Stream<double> source) async {
  await for (double value in source) {
    if (value > 0) {
      return value;
    }
  }
  return 0.0;
}

Future fetchData(String chatId) async {
  QueryResult chat = await BaseGraphQLClient.instance.fetchChat(chatId);

  return chat.data['chats'][0];
}

Stream fetchDataProcess(String chatId) async* {
  while (true) {
    yield await fetchData(chatId);
    await Future<void>.delayed(Duration(seconds: 30));
  }
}

class BubblePage extends StatefulWidget {
  final String chatId;
  final String userId;
  final String conversationName;

  const BubblePage({
    Key key,
    this.chatId = '',
    this.userId = '',
    this.conversationName = 'MedDrive',
  }) : super(key: key);

  @override
  State<BubblePage> createState() => _BubblePageState();
}

class _BubblePageState extends State<BubblePage> {
  var formatter = new DateFormat.yMMMMd().add_jm();
  String inputData = "";
  var _controller = TextEditingController();

  Widget _buildBubbleContent(double maxWidth, context) {
    Widget insetV = SizedBox(height: 36);
    Widget insetVSmall = SizedBox(height: 10);
    Widget insetH = SizedBox(width: 4);
    double tWidth = maxWidth - 160;

    return StreamBuilder(
      stream: fetchDataProcess(widget.chatId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && !snapshot.hasError) {
          return snapshot.data['chat_messages'] == null
              ? Text('No Data', textAlign: TextAlign.center)
              : Expanded(
                  child: ListView(
                    children: snapshot.data['chat_messages']
                        .map<Widget>((chatMessage) {
                      var orderId = chatMessage['order'] != null
                          ? chatMessage['order']['id']
                          : '';

                      return chatMessage['user'] != null &&
                              widget.userId == chatMessage['user']['id']
                          ? Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Positioned(
                                        bottom: -20.0,
                                        left: 28.0,
                                        child: Text(
                                          '${formatter.format(DateTime.parse(chatMessage['createdAt']))}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black38,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        constraints: BoxConstraints(
                                            minHeight: 38.0, maxWidth: 300.0),
                                        child: Bubble(
                                          margin: BubbleEdges.only(top: 10),
                                          elevation: 5.0,
                                          shadowColor: Colors.black26,
                                          padding: BubbleEdges.only(
                                            top: 9.0,
                                            bottom: 9.0,
                                            right: 15.0,
                                            left: 20.0,
                                          ),
                                          borderColor: Colors.grey[50],
                                          stick: true,
                                          color: Colors.white,
                                          nip: BubbleNip.rightBottom,
                                          child: Text(
                                            chatMessage['text'] != null
                                                ? chatMessage['text']
                                                : "",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: HexColor("#53586F"),
                                            ),
                                            softWrap: true,
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                insetV,
                              ],
                            )
                          : Column(
                              children: [
                                chatMessage['messageType'] == 'text'
                                    ? Align(
                                        alignment: Alignment.centerLeft,
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Positioned(
                                              bottom: -20.0,
                                              left: 28.0,
                                              child: Text(
                                                '${formatter.format(DateTime.parse(chatMessage['createdAt']))}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black38,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              constraints: BoxConstraints(
                                                  minHeight: 38.0,
                                                  maxWidth: 300.0),
                                              child: Bubble(
                                                margin:
                                                    BubbleEdges.only(top: 10),
                                                stick: true,
                                                elevation: 5.0,
                                                shadowColor: Colors.black26,
                                                padding: BubbleEdges.only(
                                                  top: 9.0,
                                                  bottom: 9.0,
                                                  left: 15.0,
                                                  right: 20.0,
                                                ),
                                                borderColor: Colors.grey[50],
                                                color: Colors.white,
                                                nip: BubbleNip.leftBottom,
                                                child: Text(
                                                  chatMessage['text'],
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: HexColor("#53586F"),
                                                  ),
                                                  softWrap: true,
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Align(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          children: [
                                            _ChatOrderBlock(
                                              orderId: orderId,
                                              createdAt:
                                                  chatMessage['createdAt'],
                                            ),
                                            _changeOrderButton(
                                                context, orderId),
                                          ],
                                        ),
                                      ),
                                insetV,
                              ],
                            );
                    }).toList(),
                  ),
                );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Adapt.screenH() / 4),
              SizedBox(
                  width: Adapt.screenW(),
                  height: Adapt.screenH() / 4,
                  child: Container(
                    child: CircularProgressIndicator(),
                    alignment: Alignment.center,
                  ))
            ],
          );
        }
      },
    );
  }

  getConversationName(conversation, userId) {
    var chatNames = [];
    var users = conversation['users'];
    for (int i = 0; i < users.length; i++) {
      if (users[i] != null && users[i]['id'] != userId) {
        chatNames.add('${users[i]['name']}');
      }
    }
    return chatNames.join(', ');
  }

  addMessage(text, chatId, userId) async {
    await BaseGraphQLClient.instance
        .createMessage({'text': text, 'chat': chatId, 'user': userId});
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);
    final double width = queryData.size.width;

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
          appBar: AppBar(
            title: Text(
              widget.conversationName,
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontFeatures: [FontFeature.enable('smcp')],
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leadingWidth: 70.0,
            automaticallyImplyLeading: false,
            leading: InkWell(
              child: Image.asset("images/back_button_white.png"),
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          body: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 10, left: 8.0, right: 8.0),
            decoration: BoxDecoration(
              color: HexColor("#FAFCFF"),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32.0),
                topRight: Radius.circular(32.0),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 136.0,
                  height: 28.0,
                  decoration: BoxDecoration(
                    color: HexColor("#EAECF2"),
                    borderRadius: BorderRadius.circular(17.0),
                  ),
                  child: Center(
                      child: Text(
                    "November 16",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
                ),
                SizedBox(height: 18.0),
                _buildBubbleContent(width, context),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            height: 83.0,
            padding: EdgeInsets.only(top: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, -0.2), // (x,y)
                  blurRadius: 10.0,
                ),
              ],
            ),
            child: Column(
              children: [
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
                        controller: _controller,
                        onChanged: (text) {
                          this.inputData = text;
                        },
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
                          Icons.send,
                          color: Colors.white,
                          size: 17.0,
                        ),
                      ),
                      onTap: () {
                        if (this.inputData != "") {
                          addMessage(
                            this.inputData,
                            widget.chatId,
                            widget.userId,
                          );
                          this.inputData = "";
                          _controller.clear();
                        }
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ChatOrderBlock extends StatefulWidget {
  var formatter = new DateFormat.yMMMMd().add_jm();
  bool isAdmin = GlobalStore.store.getState().user.role == 'Store Manager';

  final orderId;
  final createdAt;

  _ChatOrderBlock({this.orderId, this.createdAt});

  @override
  __ChatOrderBlockState createState() => __ChatOrderBlockState();
}

class __ChatOrderBlockState extends State<_ChatOrderBlock> {
  bool isApproveClicked = false;
  Future getInitialData() async {
    QueryResult result =
        await BaseGraphQLClient.instance.fetchOrder(widget.orderId);
    if (result.hasException) print(result.exception);

    return result.data['orders'][0];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getInitialData(),
      builder: (context, snapshot) {
        if (snapshot.hasData && !snapshot.hasError) {
          var order = snapshot.data;
          bool isStatusRejected = order['status'] == 'cancelled';
          bool isStatusConfirmed = order['status'] == 'confirmed';

          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 300.0,
              height: isStatusRejected
                  ? 200.0
                  : widget.isAdmin && !isStatusConfirmed
                      ? 160.0
                      : 115.0,
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.passthrough,
                children: [
                  Positioned(
                    bottom: -20.0,
                    left: 17.0,
                    child: Text(
                      '${widget.formatter.format(DateTime.parse(widget.createdAt))}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black38,
                      ),
                    ),
                  ),
                  Bubble(
                    margin: BubbleEdges.only(top: 10),
                    elevation: 5.0,
                    shadowColor: Colors.grey[50].withOpacity(.5),
                    padding:
                        BubbleEdges.symmetric(vertical: 9.0, horizontal: 10.0),
                    radius: Radius.circular(8.0),
                    borderColor: Colors.grey[50],
                    stick: true,
                    color: Colors.white,
                    nip: BubbleNip.leftBottom,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          child: Container(
                            color: Colors.white,
                            width: double.infinity,
                            height: 86.0,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 85.0,
                                  height: double.infinity,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: order['media'] != null &&
                                            order['media'].length > 0
                                        ? CachedNetworkImage(
                                            imageUrl:
                                                AppConfig.instance.baseApiHost +
                                                    order['media'][0]['url'],
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          )
                                        : Image.asset(
                                            "images/image-not-found.png",
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Container(
                                  width: 170.0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      order['id'] != null
                                          ? Text(
                                              order['id'],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: HexColor("#0F142B"),
                                              ),
                                            )
                                          : SizedBox.shrink(child: null),
                                      Text(
                                        order['status'],
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: isStatusRejected
                                              ? Colors.red
                                              : isStatusConfirmed
                                                  ? Colors.green
                                                  : Colors.orange,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      order['products'] != null &&
                                              order['products'].length > 0
                                          ? SizedBox(
                                              width: 100.0,
                                              height: 15.0,
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    top: 0,
                                                    left: 0,
                                                    child: Text(
                                                      "Number:",
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color:
                                                            HexColor("#53586F"),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 0,
                                                    left: 70.0,
                                                    child: Text(
                                                      "${order['products'].length}",
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : SizedBox.shrink(child: null),
                                      SizedBox(height: 4),
                                      SizedBox(
                                        width: 100.0,
                                        height: 15.0,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              top: 0,
                                              left: 0,
                                              child: Text(
                                                "Total price:",
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: HexColor("#53586F"),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 0,
                                              left: 70.0,
                                              child: Text(
                                                "\$${order['totalPrice']}",
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderWidget(
                                  orderId: widget.orderId,
                                ),
                              ),
                            );
                          },
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              SizedBox(height: 12.0),
                              if (widget.isAdmin &&
                                  !isStatusRejected &&
                                  !isStatusConfirmed)
                                Row(
                                  children: [
                                    Container(
                                      width: 120.0,
                                      height: 30.0,
                                      child: OutlinedButton(
                                        style: ButtonStyle(
                                          side: MaterialStateProperty.all(
                                            BorderSide(color: Colors.red),
                                          ),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(27.0),
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          "Reject",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        onPressed: () => _rejectDialog(
                                            context, widget.orderId),
                                      ),
                                    ),
                                    SizedBox(width: 22.0),
                                    Container(
                                      width: 120.0,
                                      height: 30.0,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty
                                              .resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                              if (states.contains(
                                                  MaterialState.disabled))
                                                return HexColor("#C4C6D2");
                                              return HexColor("#27AE60");
                                            },
                                          ),
                                          elevation:
                                              MaterialStateProperty.all(0.0),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(27.0),
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          "Approve",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        onPressed: isApproveClicked
                                            ? null
                                            : () async {
                                                setState(() {
                                                  isApproveClicked = true;
                                                });
                                                QueryResult result =
                                                    await BaseGraphQLClient
                                                        .instance
                                                        .changeOrder(
                                                            widget.orderId,
                                                            "confirmed",
                                                            "");
                                                if (result.hasException)
                                                  print(result.exception);
                                              },
                                      ),
                                    ),
                                  ],
                                ),
                              if (isStatusRejected)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Reason why reject:",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    SizedBox(height: 6.0),
                                    Container(
                                      width: double.infinity,
                                      height: 51.0,
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: HexColor("#EDEEF2"),
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: Text(
                                        order['rejectedReason'] != null
                                            ? order['rejectedReason']
                                            : "",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
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
          );
        } else {
          return Container();
        }
      },
    );
  }
}

Future<void> _rejectDialog(BuildContext context, String orderId) async {
  String inputValue = "";

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: AlertDialog(
          title: Center(child: Text('REJECT')),
          titleTextStyle: TextStyle(
            color: Colors.red,
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            fontFeatures: [FontFeature.enable('smcp')],
          ),
          titlePadding: EdgeInsets.only(top: 30.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          insetPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
          contentPadding: EdgeInsets.zero,
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 9.0),
                Text(
                  'Enter reason why you reject',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20.0),
                Container(
                  height: 40.0,
                  width: MediaQuery.of(context).size.width * 0.85,
                  constraints: BoxConstraints(maxWidth: 355.0),
                  margin: EdgeInsets.only(
                    left: 12.0,
                    right: 12.0,
                  ),
                  decoration: BoxDecoration(
                    color: HexColor("#EDEEF2"),
                    borderRadius: BorderRadius.circular(22.0),
                  ),
                  child: TextField(
                    onChanged: (text) {
                      inputValue = text;
                    },
                    style: TextStyle(color: Colors.black, fontSize: 14),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Enter here',
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 10,
                      ),
                      fillColor: Colors.white,
                      hintStyle: TextStyle(color: Colors.grey),
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.0),
                Container(
                  height: 53.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16.0),
                          ),
                          child: Ink(
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: HexColor("#FAFCFF"),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16.0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(16.0),
                          ),
                          child: Ink(
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: HexColor("#6092DC"),
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(16.0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Confirm',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          onTap: () async {
                            QueryResult result = await BaseGraphQLClient
                                .instance
                                .changeOrder(orderId, "cancelled", inputValue);
                            if (result.hasException) print(result.exception);
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class OrderWidget extends StatefulWidget {
  final orderId;

  const OrderWidget({Key key, this.orderId}) : super(key: key);

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  double allProductsTotalPrice = 0.0;

  Future getInitialData() async {
    QueryResult result =
        await BaseGraphQLClient.instance.fetchOrder(widget.orderId);
    if (result.hasException) print(result.exception);
    var order = result.data['orders'][0];
    return order;
  }

  Future<void> getOrderTotalPrice() async {
    QueryResult result =
        await BaseGraphQLClient.instance.fetchOrder(widget.orderId);
    if (result.hasException) print(result.exception);
    var order = result.data['orders'][0];

    if (order != null && order['totalPrice'] != null) {
      setState(() {
        allProductsTotalPrice = double.parse(order['totalPrice'].toString());
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getOrderTotalPrice();
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
          appBar: AppBar(
            title: Text(
              "Details of order",
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontFeatures: [FontFeature.enable('smcp')],
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leadingWidth: 70.0,
            automaticallyImplyLeading: false,
            leading: InkWell(
              child: Image.asset("images/back_button_white.png"),
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: double.infinity,
            padding: EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
            decoration: BoxDecoration(
              color: HexColor("#FAFCFF"),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32.0),
                topRight: Radius.circular(32.0),
              ),
            ),
            child: FutureBuilder(
              future: getInitialData(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData && !snapshot.hasError) {
                  var order = snapshot.data;
                  List<dynamic> products = order['products'];

                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5.0),
                          height: MediaQuery.of(context).size.height,
                          child: ListView.builder(
                            itemCount: products.length,
                            itemBuilder: (_, index) {
                              var product = products[index];

                              if (product != null) {
                                return Card(
                                  elevation: 5.0,
                                  margin: EdgeInsets.only(bottom: 16.0),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  shadowColor: Colors.black26,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    side: BorderSide(color: Colors.grey[50]),
                                  ),
                                  child: InkWell(
                                    child: Container(
                                      width: double.infinity,
                                      height: 111.0,
                                      constraints:
                                          BoxConstraints(maxWidth: 343.0),
                                      padding: EdgeInsets.all(10.0),
                                      child: Container(
                                        width: double.infinity,
                                        height: 91.0,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 78.0,
                                              height: double.infinity,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(16.0),
                                                child: product['thumbnail'] !=
                                                        null
                                                    ? CachedNetworkImage(
                                                        imageUrl: AppConfig
                                                                .instance
                                                                .baseApiHost +
                                                            product['thumbnail']
                                                                ['url'],
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                      )
                                                    : SizedBox.shrink(
                                                        child: null),
                                              ),
                                            ),
                                            SizedBox(width: 10.0),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    product['name'],
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      color:
                                                          HexColor("#53586F"),
                                                    ),
                                                  ),
                                                  SizedBox(height: 12.0),
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: product[
                                                                      'price'] !=
                                                                  null
                                                              ? "\$${product['price']} "
                                                              : ' ',
                                                          style: TextStyle(
                                                            fontSize: 22.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: HexColor(
                                                                "#53586F"),
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: order['orderDetails'] !=
                                                                      null &&
                                                                  order['orderDetails']
                                                                          .length >
                                                                      0 &&
                                                                  order['orderDetails']
                                                                              [
                                                                              index]
                                                                          [
                                                                          'quantity'] !=
                                                                      null
                                                              ? "x${order['orderDetails'][index]['quantity']}"
                                                              : '',
                                                          style: TextStyle(
                                                            fontSize: 16.0,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              OrderProductDetailsWidget(
                                            product: products[index],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return SizedBox.shrink(child: null);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: Adapt.screenH() / 4),
                    SizedBox(
                      width: Adapt.screenW(),
                      height: Adapt.screenH() / 4,
                      child: Container(
                        child: CircularProgressIndicator(),
                        alignment: Alignment.center,
                      ),
                    )
                  ],
                );
              },
            ),
          ),
          bottomNavigationBar: Container(
            height: 83.0,
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, -0.2), // (x,y)
                  blurRadius: 10.0,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "TOTAL PRICE:",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "\$$allProductsTotalPrice",
                      style: TextStyle(
                        fontSize: 26.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ChangeOrder extends StatefulWidget {
  final order;

  const _ChangeOrder({Key key, this.order}) : super(key: key);

  @override
  __ChangeOrderState createState() => __ChangeOrderState();
}

class __ChangeOrderState extends State<_ChangeOrder> {
  int currentTab = 0;

  @override
  Widget build(BuildContext context) {
    var productMedia = widget.order['products'][0]['media'].map((item) {
      return AppConfig.instance.baseApiHost + item['url'].toString();
    }).toList();

    return Scaffold(
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
          "Change Order",
          style: TextStyle(
            fontSize: 22,
            color: HexColor("#53586F"),
            fontWeight: FontWeight.w600,
            fontFeatures: [FontFeature.enable('smcp')],
          ),
        ),
      ),
      drawer: SparklesDrawer(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Image.asset(
                          "images/image 2.png",
                          width: 70.0,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          width: 70.0,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: Colors.white.withOpacity(.4),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: SvgPicture.asset(
                            "images/cloud_white.svg",
                            color: Colors.white,
                            width: 24.0,
                            height: 18.0,
                            fit: BoxFit.cover,
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
                        SizedBox(height: 2.0),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Files should be ",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: HexColor("#C4C6D2"),
                                ),
                              ),
                              TextSpan(
                                text: "PNG, JPG ",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600,
                                  color: HexColor("#53586F").withOpacity(.7),
                                ),
                              ),
                              TextSpan(
                                text: "size - 0000",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: HexColor("#C4C6D2"),
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
            SizedBox(height: 12.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Engraving".toUpperCase(),
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: HexColor("#C4C6D2"),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              height: 40.0,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: HexColor("#EDEEF2"),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextField(
                onChanged: (text) {},
                style: TextStyle(
                  color: HexColor("#53586F"),
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Engraving name',
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 11,
                    horizontal: 16,
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
            ),
            SizedBox(height: 20.0),
            Center(
              child: Container(
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
                    'Save',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
            SizedBox(height: 18.0),
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
                      "${widget.order['products'][0]['name']}",
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
                              text:
                                  "\$${widget.order['products'][0]['price']} ",
                              style: TextStyle(
                                color: HexColor("#53586F"),
                                fontSize: 24.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text:
                                  "\$${widget.order['products'][0]['oldPrice']}",
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
                        child: InkWell(
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
                        child: InkWell(
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
                            height: 1.35,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Surprise someone you love with this unique and elegant jewelry item 🎁.",
                          style: TextStyle(
                            fontSize: 11.0,
                            height: 1.35,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(
                          "We say 'UNIQUE' because each piece is different when you provide your photo.",
                          style: TextStyle(
                            fontSize: 11.0,
                            height: 1.35,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(
                          "This hand-crafted piece will never fade and is built to last!",
                          style: TextStyle(
                            fontSize: 11.0,
                            height: 1.35,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          "Specifics",
                          style: TextStyle(
                            fontSize: 11.0,
                            height: 1.35,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Made in the U.S.A",
                          style: TextStyle(
                            fontSize: 11.0,
                            height: 1.35,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(
                          "316 Steel or 18k Gold Finish",
                          style: TextStyle(
                            fontSize: 11.0,
                            height: 1.35,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(
                          "Adjustable Necklace Chain Measures 18'-22'",
                          style: TextStyle(
                            fontSize: 11.0,
                            height: 1.35,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(
                          "Water-Resistant",
                          style: TextStyle(
                            fontSize: 11.0,
                            height: 1.35,
                            fontWeight: FontWeight.w300,
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
      ),
    );
  }
}

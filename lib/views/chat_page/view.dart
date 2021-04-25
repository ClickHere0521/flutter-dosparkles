import 'dart:ui';

import 'package:com.floridainc.dosparkles/models/cart_item_model.dart';
import 'package:com.floridainc.dosparkles/utils/general.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:com.floridainc.dosparkles/widgets/sparkles_drawer.dart';
import 'package:com.floridainc.dosparkles/views/chat_page/action.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/actions/api/graphql_client.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:com.floridainc.dosparkles/actions/app_config.dart';
import 'dart:convert';
import 'state.dart';
import 'package:flui/flui.dart';

Widget buildView(
    ChatPageState state, Dispatch dispatch, ViewService viewService) {
  final pages = [
    _FirstPage(
      continueTapped: () => dispatch(ChatPageActionCreator.onStart()),
      shoppingCart: state.shoppingCart,
    ),
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

class _FirstPage extends StatefulWidget {
  final Function continueTapped;
  final List<CartItem> shoppingCart;

  const _FirstPage({this.continueTapped, this.shoppingCart});

  @override
  __FirstPageState createState() => __FirstPageState();
}

class __FirstPageState extends State<_FirstPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
            padding: EdgeInsets.only(top: 30.0, left: 8.0, right: 8.0),
            decoration: BoxDecoration(
              color: HexColor("#FAFCFF"),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32.0),
                topRight: Radius.circular(32.0),
              ),
            ),
            child: GlobalStore.store.getState().user.role == "Store Manager"
                ? StorePageWidget()
                : ChatPageWidget(),
          ),
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(
              "Inbox",
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
            child: BottomNavigationBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  label: "",
                  icon: SvgPicture.asset(
                    'images/Vector.svg',
                    color: HexColor("#C4C6D2"),
                  ),
                  activeIcon: SvgPicture.asset(
                    'images/Vector.svg',
                    color: HexColor("#6092DC"),
                  ),
                ),
                BottomNavigationBarItem(
                  label: "",
                  icon: SvgPicture.asset(
                    'images/Group.svg',
                    color: HexColor("#C4C6D2"),
                  ),
                  activeIcon: SvgPicture.asset(
                    'images/Group.svg',
                    color: HexColor("#6092DC"),
                  ),
                ),
                BottomNavigationBarItem(
                  label: "",
                  icon: SvgPicture.asset(
                    'images/Group 41.svg',
                    color: HexColor("#C4C6D2"),
                  ),
                  activeIcon: SvgPicture.asset(
                    'images/Group 41.svg',
                    color: HexColor("#6092DC"),
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

Future<String> getConversationName(tabIndex, chat, userId) async {
  String chatName = '';

  var users = chat['users'];
  for (int i = 0; i < users.length; i++) {
    if (tabIndex == 0 && users[i]['id'] != userId) {
      chatName = users[i]['name'];
      continue;
    }
    chatName = users[i]['name'];
  }

  if (tabIndex == 0) {
    return chat['store']['name'];
  }

  return chatName;
}

Widget _buildCardZero(tabIndex, chat, context, userId) {
  String chatId = chat['id'];

  Future<SharedPreferences> getSharedPreferance() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    return await _prefs;
  }

  return FutureBuilder(
      future: getSharedPreferance(),
      builder: (context, prefs) {
        if (prefs.hasData) {
          String chatsRaw = prefs.data.getString('chatsMap') ?? '{}';
          Map mapLocal = json.decode(chatsRaw);
          String time = '';
          String message = '';
          String dateTimeRaw = '';
          bool isMyMessage = false;
          bool hasAvatar = false;

          var msgs = chat['chat_messages'];

          if (msgs != null &&
              msgs.length > 0 &&
              msgs[msgs.length - 1] != null) {
            if (msgs[msgs.length - 1]['createdAt'] != null) {
              dateTimeRaw = msgs[msgs.length - 1]['createdAt'];
            }
            var last = msgs[msgs.length - 1];

            if (last['messageType'] == 'order') {
              message = 'new order';
            } else {
              message = last['text'];
            }

            if (last['user'] != null && last['user']['id'] == userId) {
              isMyMessage = true;
            }
          }

          if (dateTimeRaw != null && dateTimeRaw != '') {
            DateTime dateTimeFormatted = DateTime.parse(dateTimeRaw);
            time = DateFormat.jm().format(dateTimeFormatted);
          }

          if (chat['store'] != null && chat['store']['thumbnail'] != null) {
            hasAvatar = true;
          } else {
            hasAvatar = false;
          }

          return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(.08),
                  blurRadius: 7.0,
                  spreadRadius: 0.0,
                  offset: Offset(1.0, 1.5),
                ),
              ],
            ),
            child: Card(
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (hasAvatar == true)
                    Container(
                      height: 77.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Positioned(
                            left: 16.0,
                            child: Stack(
                              fit: StackFit.loose,
                              children: [
                                FLAvatar(
                                  image: Image.network(
                                    AppConfig.instance.baseApiHost +
                                        chat['store']['thumbnail']['url'],
                                    fit: BoxFit.cover,
                                    height: double.infinity,
                                  ),
                                  width: 57,
                                  height: 57,
                                  color: HexColor("#CCD4FE"),
                                ),
                                mapLocal[chatId] != null &&
                                        mapLocal[chatId]['checked'] == false
                                    ? Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          width: 14.0,
                                          height: 14.0,
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      )
                                    : SizedBox.shrink(child: null),
                              ],
                            ),
                          ),
                          Positioned.fill(
                            top: 15.0,
                            left: 85.0,
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    child: Wrap(
                                      alignment: WrapAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          constraints:
                                              BoxConstraints(maxWidth: 180.0),
                                          child: FutureBuilder<String>(
                                            future: getConversationName(
                                                tabIndex, chat, userId),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<String>
                                                    snapshot) {
                                              if (snapshot.hasData) {
                                                return Text(
                                                  "${snapshot.data}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16.0,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: false,
                                                );
                                              }
                                              return SizedBox.shrink(
                                                  child: null);
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 16.0,
                                            top: 5.0,
                                          ),
                                          child: Text(
                                            time,
                                            style: TextStyle(fontSize: 12.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 7),
                                  Container(
                                    constraints:
                                        BoxConstraints(maxWidth: 242.0),
                                    child: RichText(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      softWrap: false,
                                      text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: [
                                          isMyMessage == false
                                              ? TextSpan()
                                              : TextSpan(
                                                  text: "You: ",
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                          TextSpan(
                                            text: message,
                                            style: TextStyle(fontSize: 14.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      height: 77.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Positioned(
                            left: 16.0,
                            child: Stack(
                              children: [
                                FLAvatar(
                                  image: Image.asset(
                                    'images/image-not-found.png',
                                    fit: BoxFit.cover,
                                    height: double.infinity,
                                  ),
                                  width: 57,
                                  height: 57,
                                  textStyle: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  color: HexColor("#CCD4FE"),
                                ),
                                mapLocal[chatId] != null &&
                                        mapLocal[chatId]['checked'] == false
                                    ? Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          width: 14.0,
                                          height: 14.0,
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      )
                                    : SizedBox.shrink(child: null),
                              ],
                            ),
                          ),
                          Positioned.fill(
                            top: 15.0,
                            left: 85.0,
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    child: Wrap(
                                      alignment: WrapAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          constraints:
                                              BoxConstraints(maxWidth: 180.0),
                                          child: FutureBuilder<String>(
                                            future: getConversationName(
                                                tabIndex, chat, userId),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<String>
                                                    snapshot) {
                                              if (snapshot.hasData) {
                                                return Text(
                                                  "${snapshot.data}",
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: false,
                                                );
                                              }
                                              return SizedBox.shrink(
                                                  child: null);
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 16.0,
                                            top: 5.0,
                                          ),
                                          child: Text(
                                            time,
                                            style: TextStyle(fontSize: 12.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 7),
                                  Container(
                                    constraints:
                                        BoxConstraints(maxWidth: 242.0),
                                    child: RichText(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      softWrap: false,
                                      text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: [
                                          isMyMessage == false
                                              ? TextSpan()
                                              : TextSpan(
                                                  text: "You: ",
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                          TextSpan(
                                            text: message,
                                            style: TextStyle(fontSize: 14.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        }
        return Container();
      });
}

Widget _buildCardOne(tabIndex, chat, context, userId) {
  String chatId = chat['id'];

  Future<SharedPreferences> getSharedPreferance() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    return await _prefs;
  }

  return FutureBuilder(
      future: getSharedPreferance(),
      builder: (context, prefs) {
        if (prefs.hasData) {
          String chatsRaw = prefs.data.getString('chatsMap') ?? '{}';
          Map mapLocal = json.decode(chatsRaw);
          String time = '';
          String message = '';
          String dateTimeRaw = '';
          bool isMyMessage = false;
          var notMe;
          bool notMeHasAvatar = false;

          var msgs = chat['chat_messages'];

          if (msgs != null &&
              msgs.length > 0 &&
              msgs[msgs.length - 1] != null) {
            if (msgs[msgs.length - 1]['createdAt'] != null) {
              dateTimeRaw = msgs[msgs.length - 1]['createdAt'];
            }
            var last = msgs[msgs.length - 1];

            if (last['messageType'] == 'order') {
              message = 'new order';
            } else {
              message = last['text'];
            }

            if (last['user'] != null && last['user']['id'] == userId) {
              isMyMessage = true;
            }
          }

          if (dateTimeRaw != null && dateTimeRaw != '') {
            DateTime dateTimeFormatted = DateTime.parse(dateTimeRaw);
            time = DateFormat.jm().format(dateTimeFormatted);
          }

          if (chat != null &&
              chat['users'] != null &&
              chat['users'].length > 0) {
            for (var i = 0; i < chat['users'].length; i++) {
              var user = chat['users'][i];

              if (user['avatar'] != null) {
                notMeHasAvatar = true;
              } else {
                notMeHasAvatar = false;
              }

              if (user['id'] != userId) {
                notMe = user;
              }
            }
          }

          return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(.08),
                  blurRadius: 7.0,
                  spreadRadius: 0.0,
                  offset: Offset(1.0, 1.5),
                ),
              ],
            ),
            child: Card(
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (notMe != null)
                    if (notMeHasAvatar == true)
                      Container(
                        height: 77.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Positioned(
                              left: 16.0,
                              child: Stack(
                                fit: StackFit.loose,
                                children: [
                                  FLAvatar(
                                    image: Image.network(
                                      AppConfig.instance.baseApiHost +
                                          notMe['avatar']['url'],
                                      fit: BoxFit.cover,
                                      height: double.infinity,
                                    ),
                                    width: 57,
                                    height: 57,
                                  ),
                                  mapLocal[chatId] != null &&
                                          mapLocal[chatId]['checked'] == false
                                      ? Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            width: 14.0,
                                            height: 14.0,
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        )
                                      : SizedBox.shrink(child: null),
                                ],
                              ),
                            ),
                            Positioned.fill(
                              top: 15.0,
                              left: 85.0,
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      child: Wrap(
                                        alignment: WrapAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            constraints:
                                                BoxConstraints(maxWidth: 180.0),
                                            child: FutureBuilder<String>(
                                              future: getConversationName(
                                                  tabIndex, chat, userId),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<String>
                                                      snapshot) {
                                                if (snapshot.hasData) {
                                                  return Text(
                                                    "${snapshot.data}",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16.0,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: false,
                                                  );
                                                }
                                                return SizedBox.shrink(
                                                    child: null);
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 16.0,
                                              top: 5.0,
                                            ),
                                            child: Text(
                                              time,
                                              style: TextStyle(fontSize: 12.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 7),
                                    Container(
                                      constraints:
                                          BoxConstraints(maxWidth: 242.0),
                                      child: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: false,
                                        text: TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: [
                                            isMyMessage == false
                                                ? TextSpan()
                                                : TextSpan(
                                                    text: "You: ",
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                            TextSpan(
                                              text: message,
                                              style: TextStyle(fontSize: 14.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        height: 77.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Positioned(
                              left: 16.0,
                              child: Stack(
                                children: [
                                  FLAvatar(
                                    text: notMe['name'][0],
                                    width: 57,
                                    height: 57,
                                    textStyle: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    color: HexColor("#CCD4FE"),
                                  ),
                                  mapLocal[chatId] != null &&
                                          mapLocal[chatId]['checked'] == false
                                      ? Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            width: 14.0,
                                            height: 14.0,
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        )
                                      : SizedBox.shrink(child: null),
                                ],
                              ),
                            ),
                            Positioned.fill(
                              top: 15.0,
                              left: 85.0,
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      child: Wrap(
                                        alignment: WrapAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            constraints:
                                                BoxConstraints(maxWidth: 180.0),
                                            child: FutureBuilder<String>(
                                              future: getConversationName(
                                                  tabIndex, chat, userId),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<String>
                                                      snapshot) {
                                                if (snapshot.hasData) {
                                                  return Text(
                                                    "${snapshot.data}",
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: false,
                                                  );
                                                }
                                                return SizedBox.shrink(
                                                    child: null);
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 16.0,
                                              top: 5.0,
                                            ),
                                            child: Text(
                                              time,
                                              style: TextStyle(fontSize: 12.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 7),
                                    Container(
                                      constraints:
                                          BoxConstraints(maxWidth: 242.0),
                                      child: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: false,
                                        text: TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: [
                                            isMyMessage == false
                                                ? TextSpan()
                                                : TextSpan(
                                                    text: "You: ",
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                            TextSpan(
                                              text: message,
                                              style: TextStyle(fontSize: 14.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                ],
              ),
            ),
          );
        }
        return Container();
      });
}

class ChatPageWidget extends StatefulWidget {
  @override
  _ChatPageWidgetState createState() => _ChatPageWidgetState();
}

class _ChatPageWidgetState extends State<ChatPageWidget> {
  String meId = GlobalStore.store.getState().user.id;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool shouldStopFetchingChats = false;

  void checking(chatId) async {
    final SharedPreferences prefs = await _prefs;
    String chatsRaw = prefs.getString('chatsMap') ?? '{}';
    Map chatsMapLocal = json.decode(chatsRaw);

    if (chatId != null &&
        chatsMapLocal["$chatId"] != null &&
        chatsMapLocal["$chatId"]['checked'] != null) {
      chatsMapLocal["$chatId"]['checked'] = true;
      prefs.setString('chatsMap', json.encode(chatsMapLocal));
      setState(() {});

      List<bool> allValues = [];
      chatsMapLocal.forEach((key, value) {
        allValues.add(value['checked']);
      });

      bool result = allValues.every((item) => item == true);
      if (result == true) {
        setState(() {
          shouldStopFetchingChats = false;
        });
      }
    }
  }

  Future processChat(dynamic chat) async {
    print('processChat');

    if (chat != null) {
      final SharedPreferences prefs = await _prefs;
      String chatsRaw = prefs.getString('chatsMap') ?? '{}';
      Map chatsMapLocal = json.decode(chatsRaw);

      if (chatsMapLocal["${chat['id']}"] != null &&
          chatsMapLocal["${chat['id']}"]['chatsAmount'] !=
              chat['chat_messages'].length &&
          chat['chat_messages'][chat['chat_messages'].length - 1]['user']
                  ['id'] !=
              meId) {
        chatsMapLocal["${chat['id']}"]['checked'] = false;
        prefs.setString('chatsMap', json.encode(chatsMapLocal));

        setState(() => shouldStopFetchingChats = true);
      }

      if (chat != null) {
        if (chatsMapLocal['${chat['id']}'] == null) {
          var obj = {
            'chatsAmount': chat['chat_messages'].length,
            'checked': false,
          };

          chatsMapLocal['${chat['id']}'] = obj;
          prefs.setString('chatsMap', json.encode(chatsMapLocal));
        } else {
          var obj = {
            'chatsAmount': chat['chat_messages'].length,
            'checked': chatsMapLocal['${chat['id']}']['checked'],
          };

          chatsMapLocal['${chat['id']}'] = obj;
          prefs.setString('chatsMap', json.encode(chatsMapLocal));
        }
      }
    }
  }

  Future fetchData() async {
    final chatsRequest = await BaseGraphQLClient.instance.fetchChats();
    if (chatsRequest.hasException) print(chatsRequest.exception);
    if (chatsRequest.data == null) return null;

    List chats = chatsRequest.data['chats'];
    List relevantChats = [];

    chats.forEach((chat) {
      chat['users'].forEach((user) {
        if (user['id'] == meId) {
          relevantChats.add(chat);
        }
      });
    });

    return relevantChats;
  }

  Stream fetchDataProcess() async* {
    if (!shouldStopFetchingChats)
      while (true) {
        yield await fetchData();
        await Future<void>.delayed(Duration(seconds: 60));
      }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        StreamBuilder(
          stream: fetchDataProcess(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Expanded(
                  child: ListView(
                children: snapshot.data == null
                    ? []
                    : snapshot.data.map<Widget>((chat) {
                        processChat(chat);
                        return InkWell(
                          child: _buildCardZero(0, chat, context, meId),
                          onTap: () async {
                            checking(chat['id']);
                            Navigator.of(context).pushNamed(
                              'chatmessagespage',
                              arguments: {
                                'chatId': chat['id'],
                                'userId': meId,
                                'conversationName': await getConversationName(
                                  0,
                                  chat,
                                  meId,
                                )
                              },
                            );
                          },
                        );
                      }).toList(),
              ));
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
                    ),
                  )
                ],
              );
            }
          },
        )
      ],
    );
  }
}

class StorePageWidget extends StatefulWidget {
  @override
  _StorePageWidgetState createState() => _StorePageWidgetState();
}

class _StorePageWidgetState extends State<StorePageWidget> {
  String meId = GlobalStore.store.getState().user.id;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool shouldStopFetchingChats = false;

  void checking(chatId) async {
    final SharedPreferences prefs = await _prefs;
    String chatsRaw = prefs.getString('chatsMap') ?? '{}';
    Map chatsMapLocal = json.decode(chatsRaw);

    if (chatId != null &&
        chatsMapLocal["$chatId"] != null &&
        chatsMapLocal["$chatId"]['checked'] != null) {
      chatsMapLocal["$chatId"]['checked'] = true;
      prefs.setString('chatsMap', json.encode(chatsMapLocal));
      setState(() {});

      List<bool> allValues = [];
      chatsMapLocal.forEach((key, value) {
        allValues.add(value['checked']);
      });

      bool result = allValues.every((item) => item == true);
      if (result == true) {
        setState(() {
          shouldStopFetchingChats = false;
        });
      }
    }
  }

  Future processChat(dynamic chat) async {
    print('processChat');

    if (chat != null) {
      final SharedPreferences prefs = await _prefs;
      String chatsRaw = prefs.getString('chatsMap') ?? '{}';
      Map chatsMapLocal = json.decode(chatsRaw);
      var msgs = chat['chat_messages'];
      var cmlId = chatsMapLocal["${chat['id']}"];

      if (cmlId != null && cmlId['chatsAmount'] != msgs.length) {
        if (msgs[msgs.length - 1]['user'] != null) {
          if (msgs[msgs.length - 1]['user']['id'] != meId) {
            cmlId['checked'] = false;
            prefs.setString('chatsMap', json.encode(chatsMapLocal));
          }
        } else {
          cmlId['checked'] = false;
          prefs.setString('chatsMap', json.encode(chatsMapLocal));
        }

        setState(() => shouldStopFetchingChats = true);
      }

      if (chatsMapLocal["${chat['id']}"] == null) {
        var obj = {
          'chatsAmount': msgs.length,
          'checked': false,
        };

        chatsMapLocal["${chat['id']}"] = obj;
        prefs.setString('chatsMap', json.encode(chatsMapLocal));
      } else {
        var obj = {
          'chatsAmount': msgs.length,
          'checked': chatsMapLocal["${chat['id']}"]['checked'],
        };

        chatsMapLocal["${chat['id']}"] = obj;
        prefs.setString('chatsMap', json.encode(chatsMapLocal));
      }
    }
  }

  Future fetchData() async {
    final storeRequest = await BaseGraphQLClient.instance
        .fetchStoreById(GlobalStore.store.getState().user.store['id']);
    var store = storeRequest.data['stores'][0];

    return store['chats'];
  }

  Stream fetchDataProcess() async* {
    if (!shouldStopFetchingChats)
      while (true) {
        yield await fetchData();
        await Future<void>.delayed(Duration(seconds: 60));
      }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        StreamBuilder(
          stream: fetchDataProcess(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData && !snapshot.hasError) {
              return Expanded(
                  child: ListView(
                children: snapshot.data.map<Widget>((chat) {
                  processChat(chat);
                  return InkWell(
                    child: _buildCardOne(1, chat, context, meId),
                    onTap: () async {
                      checking(chat['id']);
                      Navigator.of(context).pushNamed(
                        'chatmessagespage',
                        arguments: {
                          'chatId': chat['id'],
                          'userId': meId,
                          'conversationName':
                              await getConversationName(1, chat, meId)
                        },
                      );
                    },
                  );
                }).toList(),
              ));
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
                    ),
                  )
                ],
              );
            }
          },
        )
      ],
    );
  }
}

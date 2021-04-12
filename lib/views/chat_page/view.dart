import 'package:com.floridainc.dosparkles/models/cart_item_model.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:com.floridainc.dosparkles/views/chat_page/action.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/actions/api/graphql_client.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'dart:convert';
import 'state.dart';

Widget buildView(
    ChatPageState state, Dispatch dispatch, ViewService viewService) {
  final pages = [
    _FirstPage(
      continueTapped: () => dispatch(ChatPageActionCreator.onStart()),
      shoppingCart: state.shoppingCart,
    ),
  ];

  Widget _buildPage(Widget page) {
    // return keepAliveWrapper(page);
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

  List<Widget> _widgetOptions = <Widget>[
    ChatPageWidget(),
    StorePageWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.store),
              label: 'Store',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: HexColor("#182465"),
          onTap: _onItemTapped,
        ));
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: _widgetOptions.elementAt(_selectedIndex),
  //     bottomNavigationBar:
  //         GlobalStore.store.getState().user.role == "Store Manager"
  //             ? BottomNavigationBar(
  //                 items: const <BottomNavigationBarItem>[
  //                   BottomNavigationBarItem(
  //                     icon: Icon(Icons.chat),
  //                     label: 'Chat',
  //                   ),
  //                   BottomNavigationBarItem(
  //                     icon: Icon(Icons.store),
  //                     label: 'Store',
  //                   ),
  //                 ],
  //                 currentIndex: _selectedIndex,
  //                 selectedItemColor: HexColor("#182465"),
  //                 onTap: _onItemTapped,
  //               )
  //             : null,
  //   );
  // }
}

Future<String> getConversationName(tabIndex, chat, userId) async {
  List chatNames = [];

  var users = chat['users'];
  for (int i = 0; i < users.length; i++) {
    if (users[i]['id'] != userId) {
      chatNames.add('${users[i]['name']}');
    }
  }

  if (tabIndex == 0) {
    return chat['store'] == null ? chatNames.join(', ') : chat['store']['name'];
  }
  return chatNames.join(', ');
}

Widget _buildCard(tabIndex, item, context, String chatId, userId) {
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
          return SizedBox(
            height: 100,
            child: Card(
              child: InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(
                      title: FutureBuilder<String>(
                        future: getConversationName(tabIndex, item, userId),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.hasData) {
                            return Text("${snapshot.data}");
                          }
                          return SizedBox.shrink(child: null);
                        },
                      ),
                      leading: Icon(
                        Icons.chat,
                        color: HexColor("#182465"),
                      ),
                      trailing: mapLocal[chatId] != null &&
                              mapLocal[chatId]['checked'] == false
                          ? Icon(Icons.mark_as_unread)
                          : null,
                    ),
                  ],
                ),
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
                          child: _buildCard(
                            0,
                            chat,
                            context,
                            chat['id'],
                            meId,
                          ),
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
  String meId;
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
  void initState() {
    super.initState();

    BaseGraphQLClient.instance.me().then((result) {
      meId = result.data['me']['id'];
    });
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
                    child: _buildCard(
                      1,
                      chat,
                      context,
                      chat['id'],
                      meId,
                    ),
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
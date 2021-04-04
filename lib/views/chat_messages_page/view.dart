import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:com.floridainc.dosparkles/actions/api/graphql_client.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flui/flui.dart';

import 'dart:async';
import 'state.dart';

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

Future fetchData(String chatId) async {
  QueryResult chat = await BaseGraphQLClient.instance.fetchChat(chatId);
  // print("____DATA_____${chat.data['chats'][0]}");
  return chat.data['chats'][0];
}

Stream fetchDataProcess(String chatId) async* {
  while (true) {
    yield await fetchData(chatId);
    await Future<void>.delayed(Duration(seconds: 30));
  }
}

class _BubblePageState extends State<BubblePage> {
  var formatter = new DateFormat.yMMMMd().add_jm();
  String inputData = "";
  var _controller = TextEditingController();

  String getUserLetter(item) {
    // printWrapped(item.toString());
    // print('getUserLetter');
    // print(userId['id'].toString());
    // print(allUsers.toString());
    // for (int i = 0; i < allUsers.length; i++) {
    //   if (allUsers[i]['id'] == userId['id']) {
    //     return allUsers[i]['firstName'].toString()[0] +
    //         allUsers[i]['lastName'].toString()[0];
    //   }
    // }
    return item['name'].toString()[0];
  }

  Widget _buildBubbleContent(double maxWidth, context) {
    Widget insetV = SizedBox(height: 20);
    Widget insetVSmall = SizedBox(height: 10);
    Widget insetH = SizedBox(width: 4);
    double tWidth = maxWidth - 160;
    final TextStyle textStyle = TextStyle(fontSize: 15);

    return Container(
      padding: EdgeInsets.all(20),
      child: StreamBuilder(
          stream: fetchDataProcess(widget.chatId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData && !snapshot.hasError) {
              return snapshot.data['chat_messages'] == null
                  ? Text('No Data', textAlign: TextAlign.center)
                  : Column(
                      children: snapshot.data['chat_messages']
                          .map<Widget>(
                            (item) =>
                                //
                                widget.userId == item['user']['id']
                                    ? Column(children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end, //
                                          children: <Widget>[
                                            insetH,
                                            FLBubble(
                                                from: FLBubbleFrom.right, //
                                                backgroundColor: Colors.white,
                                                child: Container(
                                                  width: tWidth,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 8),
                                                  child: Text('${item['text']}',
                                                      style: textStyle,
                                                      softWrap: true),
                                                )),
                                            _buildRoundedAvatar(getUserLetter(
                                              item['user'],
                                              // snapshot.data['users']
                                            )),
                                          ],
                                        ),
                                        insetVSmall,
                                        Text(
                                          '${formatter.format(DateTime.parse(item['createdAt']))}',
                                        ),
                                        insetV,
                                      ])
                                    : Column(children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            _buildRoundedAvatar(getUserLetter(
                                              item['user'],
                                              // snapshot.data['users']
                                            )),
                                            insetH,
                                            FLBubble(
                                                from: FLBubbleFrom.left,
                                                backgroundColor: Colors.white,
                                                child: Container(
                                                  width: tWidth,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 8),
                                                  child: Text('${item['text']}',
                                                      style: textStyle,
                                                      softWrap: true),
                                                )),
                                          ],
                                        ),
                                        insetVSmall,
                                        Text(
                                            '${formatter.format(DateTime.parse(item['createdAt']))}'),
                                        insetV,
                                      ]),
                          )
                          .toList(),
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
                  ]);
            }
          }),
    );
  }

  Widget _buildRoundedAvatar(String alpha) {
    return FLAvatar(
      text: alpha,
      textStyle: TextStyle(color: Colors.white, fontSize: 18),
      width: 50,
      height: 50,
      color: HexColor("#182465"),
    );
  }

  getConversationName(conversation, userId) {
    var chatNames = [];
    var users = conversation['users'];
    for (int i = 0; i < users.length; i++) {
      if (users[i]['id'] != userId) {
        chatNames.add('${users[i]['name']}');
      }
    }
    return chatNames.join(', ');
  }

  addMessage(text, chatId, userId) async {
    await BaseGraphQLClient.instance
        .addMessage({'text': text, 'chat': chatId, 'user': userId});

    // await StrapiSDK.instance.strapiClient.create(
    //   StrapiSDK.instance.messageType(
    //     {'text': text, 'chat': chatId, 'user': userId},
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);
    final double width = queryData.size.width;

    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.conversationName}'),
          backgroundColor: HexColor("#182465"),
        ),
        body: Container(
          color: Color(0xFFDEEEEEE),
          width: double.infinity,
          height: queryData.size.height, //double.infinity,
          child: ListView(
            // Start scrolled to the bottom by default and stay there.
            reverse: true,
            shrinkWrap: true,
            children: <Widget>[
              _buildBubbleContent(width, context),
            ],
          ),
        ),
        bottomNavigationBar: Container(
            height: 80,
            color: HexColor("#182465"),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: TextField(
                        controller: _controller,
                        onChanged: (text) {
                          this.inputData = text;
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Enter message',
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
                      width: MediaQuery.of(context).size.width * 0.5,
                    ),
                    Container(
                        width: 60,
                        height: 40,
                        child: InkWell(
                          onTap: () {
                            if (this.inputData != "") {
                              addMessage(
                                  this.inputData, widget.chatId, widget.userId);
                              this.inputData = "";
                              _controller.clear();
                            }
                          },
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ))
                  ],
                ),
              ],
            )));
  }
}

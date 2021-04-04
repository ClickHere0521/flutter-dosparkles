import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

class ChatMessagesPageState implements Cloneable<ChatMessagesPageState> {
  PageController pageController;
  bool isFirstTime;
  String chatId;
  String userId;
  String conversationName;

  @override
  ChatMessagesPageState clone() {
    return ChatMessagesPageState()
      ..pageController = pageController
      ..isFirstTime = isFirstTime;
  }
}

ChatMessagesPageState initState(Map<String, dynamic> args) {
  ChatMessagesPageState state = ChatMessagesPageState();
  state.chatId = args['chatId'];
  state.userId = args['userId'];
  state.conversationName = args['conversationName'];

  return state;
}

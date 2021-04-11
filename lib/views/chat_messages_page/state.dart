import 'package:com.floridainc.dosparkles/models/app_user.dart';
import 'package:com.floridainc.dosparkles/models/models.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

class ChatMessagesPageState implements Cloneable<ChatMessagesPageState> {
  PageController pageController;
  bool isFirstTime;
  List<CartItem> cartItem;
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
  state.cartItem = args['cartItem'];
  state.chatId = args['chatId'];
  state.userId = args['userId'];
  state.conversationName = args['conversationName'];

  return state;
}

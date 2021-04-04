import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

class ChatPageState implements Cloneable<ChatPageState> {
  PageController pageController;
  bool isFirstTime;
  @override
  ChatPageState clone() {
    return ChatPageState()
      ..pageController = pageController
      ..isFirstTime = isFirstTime;
  }
}

ChatPageState initState(Map<String, dynamic> args) {
  return ChatPageState();
}

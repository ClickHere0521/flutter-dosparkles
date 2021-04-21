import 'package:fish_redux/fish_redux.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/state.dart';
import 'package:flutter/material.dart';

import '../../models/models.dart';

class AuthorizationPageState
    implements GlobalBaseState, Cloneable<AuthorizationPageState> {
  @override
  AuthorizationPageState clone() {
    return AuthorizationPageState();
  }

  @override
  Locale locale;

  @override
  AppUser user;

  @override
  List<StoreItem> storesList;

  @override
  StoreItem selectedStore;

  @override
  ProductItem selectedProduct;

  @override
  List<CartItem> shoppingCart;
}

AuthorizationPageState initState(Map<String, dynamic> args) {
  return AuthorizationPageState();
}

import 'dart:ui';

import 'package:fish_redux/fish_redux.dart';
import 'package:com.floridainc.dosparkles/models/models.dart';

enum GlobalAction {
  changeLocale,
  setUser,
  setStoresList,
  setSelectedStore,
  setSelectedProduct,
  setShoppingCart,
  addProductToShoppingCart
}

class GlobalActionCreator {
  static Action changeLocale(Locale l) {
    return Action(GlobalAction.changeLocale, payload: l);
  }

  static Action setUser(AppUser user) {
    return Action(GlobalAction.setUser, payload: user);
  }

  static Action setStoresList(List<StoreItem> storesList) {
    return Action(GlobalAction.setStoresList, payload: storesList);
  }

  static Action setSelectedStore(StoreItem store) {
    return Action(GlobalAction.setSelectedStore, payload: store);
  }

  static Action setSelectedProduct(ProductItem product) {
    return Action(GlobalAction.setSelectedProduct, payload: product);
  }

  static Action setShoppingCart(List<CartItem> cart) {
    return Action(GlobalAction.setShoppingCart, payload: cart);
  }

  static Action addProductToShoppingCart(
      ProductItem product,
      int count,
      double amount,
      List<String> engraveInputs,
      bool optionalMaterialSelected,
      ordersImages) {
    return Action(GlobalAction.addProductToShoppingCart, payload: [
      product,
      count,
      amount,
      engraveInputs,
      optionalMaterialSelected,
      ordersImages
    ]);
  }
}

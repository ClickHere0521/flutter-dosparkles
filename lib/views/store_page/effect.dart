import 'package:com.floridainc.dosparkles/models/models.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/widgets.dart' hide Action;

import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/action.dart';

import 'action.dart';
import 'state.dart';

Effect<StorePageState> buildEffect() {
  return combineEffects(<Object, Effect<StorePageState>>{
    StorePageAction.action: _onAction,
    StorePageAction.goToProductPage: onGoToProductPage,
    Lifecycle.initState: _onInit,
    Lifecycle.build: _onBuild,
    Lifecycle.dispose: _onDispose
  });
}

void _onInit(Action action, Context<StorePageState> ctx) async {
  final Object ticker = ctx.stfState;
  ctx.state.animationController = AnimationController(
      vsync: ticker, duration: Duration(milliseconds: 2000));

  ctx.state.user = GlobalStore.store.getState().user;
  ctx.state.locale = GlobalStore.store.getState().locale;
  ctx.state.storesList = GlobalStore.store.getState().storesList;
  ctx.state.selectedProduct = GlobalStore.store.getState().selectedProduct;
  ctx.state.selectedStore = GlobalStore.store.getState().selectedStore;
  ctx.state.shoppingCart = GlobalStore.store.getState().shoppingCart;

  if (ctx.state.productIndex == null) {
    if (ctx.state.selectedStore != null && ctx.state.selectedProduct != null) {
      for (var i = 0; i < ctx.state.selectedStore.products.length; i++) {
        if (ctx.state.selectedStore.products[i].id ==
            ctx.state.selectedProduct.id) {
          ctx.state.productIndex = i;
          break;
        }
      }
    } else {
      ctx.state.listView = true;
    }
  }
}

void _onBuild(Action action, Context<StorePageState> ctx) {
  if (ctx.state.animationController != null) {
    Future.delayed(Duration(milliseconds: 150),
        () => ctx.state.animationController.forward());
  }
}

void _onDispose(Action action, Context<StorePageState> ctx) {
  ctx.state.animationController.dispose();
}

void _onAction(Action action, Context<StorePageState> ctx) {}

void onGoToProductPage(Action action, Context<StorePageState> ctx) async {
  ProductItem product = action.payload;

  GlobalStore.store.dispatch(GlobalActionCreator.setSelectedProduct(product));

  await Navigator.of(ctx.context).pushReplacementNamed('productpage');
}

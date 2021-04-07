import 'dart:convert' show json;
import 'package:com.floridainc.dosparkles/actions/app_config.dart';
import 'package:com.floridainc.dosparkles/models/product_item.dart';
import 'package:flutter/material.dart';
import 'package:com.floridainc.dosparkles/utils/general.dart';

class CartItem {
  ProductItem product;
  int count;
  List<String> engraveInputs;
  double amount;
  bool optionalMaterialSelected;
  List orderImageData;

  CartItem.fromParams({
    this.product,
    this.count,
    this.engraveInputs,
    this.amount,
    this.optionalMaterialSelected,
    this.orderImageData,
  });

  @override
  String toString() {
    return '${product.toString()} count: $count amount: $amount engraveInputs: $engraveInputs';
  }
}

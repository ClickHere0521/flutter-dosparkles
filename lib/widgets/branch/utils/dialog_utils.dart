import 'package:flutter/material.dart';
import 'package:com.floridainc.dosparkles/widgets/branch/utils/console_utils.dart';
import 'package:toast/toast.dart';

class ToastUtils {
  //To Display Toast
  static displayToast(String message, BuildContext context) {
    return Toast.show(
      message,
      context,
      duration: 3,
      gravity: Toast.BOTTOM,
    );
  }
}

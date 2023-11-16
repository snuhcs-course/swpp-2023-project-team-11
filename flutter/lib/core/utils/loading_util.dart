import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingUtil {
  static Future<T> withLoadingOverlay<T>({
    required Future<T> Function() asyncFunction,
    Widget loadingWidget = const CupertinoActivityIndicator(),
  }) async {
    return await Get.showOverlay(
      asyncFunction: asyncFunction,
      opacity: 0,
      opacityColor: Colors.transparent,
      loadingWidget: Center(
        child: Material(
          color: Colors.black12,
          child: Center(child: loadingWidget),
        ),
      ),
    );
  }
}
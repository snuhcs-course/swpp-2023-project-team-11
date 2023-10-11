import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

class EntryScreenController extends GetxController{
  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(const Duration(milliseconds: 200));
    FlutterNativeSplash.remove();
  }
}
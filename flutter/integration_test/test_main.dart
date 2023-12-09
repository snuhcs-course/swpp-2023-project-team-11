import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:mobile_app/dependency_manager.dart';
import 'package:mobile_app/main.dart' as app;
import 'package:mobile_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> mainForTest(DependencyManager dependencyManager, WidgetsBinding widgetsBinding) async {
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  sp = await SharedPreferences.getInstance();
  Get.put<DependencyManager>(dependencyManager);
  runApp(const MyApp());
}
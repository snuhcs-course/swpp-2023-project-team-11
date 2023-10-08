import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/routes/get_pages.dart';

import 'routes/named_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 알다시피, Get을 사용하려면 MaterialApp을 GetMaterialApp으로 바꿔줘야 함
    return GetMaterialApp(
      title: 'Flutter Demo',
      // maetrial 3 디자인 적용으로, seed color만 주면 알아서 이쁘게 됨
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // 여기가 핵심, Get을 활용하여 라우팅을 어떻게 관리하는가에 대한
      initialRoute: Routes.FIRST,
      getPages: GetPages.pages,
    );
  }
}
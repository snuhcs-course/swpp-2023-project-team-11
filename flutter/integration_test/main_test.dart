import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/app/domain/service_interfaces/auth_service.dart';
import 'package:mobile_app/app/presentation/widgets/chat_messages.dart';
import 'package:mobile_app/core/constants/environment.dart';
import 'package:mobile_app/dependency_manager.dart';
import 'package:mobile_app/main.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateNiceMocks([MockSpec<AuthService>()])
import "main_test.mocks.dart";
import 'test_main.dart';

// 여기서 선택할 수 있습니다.
// false를 변수에 입력하면 서버에서 테스트가 가능합니다.
// 로컬에서 테스트하려면 fast api 폴더의 readme 및 ops 폴더 하위의 deploy.sh 스크립트를 참고하세요
bool testInLocal = true;

void main() async {
  // needs to change base url to local host or not
  String validEmail = "test1@snu.ac.kr";
  String validPwd = "password";

  if(testInLocal) {
    Environment.setTestMode();
    validEmail = "integration1@snu.ac.kr";
    validPwd = "password";
  }


  final widgetsBinding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  //auth service mocking
  final authService = MockAuthService();
  when(authService.getSessionKey).thenAnswer((_) async => null);

  group("main flow", ()  {
    testWidgets("main flow impl", (tester) async {
      // load app widget
      // inject mocking auth service
      await mainForTest(DependencyManager.basic().copyWith(authService: authService), widgetsBinding);
      await tester.pumpAndSettle();
      // find login and sign up buttons
      final loginButton = find.text("로그인");
      expect(find.text('로그인'), findsOneWidget);
      expect(find.text('회원가입'), findsOneWidget);
      _testDescription("로그인 및 회원가입 위젯 존재 확인");

      // try sign in by pre generated data


      // open login bottom sheet
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // enter login inform;
      final emailForm = find.byKey(const Key("emailForm"));
      final pwdForm = find.byKey(
        const Key("passwordForm"),
      );
      await tester.tap(emailForm);
      await tester.enterText(emailForm, validEmail);
      await tester.pump(const Duration(milliseconds: 1000));
      await tester.enterText(pwdForm, validPwd);
      await tester.pump(const Duration(milliseconds: 1000));

      // then finalize login
      await tester.tap(find.byKey(const Key("finalLogin")));
      await tester.pumpAndSettle();


      // check now route is main
      expect(Get.currentRoute, "/main");

      _testDescription("로그인 및 메인 진입");

      await tester.pump(const Duration(milliseconds: 1000));
      // move into second tap (chatting room list)
      await tester.tap(find.byKey(ValueKey(1)));
      await tester.pumpAndSettle();
      final validRoomFind = find.byKey( const ValueKey("validRoom"));

      // check there is at least 1 valid room
      expect(validRoomFind, findsAtLeast(1));
      _testDescription("유효한 채팅방 존재 확인");

      // if valid rooms exist
      if (validRoomFind.found.isNotEmpty){
        final targetFind = validRoomFind.first;
        // tap valid room container
        await tester.tap(targetFind,warnIfMissed: false);
        await tester.pumpAndSettle();
        await tester.pump(const Duration(milliseconds: 1200));

        // check route is main/room
        expect(Get.currentRoute, "/main/room");
        _testDescription("유효한 채팅방 진입");
        final listFinder = find.byType(Scrollable).last;
        await tester.drag(listFinder, Offset(0, -200));
        await tester.pump(const Duration(milliseconds: 500));

        // go to roadmap screen (topic suggestion)
        await tester.tap(find.byKey(const ValueKey("roadMap")));
        await tester.pumpAndSettle(const Duration(milliseconds: 800));

        // check route is main/room/roadmap
        expect(Get.currentRoute, "/main/room/roadmap");
        _testDescription("로드맵 (추천 받기) 스크린 진입");
        // select topic
        final targetTopic = find.byKey(ValueKey(0));
        await tester.tap(targetTopic);
        await tester.pumpAndSettle(const Duration(milliseconds: 800));
        _testDescription("주제 선택");

        // check topic widget exists
        expect(targetTopic, findsOneWidget);
        final descendantText = find.descendant(of: targetTopic, matching: find.byType(Text));
        expect(descendantText, findsOneWidget);

        final targetTextWidget = descendantText.evaluate().first.widget as Text;

        // store selected topic's internal data for post test
        final targetTextData = targetTextWidget.data;
        expect(targetTextData, isNotNull);
        final realTargetTextData = targetTextData!.split(": ").last;

        // submit selected topic by tapping button

        await tester.tap(find.text("선택 완료"));

        await tester.pumpAndSettle();
        // wait
        await tester.pump(const Duration(milliseconds: 1500));
        _testDescription("주제 선택 및 제출");

        // find submitted topic
        final targetRoadmapTextWidgetFind = find.descendant(of: find.byType(ChatMessage), matching: find.byWidgetPredicate((widget) {
          if (widget.key == ValueKey("topic")) {
            final stringInWidget = (widget as Text).data!;
            return _cleansingString(stringInWidget)==_cleansingString(realTargetTextData);
          }
          return false;
        }));
        await tester.scrollUntilVisible(targetRoadmapTextWidgetFind, 100,scrollable: listFinder);
        // check submitted topic exists in chatting room
        expect(targetRoadmapTextWidgetFind, findsAtLeast(1));
        _testDescription("선택한 주제 채팅방 도착");
        await tester.pump(const Duration(milliseconds: 1000));

        // page back to main
        await tester.pageBack();
        await tester.pumpAndSettle();
        // check here is main
        expect(Get.currentRoute, '/main');
        _testDescription("메인 재진입");
      } else {
        print("no find valid rooms - skip roadmap checking");
      }
      // 탭 이동 - 프로필
      await tester.tap(find.byKey(ValueKey(2)));
      await tester.pumpAndSettle(const Duration(milliseconds: 800));

      await tester.scrollUntilVisible(find.text("로그아웃"), 800);
      await tester.tap(find.text("로그아웃"));
      await tester.pumpAndSettle(const Duration(milliseconds: 800));

      // 로그아웃 완료
      expect(Get.currentRoute, "/entry");
      _testDescription("로그아웃 완료");
      await tester.pump(const Duration(milliseconds: 1000));

    });
  });
}

String _cleansingString(String value) {
  final uniCodes = value.runes.toList();
  uniCodes.removeWhere((element) => element==8205);
  return String.fromCharCodes(uniCodes);
}

void _testDescription(String value) {
  print("---------------------");
  print("test sucess : $value");
  print("---------------------");
}

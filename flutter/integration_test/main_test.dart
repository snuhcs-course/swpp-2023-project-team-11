import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/app/domain/service_interfaces/auth_service.dart';
import 'package:mobile_app/app/presentation/widgets/chat_messages.dart';
import 'package:mobile_app/dependency_manager.dart';
import 'package:mobile_app/main.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateNiceMocks([MockSpec<AuthService>()])
import "main_test.mocks.dart";
import 'test_main.dart';

void main() async {
  final widgetsBinding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

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

      // try sign in by pre generated data
      const validEmail = "jun7332568@snu.ac.kr";
      const validPwd = "test1234";

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
      await tester.pump(const Duration(milliseconds: 1000));
      // move into second tap (chatting room list)
      await tester.tap(find.byKey(ValueKey(1)));
      await tester.pumpAndSettle();
      final validRoomFind = find.byKey( const ValueKey("validRoom"));

      // check there is at least 1 valid room
      expect(validRoomFind, findsAtLeast(1));

      // if valid rooms exist
      if (validRoomFind.found.isNotEmpty){
        final targetFind = validRoomFind.first;
        // tap valid room container
        await tester.tap(targetFind);
        await tester.pumpAndSettle();
        await tester.pump(const Duration(milliseconds: 1200));

        // check route is main/room
        expect(Get.currentRoute, "/main/room");
        final listFinder = find.byType(Scrollable).last;
        await tester.drag(listFinder, Offset(0, -200));
        await tester.pump(const Duration(milliseconds: 500));

        // go to roadmap screen (topic suggestion)
        await tester.tap(find.byKey(const ValueKey("roadMap")));
        await tester.pumpAndSettle(const Duration(milliseconds: 800));

        // check route is main/room/roadmap
        expect(Get.currentRoute, "/main/room/roadmap");
        // select topic
        final targetTopic = find.byKey(ValueKey(0));
        await tester.tap(targetTopic);
        await tester.pumpAndSettle(const Duration(milliseconds: 800));

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
        await tester.pump(const Duration(milliseconds: 1000));

        // page back to main
        await tester.pageBack();
        await tester.pumpAndSettle();
        // check here is main
        expect(Get.currentRoute, '/main');
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
      await tester.pump(const Duration(milliseconds: 1000));

    });
  });
}

String _cleansingString(String value) {
  final uniCodes = value.runes.toList();
  uniCodes.removeWhere((element) => element==8205);
  return String.fromCharCodes(uniCodes);
}

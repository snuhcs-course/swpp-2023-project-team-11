import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/app/domain/service_interfaces/auth_service.dart';
import 'package:mobile_app/dependency_manager.dart';
import 'package:mobile_app/main.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateNiceMocks([MockSpec<AuthService>()])
import "sign_in_flow_test.mocks.dart";
import 'test_main.dart';

void main() async {
  final widgetsBinding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final authService = MockAuthService();
  when(authService.getSessionKey).thenAnswer((_) async => null);

  group("auth flow", ()  {
    testWidgets("sign in and out flow", (tester) async {
      // load app widget
      await mainForTest(DependencyManager.basic().copyWith(authService: authService), widgetsBinding);
      await tester.pumpAndSettle();
      // find buttons
      final loginButton = find.text("로그인");
      expect(find.text('로그인'), findsOneWidget);
      expect(find.text('회원가입'), findsOneWidget);

      // try sign in
      const validEmail = "jun7332568@snu.ac.kr";
      const validPwd = "test1234";

      await tester.tap(loginButton);
      await tester.pumpAndSettle(const Duration(milliseconds: 1500));

      final emailForm = find.byKey(const Key("emailForm"));
      final pwdForm = find.byKey(
        const Key("passwordForm"),
      );
      await tester.tap(emailForm);
      await tester.enterText(emailForm, validEmail);
      await tester.pump(const Duration(milliseconds: 1000));

      await tester.enterText(pwdForm, validPwd);
      await tester.pump(const Duration(milliseconds: 1000));
      await tester.tap(find.byKey(const Key("finalLogin")));
      await tester.pumpAndSettle();
      expect(Get.currentRoute, "/main");
      await tester.pump(const Duration(milliseconds: 1000));

      // 탭 이동
      await tester.tap(find.byKey(ValueKey(2)));
      await tester.pumpAndSettle(const Duration(milliseconds: 800));

      await tester.scrollUntilVisible(find.text("로그아웃"), 100);
      await tester.tap(find.text("로그아웃"));
      await tester.pumpAndSettle(const Duration(milliseconds: 800));

      // 로그아웃 완료
      expect(Get.currentRoute, "/entry");
      await tester.pump(const Duration(milliseconds: 1000));
    });
  });
}

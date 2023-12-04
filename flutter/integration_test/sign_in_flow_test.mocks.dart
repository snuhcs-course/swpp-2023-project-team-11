// Mocks generated by Mockito 5.4.2 from annotations
// in mobile_app/test/integration_tests/sign_in_flow_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mobile_app/app/domain/models/user.dart' as _i6;
import 'package:mobile_app/app/domain/result.dart' as _i4;
import 'package:mobile_app/app/domain/service_interfaces/auth_service.dart'
    as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i5;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [AuthService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthService extends _i1.Mock implements _i2.AuthService {
  @override
  _i3.Future<String?> get getSessionKey => (super.noSuchMethod(
        Invocation.getter(#getSessionKey),
        returnValue: _i3.Future<String?>.value(),
        returnValueForMissingStub: _i3.Future<String?>.value(),
      ) as _i3.Future<String?>);

  @override
  _i3.Future<_i4.Result<_i2.AccessResult, _i4.DefaultIssue>> signIn({
    required String? email,
    required String? password,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #signIn,
          [],
          {
            #email: email,
            #password: password,
          },
        ),
        returnValue:
            _i3.Future<_i4.Result<_i2.AccessResult, _i4.DefaultIssue>>.value(
                _i5.dummyValue<_i4.Result<_i2.AccessResult, _i4.DefaultIssue>>(
          this,
          Invocation.method(
            #signIn,
            [],
            {
              #email: email,
              #password: password,
            },
          ),
        )),
        returnValueForMissingStub:
            _i3.Future<_i4.Result<_i2.AccessResult, _i4.DefaultIssue>>.value(
                _i5.dummyValue<_i4.Result<_i2.AccessResult, _i4.DefaultIssue>>(
          this,
          Invocation.method(
            #signIn,
            [],
            {
              #email: email,
              #password: password,
            },
          ),
        )),
      ) as _i3.Future<_i4.Result<_i2.AccessResult, _i4.DefaultIssue>>);

  @override
  _i3.Future<_i4.Result<_i2.AccessResult, _i4.DefaultIssue>> signUp({
    required String? email,
    required String? password,
    required _i6.User? user,
    required String? emailToken,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #signUp,
          [],
          {
            #email: email,
            #password: password,
            #user: user,
            #emailToken: emailToken,
          },
        ),
        returnValue:
            _i3.Future<_i4.Result<_i2.AccessResult, _i4.DefaultIssue>>.value(
                _i5.dummyValue<_i4.Result<_i2.AccessResult, _i4.DefaultIssue>>(
          this,
          Invocation.method(
            #signUp,
            [],
            {
              #email: email,
              #password: password,
              #user: user,
              #emailToken: emailToken,
            },
          ),
        )),
        returnValueForMissingStub:
            _i3.Future<_i4.Result<_i2.AccessResult, _i4.DefaultIssue>>.value(
                _i5.dummyValue<_i4.Result<_i2.AccessResult, _i4.DefaultIssue>>(
          this,
          Invocation.method(
            #signUp,
            [],
            {
              #email: email,
              #password: password,
              #user: user,
              #emailToken: emailToken,
            },
          ),
        )),
      ) as _i3.Future<_i4.Result<_i2.AccessResult, _i4.DefaultIssue>>);

  @override
  _i3.Future<void> expireSession() => (super.noSuchMethod(
        Invocation.method(
          #expireSession,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> setUnauthorized() => (super.noSuchMethod(
        Invocation.method(
          #setUnauthorized,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> setAuthorized({required String? accessToken}) =>
      (super.noSuchMethod(
        Invocation.method(
          #setAuthorized,
          [],
          {#accessToken: accessToken},
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}
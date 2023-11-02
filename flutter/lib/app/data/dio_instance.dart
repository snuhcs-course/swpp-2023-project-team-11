import 'package:dio/dio.dart';

class DioInstance {
  static final Dio _dio = Dio();

  static Dio get getDio => _dio;

  static addAuthorizationHeader(String accessToken) {
    _dio.interceptors.add(AuthorizationInterceptorsWrapper(
      onRequest: (options, handler) {
        // Request 시점에 이 인스턴스의 _accessToken을 참조한다.
        options.headers['Authorization'] = 'Bearer $accessToken';
        return handler.next(options);
      },
    ));
  }
  static deleteAuthorizationHeader() {
    _dio.interceptors
        .removeWhere((element) => element is AuthorizationInterceptorsWrapper);
  }
}

class AuthorizationInterceptorsWrapper extends InterceptorsWrapper {
  AuthorizationInterceptorsWrapper(
      {super.onError, super.onRequest, super.onResponse});
}

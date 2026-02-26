import 'package:dio/dio.dart';
import '../api/http_instance.dart';
import '../models/api/login_request.dart';
import '../models/api/login_response.dart';

class AuthService {
  final HttpInstance _http;

  AuthService(this._http);

  // 登录接口 POST /login
  Future<LoginResponse> login(String id, String pwd) async {
    try {
      final request = LoginRequest(id: id, pwd: pwd);
      final response = await _http.post(
        '/login/service',
        data: request.toJson(),
      );

      final loginResponse = LoginResponse.fromJson(response.data);

      // 登录成功，保存token
      if (loginResponse.isSuccess && loginResponse.token != null) {
        _http.setToken(loginResponse.token!);
      }

      return loginResponse;
    } on DioException catch (e) {
      throw _http.handleDioError(e);
    }
  }

  // 登出
  Future<void> logout() async {
    _http.setToken("");
  }
}

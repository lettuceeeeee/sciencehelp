import 'package:flutter/material.dart';
import 'package:sciencehelp/service/auth_service.dart';
import '../utils/token_manager.dart';
import '../api/http_instance.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final HttpInstance _httpInstance;

  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _error;
  String? _token;

  AuthProvider(this._authService, this._httpInstance);

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // 初始化时检查是否已有token
  Future<void> checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await TokenManager.getToken();
      if (token != null && token.isNotEmpty) {
        _token = token;
        _isLoggedIn = true;
        _httpInstance.setToken(token);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 登录
  Future<bool> login(String id, String pwd) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.login(id, pwd);

      if (response.isSuccess) {
        // 保存token
        _token = response.token;
        _isLoggedIn = true;
        await TokenManager.saveToken(response.token!);
        return true;
      } else {
        _error = response.message;
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 登出
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();
      _token = null;
      _isLoggedIn = false;
      await TokenManager.clearToken();
      _httpInstance.setToken("");
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

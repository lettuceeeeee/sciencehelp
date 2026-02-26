class LoginResponse {
  final int code;
  final String message;
  final String? token;

  LoginResponse({required this.code, required this.message, this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      code: json['code'] as int,
      message: json['msg'] as String,
      token: json['data'] as String?,
    );
  }

  bool get isSuccess => code == 200 && token != null;
}

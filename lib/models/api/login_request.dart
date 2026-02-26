class LoginRequest {
  // 统一认证登录账号

  final String id;

  final String pwd;

  const LoginRequest({required this.id, required this.pwd});

  Map<String, dynamic> toJson() {
    return {'id': id, 'pwd': pwd};
  }
}

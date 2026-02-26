class ApiConfig {
  static const String baseUrl = 'http://114.215.255.190:8080';

  // 统一认证登录URL
  static const String casLoginUrl =
      'https://i.sdu.edu.cn/cas/proxy/login/page?forward=http://114.215.255.190:8080/login';

  static const int connectTimeout = 20000;
  static const int receiveTimeout = 20000;
}

import 'package:dio/dio.dart';

class HttpInstance {
  late Dio _dio;
  String? _token;

  HttpInstance() {
    _token =
        'eyJ0eXBlIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJjYXNJRCI6IjIwMjUwMDU1MDI1NCIsIm5hbWUiOiLnlLPnj5DmiJAiLCJleHAiOjE3NzIxMjQzMTF9.LNPMiXr_UHZDF6laoxmnXA6eXwOR1qIcBKOVf02S-_c';
    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://114.215.255.190:8080',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        contentType: Headers.formUrlEncodedContentType, // 明确指定表单格式
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_token != null) {
            options.headers['Authorization'] = 'Bearer $_token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  void setToken(String token) {
    _token = token;
  }

  // GET请求
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // POST请求
  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    try {
      final formData = FormData();
      data?.forEach((key, value) {
        if (value is List) {
          if (value.isEmpty) {
            // 空列表：添加一个空字符串
            formData.fields.add(MapEntry(key, ''));
          } else {
            // 非空列表：为每个元素添加同名参数
            for (var item in value) {
              formData.fields.add(MapEntry(key, item.toString()));
            }
          }
        } else {
          // 非列表类型
          formData.fields.add(MapEntry(key, value.toString()));
        }
      });

      final response = await _dio.post(path, data: formData);
      return response;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // 错误处理
  Exception handleDioError(DioException e) {
    if (e.response?.statusCode == 401) {
      return Exception('Token无效，请重新登录');
    } else if (e.response?.statusCode == 403) {
      return Exception('没有权限，请携带Token');
    } else if (e.response?.statusCode == 400) {
      return Exception('请求参数错误: ${e.response?.data}');
    }
    return Exception('网络错误: ${e.message}');
  }
}

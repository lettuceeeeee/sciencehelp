import 'package:dio/dio.dart';

class HttpInstance {
  late Dio _dio;
  String? _token;

  HttpInstance() {
    // _token =
    //     'eyJ0eXBlIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJjYXNJRCI6IjIwMjQwMDMwMDAwNiIsIm5hbWUiOiLlvKDpm6rnnb8iLCJleHAiOjE3NzI0NDI4ODZ9.WmMM5sHGLP6lSCD91R8u1H-wZqxh4yzG3DCur8amcJE';
    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://114.215.255.190:8080',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
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
      // 构建 URL 参数
      final Map<String, dynamic> queryParams = {};

      data?.forEach((key, value) {
        if (value is List) {
          queryParams[key] = value.isEmpty ? '' : value.join(',');
        } else {
          queryParams[key] = value?.toString() ?? '';
        }
      });

      print('POST请求: $path');
      print('URL参数: $queryParams');

      // 不设置 Content-Type，让 Dio 自动选择
      final response = await _dio.post(
        path,
        queryParameters: queryParams,
        data: null, // 请求体为 null
        options: Options(
          // 不设置 contentType
          headers: {'Accept': 'application/json'},
        ),
      );

      return response;
    } on DioException catch (e) {
      print('错误状态码: ${e.response?.statusCode}');
      print('错误响应: ${e.response?.data}');
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

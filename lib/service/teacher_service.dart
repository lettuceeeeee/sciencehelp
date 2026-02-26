import 'package:dio/dio.dart';
import 'package:sciencehelp/api/http_instance.dart';
import 'package:sciencehelp/models/api/api_response.dart';
import 'package:sciencehelp/models/search_result.dart';
import 'package:sciencehelp/models/teacher.dart';

class TeacherService {
  final HttpInstance _http;

  TeacherService(this._http);

  // 首页接口
  Future<ApiResponse<HomeData>> getHome() async {
    try {
      final response = await _http.get('/home');
      return ApiResponse.fromJson(
        response.data,
        (data) => HomeData.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      rethrow;
    }
  }

  // 详情页接口
  Future<ApiResponse<Teacher>> getDetail(int id) async {
    try {
      final response = await _http.get('/detail/$id');
      return ApiResponse.fromJson(
        response.data,
        (data) => Teacher.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      rethrow;
    }
  }

  // 搜索接口
  Future<ApiResponse<SearchResult>> search({
    String? searchTerm,
    List<String>? searchTags,
    int current = 1,
    int size = 10,
  }) async {
    try {
      // 后端要求这两个参数必须传，所以即时空字符串/空列表也要传
      final Map<String, dynamic> formData = {
        'searchTerm': searchTerm ?? '',
        'searchTags': searchTags ?? [],
        'current': current,
        'size': size,
      };

      final response = await _http.post('/search', data: formData);

      return ApiResponse.fromJson(
        response.data,
        (data) => SearchResult.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      rethrow;
    }
  }
}

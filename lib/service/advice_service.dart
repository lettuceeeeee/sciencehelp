import 'package:dio/dio.dart';
import '../api/http_instance.dart';
import '../models/api/api_response.dart';
import '../models/api/paginated_response.dart';
import '../models/advice.dart';

class AdviceService {
  final HttpInstance _http;

  AdviceService(this._http);
  //post
  Future<ApiResponse<PaginatedResponse<Advice>>> getAdviceList({
    String? searchTag,
    int current = 1,
    int size = 10,
  }) async {
    try {
      final response = await _http.post(
        '/advice',
        data: {'searchTag': searchTag ?? '', 'current': current, 'size': size},
      );
      return ApiResponse.fromJson(
        response.data,
        (data) => PaginatedResponse<Advice>.fromJson(
          data as Map<String, dynamic>,
          (json) => Advice.fromJson(json),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  // GET
  Future<ApiResponse<Advice>> getAdviceDetail(int id) async {
    try {
      final response = await _http.get('/advice/detail/$id');
      return ApiResponse.fromJson(
        response.data,
        (data) => Advice.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      rethrow;
    }
  }
}

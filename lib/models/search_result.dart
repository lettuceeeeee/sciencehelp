import 'teacher.dart';
import 'api/paginated_response.dart';

class SearchResult extends PaginatedResponse<Teacher> {
  SearchResult({
    required super.current,
    required super.pages,
    required super.size,
    required super.total,
    required super.records,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    final paginated = PaginatedResponse<Teacher>.fromJson(
      json,
      (data) => Teacher.fromJson(data),
    );
    return SearchResult(
      current: paginated.current,
      pages: paginated.pages,
      size: paginated.size,
      total: paginated.total,
      records: paginated.records,
    );
  }

  void operator [](String other) {}
}

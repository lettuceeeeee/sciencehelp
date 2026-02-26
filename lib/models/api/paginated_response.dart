class PaginatedResponse<T> {
  final int current;
  final int pages;
  final int size;
  final int total;
  final List<T> records;

  PaginatedResponse({
    required this.current,
    required this.pages,
    required this.size,
    required this.total,
    required this.records,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) fromJsonT,
  ) {
    return PaginatedResponse(
      current: json['current'] as int,
      pages: json['pages'] as int,
      size: json['size'] as int,
      total: json['total'] as int,
      records: (json['records'] as List)
          .map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

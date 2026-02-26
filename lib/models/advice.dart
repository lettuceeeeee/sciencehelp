class Advice {
  final int id;
  final String title;
  final String content;
  final String? tag;

  Advice({
    required this.id,
    required this.title,
    required this.content,
    this.tag,
  });

  factory Advice.fromJson(Map<String, dynamic> json) {
    return Advice(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      tag: json['tag'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'content': content, 'tag': tag};
  }
}

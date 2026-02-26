class Teacher {
  final int id;
  final String name;
  final String achievement;
  final String introduction;
  final String department;
  final String requirement;
  final String email;
  final List<String> tags;
  final bool isRecruiting; // 是否招生
  final String? photoUrl;

  Teacher({
    required this.id,
    required this.name,
    required this.achievement,
    required this.introduction,
    required this.department,
    required this.requirement,
    required this.email,
    required this.tags,
    required this.isRecruiting,
    this.photoUrl,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'] as int,
      name: json['name'] as String,
      achievement: json['achievement'] as String? ?? '',
      introduction: json['introduction'] as String? ?? '',
      department: json['department'] as String? ?? '',
      requirement: json['requirement'] as String? ?? '',
      email: json['email'] as String? ?? '',
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
      isRecruiting: json['demand'] as bool? ?? false,
      photoUrl: json['photo'] as String?,
    );
  }
}

// 首页数据模型
class HomeData {
  final int teacherTotal;
  final int targetTeacherTotal;
  final List<Teacher> teachers;

  HomeData({
    required this.teacherTotal,
    required this.targetTeacherTotal,
    required this.teachers,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      teacherTotal: json['teacherTotal'] as int,
      targetTeacherTotal: json['targetTeacherTotal'] as int,
      teachers: (json['teachers'] as List)
          .map((e) => Teacher.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

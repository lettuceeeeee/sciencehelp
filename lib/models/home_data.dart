import 'teacher.dart';

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

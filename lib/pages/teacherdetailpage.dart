import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sciencehelp/providers/teacher_provider.dart';

class TeacherDetailPage extends StatefulWidget {
  final int teacherId;

  const TeacherDetailPage({super.key, required this.teacherId});

  @override
  State<TeacherDetailPage> createState() => _TeacherDetailPageState();
}

class _TeacherDetailPageState extends State<TeacherDetailPage> {
  @override
  void initState() {
    super.initState();
    // 加载教师详情
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeacherProvider>().loadTeacherDetail(widget.teacherId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TeacherProvider>();
    final teacher = provider.currentTeacher;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "导师详情",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.error != null
          ? Center(child: Text('加载失败: ${provider.error}'))
          : teacher == null
          ? const Center(child: Text('暂无数据'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(0),
              child: Column(
                children: [
                  // 头部信息
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 230, 247, 254),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: const Color.fromARGB(
                            255,
                            0,
                            85,
                            212,
                          ),
                          child: Text(
                            teacher.name[0],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          teacher.name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          teacher.department,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildInfoItem(
                    icon: Icons.email,
                    iconColor: const Color.fromARGB(255, 0, 85, 212),
                    title: "电子邮箱",
                    content: teacher.email,
                  ),
                  const SizedBox(height: 12),

                  // 研究方向
                  _buildTagsSection(teacher.tags),
                  const SizedBox(height: 24),

                  // 主要成就
                  if (teacher.achievement.isNotEmpty)
                    _buildAchievementSection(teacher.achievement),
                  const SizedBox(height: 24),

                  // 招生意向
                  if (teacher.requirement.isNotEmpty)
                    _buildRequirementSection(teacher.requirement),
                  const SizedBox(height: 24),

                  // 个人简介
                  if (teacher.introduction.isNotEmpty)
                    _buildIntroductionSection(teacher.introduction),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsSection(List<String> tags) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.book,
                color: Color.fromARGB(255, 0, 85, 212),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                "研究方向",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 230, 247, 254),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 0, 85, 212),
                    fontSize: 12,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementSection(String achievement) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.emoji_events,
                color: Color.fromARGB(255, 254, 85, 34),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                "主要成就",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 240, 240, 240),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              achievement,
              style: const TextStyle(color: Colors.black, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementSection(String requirement) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.school,
                color: Color.fromARGB(255, 77, 177, 80),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                "招生意向",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 240, 253, 241),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.school,
                  color: Color.fromARGB(255, 77, 177, 80),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    requirement,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 46, 124, 50),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroductionSection(String introduction) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.person,
                color: Color.fromARGB(255, 104, 58, 183),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                "个人简介",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            introduction,
            style: const TextStyle(color: Colors.black, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

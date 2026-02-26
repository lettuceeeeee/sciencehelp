import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sciencehelp/models/teacher.dart';
import 'package:sciencehelp/providers/teacher_provider.dart';
import 'teacherdetailpage.dart';

class TeacherListPage extends StatefulWidget {
  const TeacherListPage({super.key});

  @override
  State<TeacherListPage> createState() => _TeacherListPageState();
}

class _TeacherListPageState extends State<TeacherListPage> {
  final TextEditingController _searchController = TextEditingController();
  Set<String> _selectedTags = {};
  final ScrollController _scrollController = ScrollController();

  int _currentPage = 1;
  bool _isLoadingMore = false;

  // 处理标签点击
  void _toggleTag(String tag) {
    setState(() {
      if (tag == '全部') {
        _selectedTags.clear();
      } else {
        if (_selectedTags.contains(tag)) {
          _selectedTags.remove(tag);
        } else {
          _selectedTags.add(tag);
        }
        _selectedTags.remove('全部');
      }
    });
    _currentPage = 1;
    final provider = context.read<TeacherProvider>();

    provider.searchTeachers(
      searchTerm: _searchController.text.isNotEmpty
          ? _searchController.text
          : '',
      searchTags: _selectedTags.isEmpty ? [] : _selectedTags.toList(),
      current: 1,
      size: 10,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<TeacherProvider>();
      provider.searchTeachers(
        searchTerm: '',
        searchTags: [],
        current: 1,
        size: 10,
      );
      _currentPage = 1;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final provider = context.read<TeacherProvider>();
      if (!_isLoadingMore && provider.hasMore) {
        _loadMore();
      }
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    final provider = context.read<TeacherProvider>();
    await provider.searchTeachers(
      searchTerm: _searchController.text.isNotEmpty
          ? _searchController.text
          : '',
      searchTags: _selectedTags.isEmpty ? [] : _selectedTags.toList(),
      current: _currentPage + 1,
      size: 10,
      isLoadMore: true,
    );

    setState(() {
      _currentPage = provider.currentPage;
      _isLoadingMore = false;
    });
  }

  Future<void> _performSearch() async {
    _currentPage = 1;
    final provider = context.read<TeacherProvider>();

    await provider.searchTeachers(
      searchTerm: _searchController.text.isNotEmpty
          ? _searchController.text
          : '',
      searchTags: _selectedTags.isEmpty ? [] : _selectedTags.toList(),
      current: 1,
      size: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TeacherProvider>();
    final displayTeachers = provider.teachers;

    final tags = provider.allTags;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "导师列表",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 229, 229, 229),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: "搜索导师姓名或研究方向...",
                      prefixIcon: Icon(Icons.search, color: Colors.black),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                    ),
                    onSubmitted: (_) => _performSearch(),
                  ),
                ),
                const SizedBox(height: 16),
                _buildTags(provider),
              ],
            ),
          ),
          Expanded(child: _buildContent(provider, displayTeachers)),
        ],
      ),
    );
  }

  Widget _buildContent(TeacherProvider provider, List<Teacher> teachers) {
    if (provider.isLoading && teachers.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('加载失败: ${provider.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                provider.clearError();
                _loadInitialData();
              },
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    if (teachers.isEmpty) {
      return const Center(
        child: Text(
          '暂无相关导师',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      );
    }

    // 有数据时显示列表
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "共找到${provider.totalItems}位导师",
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: teachers.length + (_isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == teachers.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return _buildTeacherItem(teachers[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTeacherItem(Teacher teacher) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 224, 224, 224),
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color.fromARGB(255, 230, 247, 255),
                child: Text(
                  teacher.name[0],
                  style: const TextStyle(
                    color: Color.fromARGB(255, 0, 85, 212),
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      teacher.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      teacher.department,
                      style: const TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TeacherDetailPage(teacherId: teacher.id),
                    ),
                  );
                },
                child: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(
            color: Color.fromARGB(255, 224, 224, 224),
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                "研究方向：",
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
              Expanded(
                child: Text(
                  teacher.tags.join(' · '),
                  style: const TextStyle(color: Colors.black, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (teacher.isRecruiting)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 240, 253, 241),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                "招生意向开放中",
                style: TextStyle(
                  color: Color.fromARGB(255, 77, 177, 80),
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTags(TeacherProvider provider) {
    final tags = provider.allTags;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tags.map((tag) {
          bool isSelected = tag == '全部'
              ? _selectedTags
                    .isEmpty // 全部没选中时显示"全部"被选中
              : _selectedTags.contains(tag);
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => _toggleTag(tag),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color.fromARGB(255, 0, 84, 212)
                      : const Color.fromARGB(255, 229, 229, 229),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sciencehelp/service/teacher_service.dart';
import 'package:sciencehelp/models/teacher.dart';
import 'package:sciencehelp/models/search_result.dart';

class TeacherProvider extends ChangeNotifier {
  final TeacherService _service;
  List<String> _allTags = ['全部'];

  List<String> get allTags => _allTags;
  List<Teacher> _homeTeachers = []; // 首页展示的教师
  List<Teacher> _searchResults = []; // 搜索结果
  bool _isLoading = false;
  String? _error;
  Teacher? _currentTeacher;

  // 分页相关
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalItems = 0;

  TeacherProvider(this._service);

  List<Teacher> get teachers =>
      _searchResults.isNotEmpty ? _searchResults : _homeTeachers;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Teacher? get currentTeacher => _currentTeacher;
  int get totalItems => _totalItems;
  int get currentPage => _currentPage;
  bool get hasMore => _currentPage < _totalPages;
  //提取所有标签
  void _extractTagsFromTeachers(List<Teacher> teachers) {
    if (teachers.isEmpty) {
      return;
    }
    final Set<String> tagSet = {};
    for (var teacher in teachers) {
      tagSet.addAll(teacher.tags);
    }
    _allTags = ['全部', ...tagSet.toList()..sort()];
    notifyListeners();
  }

  // 加载首页数据
  Future<void> loadHomeData() async {
    _isLoading = true;
    _error = null;
    _searchResults = [];
    notifyListeners();

    try {
      final response = await _service.getHome();
      if (response.isSuccess && response.data != null) {
        _homeTeachers = response.data!.teachers;
        // 从首页数据提取标签
        _extractTagsFromTeachers(response.data!.teachers);
      } else {
        _error = response.message;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 加载教师详情
  Future<void> loadTeacherDetail(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _service.getDetail(id);
      if (response.isSuccess && response.data != null) {
        _currentTeacher = response.data;
      } else {
        _error = response.message;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 搜索教师
  Future<void> searchTeachers({
    String? searchTerm,
    List<String>? searchTags,
    int current = 1,
    int size = 10,
    bool isLoadMore = false,
  }) async {
    if (!isLoadMore) {
      _isLoading = true;
      _error = null;
    }
    notifyListeners();
    try {
      final response = await _service.search(
        searchTerm: searchTerm,
        searchTags: searchTags,
        current: current,
        size: size,
      );

      if (response.isSuccess && response.data != null) {
        final result = response.data!;
        if (isLoadMore) {
          _searchResults.addAll(result.records);
        } else {
          _searchResults = result.records;
          if (result.records.isNotEmpty && _allTags.length <= 1) {
            _extractTagsFromTeachers(result.records);
          }
        }
        _currentPage = result.current;
        _totalPages = result.pages;
        _totalItems = result.total;
      } else {
        _error = response.message;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 重置搜索
  void resetSearch() {
    _searchResults = [];
    _currentPage = 1;
    _totalPages = 1;
    _totalItems = 0;
    notifyListeners();
  }

  // 清除错误
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

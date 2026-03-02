// File: lib/providers/advice_provider.dart
import 'package:flutter/material.dart';
import '../service/advice_service.dart';
import '../models/advice.dart';
import '../models/api/paginated_response.dart';
import '../models/api/api_response.dart';

class AdviceProvider extends ChangeNotifier {
  final AdviceService _service;
  List<Advice> _advices = [];
  bool _isloading = false;
  String? _error;
  Advice? _currentadvice;
  int _currentpage = 1;
  int _totalpage = 1;
  int _totalitem = 0;
  String? _currentSearchTag; // 保存当前的搜索标签

  AdviceProvider(this._service);

  List<Advice> get advices => _advices;
  bool get isloading => _isloading;
  String? get error => _error;
  Advice? get currentadvice => _currentadvice;
  int get currentpage => _currentpage;
  int get totalpage => _totalpage;
  int get totalitem => _totalitem;
  bool get hasmore => _currentpage < _totalpage;
  String? get currentSearchTag => _currentSearchTag;

  Future<void> loadadvicelist({
    String? searchtag, // 对应接口的 searchTag 参数
    int current = 1,
    int size = 10,
    bool isloadmore = false,
  }) async {
    // 保存当前的搜索标签
    if (!isloadmore) {
      _currentSearchTag = searchtag;
    }

    if (isloadmore) {
      _isloading = true;
      notifyListeners();
    }

    if (!isloadmore) {
      _advices = [];
      _isloading = true;
      _error = null;
      notifyListeners();
    }

    try {
      final ApiResponse<PaginatedResponse<Advice>> response = await _service
          .getAdviceList(searchTag: searchtag, current: current, size: size);

      if (response.isSuccess && response.data != null) {
        final PaginatedResponse<Advice> data = response.data!;

        if (isloadmore) {
          _advices.addAll(data.records);
        } else {
          _advices = data.records;
        }

        _currentpage = data.current;
        _totalpage = data.pages;
        _totalitem = data.total;
      } else {
        _error = response.message ?? '获取列表失败';
        if (!isloadmore) _advices = [];
      }
    } catch (e) {
      _error = e.toString();
      if (!isloadmore) _advices = [];
    } finally {
      _isloading = false;
      notifyListeners();
    }
  }

  // 加载建议详情
  Future<void> loadAdviceDetail(int id) async {
    _isloading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _service.getAdviceDetail(id);
      if (response.isSuccess && response.data != null) {
        _currentadvice = response.data;
      } else {
        _error = response.message ?? '获取详情失败';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isloading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void resetAdvice() {
    _advices = [];
    _currentpage = 1;
    _totalpage = 1;
    _totalitem = 0;
    _currentSearchTag = null;
    notifyListeners();
  }
}

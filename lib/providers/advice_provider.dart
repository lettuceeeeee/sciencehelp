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

  AdviceProvider(this._service);

  List<Advice> get advices => _advices;
  bool get isloading => _isloading;
  String? get error => _error;
  Advice? get currentadvice => _currentadvice;
  int get currentpage => _currentpage;
  int get totalpage => _totalpage;
  int get totalitem => _totalitem;
  bool get hasmore => _currentpage < _totalpage; //getter方法

  Future<void> loadadvicelist({
    //加载列表
    String? searchtag,
    int current = 1,
    int size = 10,
    bool isloadmore = false,
  }) async {
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
        final PaginatedResponse<Advice> data =
            response.data as PaginatedResponse<Advice>;
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
      }
    } catch (e) {
      _error = e.toString();
      if (!isloadmore) _advices = [];
    } finally {
      _isloading = false;
      notifyListeners();
    }
  }

  void clearError() {
    // 清除错误
    _error = null;
    notifyListeners();
  }

  void resetadvice() {
    //重置列表
    _advices = [];
    _currentpage = 1;
    _totalpage = 1;
    _totalitem = 0;
    notifyListeners();
  }
}

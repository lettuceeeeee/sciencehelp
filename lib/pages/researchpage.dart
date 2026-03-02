// File: lib/pages/researchpage.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sciencehelp/pages/advicedetailpage.dart';
import 'package:sciencehelp/providers/advice_provider.dart';
import 'package:sciencehelp/models/advice.dart';

class ResearchPage extends StatefulWidget {
  const ResearchPage({super.key});

  @override
  State<ResearchPage> createState() => _ResearchPageState();
}

class _ResearchPageState extends State<ResearchPage> {
  String? _selectedTag;
  final ScrollController _scrollController = ScrollController();

  int _currentPage = 1;
  bool _isLoadingMore = false;

  // 预定义的标签选项（可以从后端获取，这里先写死一些示例）
  final List<String> _tagOptions = [
    '全部',
    '论文写作',
    '实验方法',
    '数据分析',
    '文献综述',
    '投稿经验',
    '科研工具',
    '基金申请',
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AdviceProvider>();
      provider.loadadvicelist(
        searchtag: _selectedTag == '全部' ? null : _selectedTag,
        current: 1,
        size: 10,
      );
      _currentPage = 1;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final provider = context.read<AdviceProvider>();
      if (!_isLoadingMore && provider.hasmore) {
        _loadMore();
      }
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    final provider = context.read<AdviceProvider>();
    await provider.loadadvicelist(
      searchtag: _selectedTag == '全部' ? null : _selectedTag,
      current: _currentPage + 1,
      size: 10,
      isloadmore: true,
    );

    setState(() {
      _currentPage = provider.currentpage;
      _isLoadingMore = false;
    });
  }

  void _toggleTag(String tag) {
    setState(() {
      if (tag == '全部') {
        _selectedTag = null;
      } else {
        _selectedTag = _selectedTag == tag ? null : tag;
      }
    });
    _currentPage = 1;
    final provider = context.read<AdviceProvider>();

    provider.loadadvicelist(searchtag: _selectedTag, current: 1, size: 10);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AdviceProvider>();
    final advicelist = provider.advices;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "科研帮助",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 标签筛选栏
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: _buildTags(),
          ),
          Expanded(child: _buildContent(provider, advicelist)),
        ],
      ),
    );
  }

  Widget _buildContent(AdviceProvider provider, List<Advice> advicelist) {
    if (provider.isloading && advicelist.isEmpty) {
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

    if (advicelist.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              '暂无相关科研帮助',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
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
              "共找到${provider.totalitem}条内容",
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: advicelist.length + (_isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == advicelist.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return _buildAdviceItem(advicelist[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAdviceItem(Advice advice) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            advice.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          if (advice.tag != null && advice.tag!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 229, 244, 255),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  advice.tag!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 25, 118, 212),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 4),
          Text(
            advice.content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdviceDetailPage(adviceId: advice.id),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '阅读更多',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 0, 85, 212),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward,
                  size: 14,
                  color: const Color.fromARGB(255, 0, 85, 212),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTags() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _tagOptions.map((tag) {
          bool isSelected = tag == '全部'
              ? _selectedTag == null
              : _selectedTag == tag;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => _toggleTag(tag),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color.fromARGB(255, 0, 84, 212)
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontSize: 13,
                    fontWeight: isSelected
                        ? FontWeight.w500
                        : FontWeight.normal,
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

// File: lib/pages/advicedetailpage.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sciencehelp/providers/advice_provider.dart';
import 'package:sciencehelp/models/advice.dart';

class AdviceDetailPage extends StatefulWidget {
  final int adviceId;

  const AdviceDetailPage({super.key, required this.adviceId});

  @override
  State<AdviceDetailPage> createState() => _AdviceDetailPageState();
}

class _AdviceDetailPageState extends State<AdviceDetailPage> {
  @override
  void initState() {
    super.initState();
    // 加载建议详情
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdviceProvider>().loadAdviceDetail(widget.adviceId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AdviceProvider>();
    final advice = provider.currentadvice;

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
          "科研详情",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: provider.isloading
          ? const Center(child: CircularProgressIndicator())
          : provider.error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('加载失败: ${provider.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.clearError();
                      provider.loadAdviceDetail(widget.adviceId);
                    },
                    child: const Text('重试'),
                  ),
                ],
              ),
            )
          : advice == null
          ? const Center(child: Text('暂无数据'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题区域
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 240, 247, 255),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          advice.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (advice.tag != null && advice.tag!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 0, 85, 212),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              advice.tag!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 内容区域
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.description,
                              size: 20,
                              color: Color.fromARGB(255, 0, 85, 212),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '详细内容',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          advice.content,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 底部信息
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '文章ID: ${advice.id}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

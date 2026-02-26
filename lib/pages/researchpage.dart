import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/advice_provider.dart';
import '../models/advice.dart';

class ResearchPage extends StatelessWidget {
  const ResearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final adviceprovider = context.watch<AdviceProvider>();
    final List<Advice> advicelist = adviceprovider.advices;

    print("Provider是否初始化：${adviceprovider != null}");
    print("当前列表长度：${advicelist.length}");
    print("是否正在加载：${adviceprovider.isloading}");
    print("错误信息：${adviceprovider.error}");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (advicelist.isEmpty && !adviceprovider.isloading) {
        adviceprovider.loadadvicelist();
      }
    });

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 229, 229, 229),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "搜索博客，经验分享...",
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            advicelist.isEmpty
                ? const Center(child: Text("暂无科研帮助数据"))
                : Column(
                    children: advicelist.map((Advice advice) {
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2,
                              offset: const Offset(0, 1),
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
                            if (advice.tag != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      255,
                                      229,
                                      244,
                                      255,
                                    ),
                                  ),
                                  child: Text(
                                    advice.tag!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: const Color.fromARGB(
                                        255,
                                        25,
                                        118,
                                        212,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            Text(
                              advice.content,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                                height: 1.5,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }
}

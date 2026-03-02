import 'package:flutter/material.dart';
import 'package:sciencehelp/api/http_instance.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/token_manager.dart';
import 'tabpage.dart';

class CasLoginPage extends StatefulWidget {
  const CasLoginPage({super.key});

  @override
  State<CasLoginPage> createState() => _CasLoginPageState();
}

class _CasLoginPageState extends State<CasLoginPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // CAS登录页面URL
    final loginUrl =
        'https://i.sdu.edu.cn/cas/proxy/login/page?forward=http://114.215.255.190:8080/login';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
          },
          onNavigationRequest: (NavigationRequest request) {
            // 检查是否跳转到后端的 /login 接口
            if (request.url.startsWith('http://114.215.255.190:8080/login')) {
              // 处理这个重定向，提取token
              _handleLoginRedirect(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(loginUrl));
  }

  // 处理登录重定向，提取token
  Future<void> _handleLoginRedirect(String url) async {
    try {
      // 发送请求到 /login 接口
      final response = await _controller.runJavaScriptReturningResult('''
        fetch('$url')
          .then(res => res.json())
          .then(data => JSON.stringify(data))
          .catch(err => JSON.stringify({error: err.message}))
      ''');

      // 解析响应
      final responseStr = response.toString();
      if (responseStr.contains('code') && responseStr.contains('data')) {
        final tokenMatch = RegExp(r'"data":"([^"]+)"').firstMatch(responseStr);
        if (tokenMatch != null) {
          final token = tokenMatch.group(1);
          if (token != null && token.isNotEmpty) {
            await _handleLoginSuccess(token);
          }
        }
      }
    } catch (e) {}
  }

  Future<void> _handleLoginSuccess(String token) async {
    // 保存token
    await TokenManager.saveToken(token);

    // 设置到HttpInstance
    final httpInstance = context.read<HttpInstance>();
    httpInstance.setToken(token);

    // 更新登录状态
    final authProvider = context.read<AuthProvider>();
    await authProvider.setLoggedIn(true, token);

    if (!mounted) return;

    // 跳转到主页
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Tabpage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('山东大学统一认证'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}

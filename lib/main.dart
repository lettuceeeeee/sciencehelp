import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sciencehelp/api/http_instance.dart';
import 'package:sciencehelp/providers/auth_provider.dart';
import 'package:sciencehelp/service/auth_service.dart';
import 'package:sciencehelp/service/teacher_service.dart';
import 'package:sciencehelp/providers/teacher_provider.dart';
import 'pages/registerpage.dart';
import 'pages/tabpage.dart';
import 'package:sciencehelp/service/advice_service.dart';
import 'package:sciencehelp/providers/advice_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 单例服务
        Provider(create: (_) => HttpInstance()),
        Provider(create: (ctx) => AuthService(ctx.read())),
        Provider(create: (ctx) => TeacherService(ctx.read())),
        // 状态管理器
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(ctx.read(), ctx.read()),
        ),
        ChangeNotifierProvider(create: (ctx) => TeacherProvider(ctx.read())),
        Provider(create: (ctx) => AdviceService(ctx.read())),
        ChangeNotifierProvider(create: (ctx) => AdviceProvider(ctx.read())),
      ],
      child: MaterialApp(
        title: '科研助手',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const Tabpage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final id = TextEditingController();
  final pwd = TextEditingController();
  @override
  void initState() {
    super.initState();
    // 检查是否已登录
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().checkLoginStatus().then((_) {
        final auth = context.read<AuthProvider>();
        if (auth.isLoggedIn) {
          // 如果已登录，直接跳转到主页
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Tabpage()),
          );
        }
      });
    });
  }

  Future<void> login() async {
    var i = id.text.trim(); //id
    var p = pwd.text.trim(); //密码
    if (i.isEmpty || p.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("学号或密码不能为空！")));
      return;
    }
    final auth = context.read<AuthProvider>();
    final success = await auth.login(i, p);

    if (!mounted) return;

    if (success) {
      // 登录成功，跳转到主页
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("登录成功！")));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Tabpage()),
      );
    } else {
      // 登录失败，显示错误信息
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.error ?? '登录失败'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //sdu logo
            const SizedBox(height: 60),
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: const Center(
                    child: Text(
                      'SDU',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 15),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '山东大学软件学院',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '导师联系平台',
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 40),
            const Center(child: Text('欢迎登录', style: TextStyle(fontSize: 32))),
            const SizedBox(height: 40),

            TextField(
              controller: id,
              decoration: InputDecoration(
                hintText: '请输入学号',
                prefixIcon: const Icon(
                  Icons.person_outline,
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 229, 229, 229),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: pwd,
              obscureText: true,
              decoration: InputDecoration(
                hintText: '请输入密码',
                prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                filled: true,
                fillColor: const Color.fromARGB(255, 230, 230, 230),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),

            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: const Text(
                  '还没有账号？去注册',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 102, 153, 255),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  elevation: 5,
                ),
                child: const Text(
                  '登      录',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

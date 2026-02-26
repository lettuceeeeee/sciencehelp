import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});
  final id = TextEditingController();
  final pwd = TextEditingController();
  final confirmpwd = TextEditingController();
  void register(BuildContext context) {
    var i = id.text.trim();
    var p = pwd.text.trim();
    var cp = confirmpwd.text.trim();
    if (i.isEmpty || p.isEmpty || cp.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("学号/密码不能为空！")));
      return;
    }
    if (p != cp) {
      //密码校验
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("两次密码不一样！")));
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("注册成功！去登录吧")));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
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
            const Center(child: Text('欢迎注册', style: TextStyle(fontSize: 32))),
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
            const SizedBox(height: 30),
            TextField(
              controller: confirmpwd,
              obscureText: true,
              decoration: InputDecoration(
                hintText: '请确认密码',
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
                  Navigator.pop(context);
                },
                child: const Text(
                  '已有账号？去登录',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  register(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 103, 154, 255),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  elevation: 5,
                ),
                child: const Text(
                  '注      册',
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

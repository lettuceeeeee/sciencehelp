import 'package:flutter/material.dart';
import 'homepage.dart';
import 'teacherlistpage.dart';
import 'researchpage.dart';
import 'mypage.dart';

class Tabpage extends StatefulWidget {
  const Tabpage({super.key});

  @override
  State<Tabpage> createState() => _TabpageState();
}

class _TabpageState extends State<Tabpage> {
  int currentIndex = 0;

  final List<Widget> pages = [
    HomePage(),
    TeacherListPage(),
    ResearchPage(),
    MyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        backgroundColor: Colors.white,
        selectedItemColor: const Color.fromARGB(255, 0, 85, 212),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "首页",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: "导师",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book),
            label: "科研",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            activeIcon: Icon(Icons.account_circle),
            label: "我的",
          ),
        ],
      ),
    );
  }
}

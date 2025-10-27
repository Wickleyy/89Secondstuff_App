import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/modules/account/account_view.dart';
import 'package:_89_secondstufff/app/modules/chat/chat_view.dart';
import 'package:_89_secondstufff/app/modules/home/home_view.dart';
import 'package:_89_secondstufff/app/modules/main_navigation/main_navigation_controller.dart';
import 'package:_89_secondstufff/app/modules/search/search_view.dart';
import 'package:_89_secondstufff/app/modules/categories/categories_view.dart';

class MainNavigationView extends GetView<MainNavigationController> {
  MainNavigationView({super.key});

  final List<Widget> pages = [
    HomeView(),
    CategoriesView(),
    SearchView(),
    ChatView(),
    AccountView(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Drawer agar bisa diakses dari semua tab
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: pages,
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changePage,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined),
              activeIcon: Icon(Icons.category),
              label: 'Kategori',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}

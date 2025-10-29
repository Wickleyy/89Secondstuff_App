import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/services/api_service.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';
import 'package:_89_secondstufff/app/themes/theme_controller.dart';
import 'package:_89_secondstufff/app/modules/cart/cart_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ApiService());
  Get.put(ThemeController());
  Get.put(CartController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return Obx(
      () => GetMaterialApp(
        title: '89secondStuff',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode:
            themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        unknownRoute: GetPage(
          name: '/notfound',
          page: () => Scaffold(
            appBar: AppBar(title: const Text('404 - Not Found')),
            body: const Center(
              child: Text('Halaman tidak ditemukan'),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';
import 'package:_89_secondstufff/app/themes/theme_controller.dart';

void main() {
  // Pastikan binding diinisialisasi
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi ThemeController
  Get.put(ThemeController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Gunakan GetX untuk mengambil controller
    final ThemeController themeController = Get.find();

    return Obx(
      () => GetMaterialApp(
        title: '89secondStuff',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode:
            themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        initialRoute: AppPages.INITIAL, // Rute awal (bisa ke login)
        getPages: AppPages.routes, // Semua rute aplikasi

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

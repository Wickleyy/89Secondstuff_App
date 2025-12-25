import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:_89_secondstufff/firebase_options.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';
import 'package:_89_secondstufff/app/themes/theme_controller.dart';
import 'package:_89_secondstufff/app/modules/cart/cart_controller.dart';
import 'package:_89_secondstufff/app/data/services/supabase_service.dart';
import 'package:_89_secondstufff/app/data/providers/product_provider.dart';
import 'package:_89_secondstufff/app/data/services/api_service.dart';
import 'package:_89_secondstufff/app/data/services/local_storage_service.dart';
import 'package:_89_secondstufff/app/data/services/location_service.dart';
import 'package:_89_secondstufff/app/data/services/payment_service.dart';
import 'package:_89_secondstufff/app/data/services/order_service.dart';
import 'package:_89_secondstufff/app/data/services/wishlist_service.dart';
import 'package:_89_secondstufff/app/data/services/notification_service.dart';
import 'package:_89_secondstufff/app/data/controllers/address_controller.dart';
import 'package:_89_secondstufff/app/data/models/profiles_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String initialRoute = AppRoutes.LOGIN;

  await dotenv.load(fileName: ".env");
  debugPrint('[INIT] dotenv loaded');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint('[INIT] Firebase initialized');

  await initializeDateFormatting('id_ID', null);
  debugPrint('[INIT] Date formatting initialized');

  final themeController = Get.put(ThemeController());
  await themeController.initTheme();
  debugPrint('[INIT] Theme initialized');

  final supabaseService = await Get.putAsync(() => SupabaseService().init());
  debugPrint('[INIT] Supabase initialized');

  await Get.putAsync(() => LocalStorageService().init());
  debugPrint('[INIT] LocalStorage initialized');

  Get.put(ApiService());
  Get.put(CartController());
  Get.lazyPut(() => ProductProvider());
  debugPrint('[INIT] Basic services registered');

  try {
    await Get.putAsync(() => LocationService().init());
    debugPrint('[INIT] Location service initialized');
  } catch (e) {
    debugPrint('[INIT] Location service failed: $e');
  }

  try {
    await Get.putAsync(() => PaymentService().init());
    debugPrint('[INIT] Payment service initialized');
  } catch (e) {
    debugPrint('[INIT] Payment service failed: $e');
  }

  try {
    await Get.putAsync(() => OrderService().init());
    debugPrint('[INIT] Order service initialized');
  } catch (e) {
    debugPrint('[INIT] Order service failed: $e');
  }

  try {
    await Get.putAsync(() => WishlistService().init());
    debugPrint('[INIT] Wishlist service initialized');
  } catch (e) {
    debugPrint('[INIT] Wishlist service failed: $e');
  }

  try {
    await Get.putAsync(() => NotificationService().init());
    debugPrint('[INIT] Notification service initialized');
  } catch (e) {
    debugPrint('[INIT] Notification service failed: $e');
  }

  Get.lazyPut(() => AddressController());
  debugPrint('[INIT] AddressController registered (lazy)');

  final currentUser = supabaseService.currentUser;

  if (currentUser != null) {
    try {
      final profileResponse = await supabaseService.client
          .from('profiles')
          .select('role')
          .eq('id', currentUser.id)
          .maybeSingle();

      if (profileResponse != null) {
        final profile = Profile.fromJson(profileResponse);
        if (profile.role == 'admin') {
          initialRoute = AppRoutes.ADMIN_HOME;
        } else {
          initialRoute = AppRoutes.MAIN_NAVIGATION;
        }
      }
    } catch (e) {
      debugPrint("Error checking role during auto-login: $e");
    }
  }
  debugPrint('[INIT] Initial route: $initialRoute');

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        title: '89secondStuff',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: Get.find<ThemeController>().isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light,
        initialRoute: initialRoute,
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

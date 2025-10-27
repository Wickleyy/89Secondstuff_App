import 'package:get/get.dart';

import '../modules/auth/auth_binding.dart';
import '../modules/auth/login_view.dart';
import '../modules/auth/signup_view.dart';
import '../modules/categories/categories_binding.dart';
import '../modules/categories/categories_view.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/main_navigation/main_navigation_binding.dart';
import '../modules/main_navigation/main_navigation_view.dart';
import '../modules/product_detail/product_detail_binding.dart';
import '../modules/product_detail/product_detail_view.dart';
import '../modules/search/search_view.dart';
import '../modules/chat/chat_view.dart';
import '../modules/account/account_view.dart';

// --- IMPORT MODULE BARU ---
//import '../modules/categories/categories_binding.dart';
//import '../modules/categories/categories_view.dart';
// --- AKHIR IMPORT ---

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = AppRoutes.LOGIN;

  static final routes = [
    // ... (rute lain tetap sama)
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => SignUpView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.MAIN_NAVIGATION,
      page: () => MainNavigationView(),
      binding: MainNavigationBinding(),
      // Kita juga bind sub-page bindings di sini agar siap dipakai
      bindings: [
        HomeBinding(),
        CategoriesBinding(),
        // Tambahkan binding untuk Search, Chat, Account jika ada controllernya
      ],
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.CATEGORIES,
      page: () => CategoriesView(),
      binding: CategoriesBinding(),
    ),
    GetPage(
      name: _Paths.CATEGORY_PRODUCTS,
      page: () => CategoriesView(),
      binding: CategoriesBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_DETAIL,
      page: () => ProductDetailView(),
      binding: ProductDetailBinding(),
    ),
    GetPage(name: _Paths.SEARCH, page: () => SearchView()),
    GetPage(name: _Paths.CHAT, page: () => ChatView()),
    GetPage(name: _Paths.ACCOUNT, page: () => AccountView()),
  ];
}

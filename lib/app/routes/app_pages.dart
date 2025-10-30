import 'package:_89_secondstufff/app/modules/account/account_binding.dart';
import 'package:_89_secondstufff/app/modules/account/account_view.dart';
import 'package:_89_secondstufff/app/modules/account/edit_profile/edit_profile_binding.dart';
import 'package:_89_secondstufff/app/modules/account/edit_profile/edit_profile_view.dart';
import 'package:_89_secondstufff/app/modules/account/order_history/order_history_binding.dart';
import 'package:_89_secondstufff/app/modules/account/order_history/order_history_view.dart';
import 'package:_89_secondstufff/app/modules/account/shipping_address/shipping_address_binding.dart';
import 'package:_89_secondstufff/app/modules/account/shipping_address/shipping_address_view.dart';
import 'package:_89_secondstufff/app/modules/account/notification_settings/notification_settings_binding.dart';
import 'package:_89_secondstufff/app/modules/account/notification_settings/notification_settings_view.dart';
import 'package:_89_secondstufff/app/modules/account/help_center/help_center_binding.dart';
import 'package:_89_secondstufff/app/modules/account/help_center/help_center_view.dart';
import 'package:_89_secondstufff/app/modules/account/privacy_policy/privacy_policy_binding.dart';
import 'package:_89_secondstufff/app/modules/account/privacy_policy/privacy_policy_view.dart';
import 'package:_89_secondstufff/app/modules/cart/cart_view.dart';
import 'package:_89_secondstufff/app/modules/chat/chat_binding.dart';
import 'package:_89_secondstufff/app/modules/search/search_binding.dart';
import 'package:get/get.dart';

import '../modules/auth/auth_binding.dart';
import '../modules/auth/login_view.dart';
import '../modules/auth/signup_view.dart';
import '../modules/categories/categories_binding.dart';
import '../modules/home/home_binding.dart';
import '../modules/main_navigation/main_navigation_binding.dart';
import '../modules/main_navigation/main_navigation_view.dart';
import '../modules/product_detail/product_detail_binding.dart';
import '../modules/product_detail/product_detail_view.dart';
import '../modules/search/search_view.dart';
import '../modules/chat/chat_view.dart';
import '../modules/category_product/category_product_binding.dart';
import '../modules/category_product/category_product_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = AppRoutes.LOGIN;

  static final routes = [
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
      bindings: [
        HomeBinding(),
        CategoriesBinding(),
        SearchBinding(),
        ChatBinding(),
        AccountBinding(),
      ],
    ),
    GetPage(
      name: _Paths.CATEGORY_PRODUCTS,
      page: () => CategoryProductsView(),
      binding: CategoryProductsBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_DETAIL,
      page: () => ProductDetailView(),
      binding: ProductDetailBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH,
      page: () => SearchView(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT,
      page: () => AccountView(),
      binding: AccountBinding(),
    ),
    GetPage(
      name: _Paths.CART,
      page: () => CartView(),
    ),
    
    // Account Sub Routes
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_HISTORY,
      page: () => OrderHistoryView(),
      binding: OrderHistoryBinding(),
    ),
    GetPage(
      name: _Paths.SHIPPING_ADDRESS,
      page: () => ShippingAddressView(),
      binding: ShippingAddressBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION_SETTINGS,
      page: () => NotificationSettingsView(),
      binding: NotificationSettingsBinding(),
    ),
    GetPage(
      name: _Paths.HELP_CENTER,
      page: () => HelpCenterView(),
      binding: HelpCenterBinding(),
    ),
    GetPage(
      name: _Paths.PRIVACY_POLICY,
      page: () => PrivacyPolicyView(),
      binding: PrivacyPolicyBinding(),
    ),
  ];
}
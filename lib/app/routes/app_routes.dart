// FILE: lib/app/routes/app_routes.dart
part of 'app_pages.dart';

abstract class AppRoutes {
  AppRoutes._();
  static const HOME = _Paths.HOME;
  static const LOGIN = _Paths.LOGIN;
  static const SIGNUP = _Paths.SIGNUP;
  static const MAIN_NAVIGATION = _Paths.MAIN_NAVIGATION;
  static const CATEGORIES = _Paths.CATEGORIES;
  static const CATEGORY_PRODUCTS = _Paths.CATEGORY_PRODUCTS;
  static const PRODUCT_DETAIL = _Paths.PRODUCT_DETAIL;
  static const SEARCH = _Paths.SEARCH;
  static const ACCOUNT = _Paths.ACCOUNT;
  static const CHAT = _Paths.CHAT;
  static const CART = _Paths.CART;
  static const CHECKOUT = _Paths.CHECKOUT;
  static const PAYMENT_STATUS = _Paths.PAYMENT_STATUS;
  static const WISHLIST = _Paths.WISHLIST;

  // Settings
  static const SETTINGS = _Paths.SETTINGS;

  // Account Sub Routes
  static const EDIT_PROFILE = _Paths.EDIT_PROFILE;
  static const ORDER_HISTORY = _Paths.ORDER_HISTORY;
  static const SHIPPING_ADDRESS = _Paths.SHIPPING_ADDRESS;
  static const MAP_PICKER = _Paths.MAP_PICKER;
  static const NOTIFICATION_SETTINGS = _Paths.NOTIFICATION_SETTINGS;
  static const HELP_CENTER = _Paths.HELP_CENTER;
  static const PRIVACY_POLICY = _Paths.PRIVACY_POLICY;

  // Admin
  static const ADMIN_HOME = _Paths.ADMIN_HOME;
  static const ADMIN_CHAT_LIST = _Paths.ADMIN_CHAT_LIST;
  static const ADMIN_CHAT_DETAIL = _Paths.ADMIN_CHAT_DETAIL;
  static const ADMIN_PRODUCT_LIST = _Paths.ADMIN_PRODUCT_LIST;
  static const ADMIN_PRODUCT_FORM = _Paths.ADMIN_PRODUCT_FORM;
  static const ADMIN_USER_LIST = _Paths.ADMIN_USER_LIST;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const LOGIN = '/login';
  static const SIGNUP = '/signup';
  static const MAIN_NAVIGATION = '/main-navigation';
  static const CATEGORIES = '/categories';
  static const CATEGORY_PRODUCTS = '/category-products';
  static const PRODUCT_DETAIL = '/product-detail';
  static const SEARCH = '/search';
  static const ACCOUNT = '/account';
  static const CHAT = '/chat';
  static const CART = '/cart';
  static const CHECKOUT = '/checkout';
  static const PAYMENT_STATUS = '/payment-status';
  static const WISHLIST = '/wishlist';

  // Settings
  static const SETTINGS = '/settings';

  // Account Sub Routes
  static const EDIT_PROFILE = '/account/edit-profile';
  static const ORDER_HISTORY = '/account/order-history';
  static const SHIPPING_ADDRESS = '/account/shipping-address';
  static const MAP_PICKER = '/account/map-picker';
  static const NOTIFICATION_SETTINGS = '/account/notification-settings';
  static const HELP_CENTER = '/account/help-center';
  static const PRIVACY_POLICY = '/account/privacy-policy';

  // Admin
  static const ADMIN_HOME = '/admin/admin_home';
  static const ADMIN_CHAT_LIST = '/admin/admin_chat_list';
  static const ADMIN_CHAT_DETAIL = '/admin/admin_chat_detail';
  static const ADMIN_PRODUCT_LIST = '/admin/admin_product_list';
  static const ADMIN_PRODUCT_FORM = '/admin/admin_product_form';
  static const ADMIN_USER_LIST = '/admin/admin_user_list';
}

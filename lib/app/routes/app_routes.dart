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
  
  // Account Sub Routes
  static const EDIT_PROFILE = _Paths.EDIT_PROFILE;
  static const ORDER_HISTORY = _Paths.ORDER_HISTORY;
  static const SHIPPING_ADDRESS = _Paths.SHIPPING_ADDRESS;
  static const NOTIFICATION_SETTINGS = _Paths.NOTIFICATION_SETTINGS;
  static const HELP_CENTER = _Paths.HELP_CENTER;
  static const PRIVACY_POLICY = _Paths.PRIVACY_POLICY;
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
  
  // Account Sub Routes
  static const EDIT_PROFILE = '/account/edit-profile';
  static const ORDER_HISTORY = '/account/order-history';
  static const SHIPPING_ADDRESS = '/account/shipping-address';
  static const NOTIFICATION_SETTINGS = '/account/notification-settings';
  static const HELP_CENTER = '/account/help-center';
  static const PRIVACY_POLICY = '/account/privacy-policy';
}
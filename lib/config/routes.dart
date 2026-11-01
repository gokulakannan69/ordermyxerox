import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/shop_registration_screen.dart';
import '../screens/services/services_screen.dart';
import '../screens/upload/upload_screen.dart';
import '../screens/shops/shops_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/checkout/checkout_screen.dart';
import '../screens/orders/orders_screen.dart';
import '../screens/orders/order_tracking_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/categories/categories_screen.dart';
import '../screens/xerox/xerox_order_flow.dart';
import '../screens/admin/manage_users_screen.dart';
import '../screens/admin/banner_manager_screen.dart';
import '../screens/admin/coupon_codes_screen.dart';
import '../screens/admin/xerox_setup_screen.dart';

import '../screens/admin/support_queries_screen.dart';

import '../screens/admin/product_requests_screen.dart';
import '../screens/admin/manage_products_screen.dart';
import '../screens/admin/cloud_services_screen.dart';
import '../screens/admin/admin_master_overview_screen.dart';
import '../screens/admin/all_orders_transactions_screen.dart';
import '../screens/admin/manage_xerox_shops_screen.dart';
import '../screens/admin/wallet_payout_screen.dart';
import '../screens/delivery/delivery_dashboard_screen.dart';
import '../screens/shop_owner/shop_dashboard_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String services = '/services';
  static const String upload = '/upload';
  static const String shops = '/shops';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orders = '/orders';
  static const String orderTracking = '/order-tracking';
  static const String profile = '/profile';
  static const String categories = '/categories';
  static const String xeroxOrder = '/xerox-order';

  static const String manageUsers = '/admin/users';
  static const String bannerManager = '/admin/banners';
  static const String couponCodes = '/admin/coupons';
  static const String xeroxSetup = '/admin/setup';
  static const String supportQueries = '/admin/support';
  static const String productRequests = '/admin/product-requests';
  static const String manageProducts = '/admin/products';
  static const String cloudServices = '/admin/cloud-services';

  static const String adminOverview = '/admin/overview';
  static const String adminOrders = '/admin/orders';
  static const String adminShops = '/admin/shops';
  static const String adminWallet = '/admin/wallet';

  static const String deliveryDashboard = '/delivery/dashboard';
  static const String shopDashboard = '/shop/dashboard';
  static const String shopRegistration = '/auth/shop-registration';

  static Map<String, WidgetBuilder> get routes => {
        login: (context) => const LoginScreen(),
        shopRegistration: (context) => const ShopRegistrationScreen(),
        home: (context) => const HomeScreen(),
        services: (context) => const ServicesScreen(),
        upload: (context) => const UploadScreen(),
        shops: (context) => const ShopsScreen(),
        cart: (context) => const CartScreen(),
        checkout: (context) => const CheckoutScreen(),
        orders: (context) => const OrdersScreen(),
        orderTracking: (context) => const OrderTrackingScreen(),
        profile: (context) => const ProfileScreen(),
        categories: (context) => const CategoriesScreen(),
        xeroxOrder: (context) => const XeroxOrderFlow(),
        manageUsers: (context) => const ManageUsersScreen(),
        bannerManager: (context) => const BannerManagerScreen(),
        couponCodes: (context) => const CouponCodesScreen(),
        xeroxSetup: (context) => const XeroxSetupScreen(),
        supportQueries: (context) => const SupportQueriesScreen(),
        productRequests: (context) => const ProductRequestsScreen(),
        manageProducts: (context) => const ManageProductsScreen(),
        cloudServices: (context) => const CloudServicesScreen(),
        adminOverview: (context) => const AdminMasterOverviewScreen(),
        adminOrders: (context) => const AllOrdersTransactionsScreen(),
        adminShops: (context) => const ManageXeroxShopsScreen(),
        adminWallet: (context) => const WalletPayoutScreen(),
        deliveryDashboard: (context) => const DeliveryDashboardScreen(),
        shopDashboard: (context) => const ShopDashboardScreen(),
      };
}

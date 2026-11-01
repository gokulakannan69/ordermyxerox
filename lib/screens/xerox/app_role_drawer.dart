import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/role_manager.dart';
import '../home/home_screen.dart';
import '../../widgets/brand_text.dart';
import '../../config/theme.dart';

class AppRoleDrawer extends StatefulWidget {
  const AppRoleDrawer({super.key});

  @override
  State<AppRoleDrawer> createState() => _AppRoleDrawerState();
}

class _AppRoleDrawerState extends State<AppRoleDrawer> {
  final RoleManager _roleManager = RoleManager();

  // ── Corporate Drawer Color Palette ──────────────────────────
  Color get _bgDark => Colors.white;
  Color get _headerBg => Colors.white;
  Color get _borderDark => Colors.grey.shade200;
  Color get _textWhite => Colors.black87;
  Color get _textMuted => Colors.grey.shade600;
  Color get _iconRed => AppColors.primary;
  Color get _accentRed => AppColors.primary;

  @override
  void initState() {
    super.initState();
    _roleManager.addListener(_onRoleChanged);
  }

  @override
  void dispose() {
    _roleManager.removeListener(_onRoleChanged);
    super.dispose();
  }

  void _onRoleChanged() {
    if (mounted) setState(() {});
  }

  void _navigate(String route, {String? label}) {
    Navigator.of(context).pop(); // Close drawer
    if (route == '/home') {
      HomeScreen.needsRefresh = true;
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    } else if (route.isNotEmpty) {
      Navigator.of(context).pushNamed(route);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            label != null ? '$label section opened' : 'Feature available soon',
            style: GoogleFonts.poppins(fontSize: 12),
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 1500),
        ),
      );
    }
  }

  Color _getRoleBadgeColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return const Color(0xFFDC2626); // Strong red
      case UserRole.seller:
        return const Color(0xFFD97706); // Amber
      case UserRole.employee:
        return const Color(0xFF0284C7); // Sky blue
      case UserRole.customer:
        return const Color(0xFF10B981); // Emerald
    }
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Icons.admin_panel_settings_rounded;
      case UserRole.seller:
        return Icons.store_rounded;
      case UserRole.employee:
        return Icons.badge_rounded;
      case UserRole.customer:
        return Icons.person_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = _roleManager.currentRole;
    final loggedInUser = _roleManager.loggedInUser;
    final badgeColor = _getRoleBadgeColor(role);

    return Drawer(
      backgroundColor: _bgDark,
      child: SafeArea(
        child: Column(
          children: [
            // ── Drawer Header: App Brand + Active User + Role Switcher ──
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
              decoration: BoxDecoration(
                color: _headerBg,
                border: Border(
                  bottom: BorderSide(color: _borderDark, width: 1.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Brand Row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/app_logo.png',
                          height: 28,
                          fit: BoxFit.contain,
                          errorBuilder: (ctx, err, st) => Icon(
                            Icons.print_rounded,
                            size: 24,
                            color: _accentRed,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BrandText(fontSize: 16, compact: true),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close_rounded,
                            color: _textWhite.withValues(alpha: 0.7), size: 22),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // User Info Card with Role Badge
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _bgDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _borderDark),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor:
                                  badgeColor.withValues(alpha: 0.2),
                              child: Icon(_getRoleIcon(role),
                                  size: 18, color: badgeColor),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    loggedInUser,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: _textWhite,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white.withValues(alpha: 0.05)
                                          : const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.email_rounded,
                                          size: 10,
                                          color: _textMuted,
                                        ),
                                        const SizedBox(width: 4),
                                        Flexible(
                                          child: Text(
                                            _roleManager.loggedInEmail,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                              color: _textMuted,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // The role switcher has been removed as requested.
                  // Menus will now dynamically render based on RoleManager().currentRole.
                ],
              ),
            ),

            // ── Scrollable Menu List based on Role ──
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                children: [
                  // 1. ADMIN ACCESS Section (Always prominently on top when Admin is selected)
                  if (role == UserRole.admin) ...[
                    _buildSectionHeader(
                      'ADMIN DASHBOARD & CONTROLS',
                      badge: 'FULL ACCESS',
                      badgeColor: const Color(0xFFDC2626),
                      textColor: const Color(0xFFFCA5A5),
                    ),
                    _buildMenuItem(
                      icon: Icons.dashboard_customize_rounded,
                      title: 'Admin Master Overview',
                      subtitle: 'Live traffic, revenue & system metrics',
                      iconColor: const Color(0xFFF87171),
                      onTap: () => _navigate('/admin/overview',
                          label: 'Admin Master Overview'),
                    ),
                    _buildMenuItem(
                      icon: Icons.assignment_rounded,
                      title: 'All Orders & Transactions',
                      subtitle: 'Live print jobs across regions',
                      iconColor: const Color(0xFFF87171),
                      onTap: () => _navigate('/admin/orders',
                          label: 'All Orders & Transactions'),
                    ),
                    _buildMenuItem(
                      icon: Icons.inventory_rounded,
                      title: 'Product Requests',
                      subtitle: 'Review customer item requests',
                      iconColor: const Color(0xFFF87171),
                      onTap: () => _navigate('/admin/product-requests',
                          label: 'Product Requests'),
                    ),
                    _buildMenuItem(
                      icon: Icons.store_rounded,
                      title: 'Manage Xerox Shops',
                      subtitle: 'Verify, onboard & control shops',
                      iconColor: const Color(0xFFF87171),
                      onTap: () => _navigate('/admin/shops',
                          label: 'Manage Xerox Shops'),
                    ),
                    _buildMenuItem(
                      icon: Icons.groups_rounded,
                      title: 'Manage Users & Roles',
                      subtitle: 'Customers, shops & staff permissions',
                      iconColor: const Color(0xFFF87171),
                      onTap: () => _navigate('/admin/users',
                          label: 'Manage Users & Roles'),
                    ),
                    _buildMenuItem(
                      icon: Icons.image_rounded,
                      title: 'Banner Manager',
                      subtitle: 'Storefront media & category images',
                      iconColor: const Color(0xFFF87171),
                      onTap: () =>
                          _navigate('/admin/banners', label: 'Banner Manager'),
                    ),
                    _buildMenuItem(
                      icon: Icons.confirmation_number_rounded,
                      title: 'Discount Coupons & Offers',
                      subtitle: 'Create promo codes & student deals',
                      iconColor: const Color(0xFFF87171),
                      onTap: () => _navigate('/admin/coupons',
                          label: 'Coupons & Offers'),
                    ),
                    _buildMenuItem(
                      icon: Icons.account_balance_wallet_rounded,
                      title: 'Wallet & Payout Gateway',
                      subtitle: 'Razorpay, UPI & commission fees',
                      iconColor: const Color(0xFFF87171),
                      onTap: () => _navigate('/admin/wallet',
                          label: 'Wallet & Payout Gateway'),
                    ),
                    _buildMenuItem(
                      icon: Icons.headset_mic_rounded,
                      title: 'Support Queries',
                      subtitle: 'Manage tickets, bugs & cancellations',
                      iconColor: const Color(0xFFF87171),
                      onTap: () =>
                          _navigate('/admin/support', label: 'Support Queries'),
                    ),
                    _buildMenuItem(
                      icon: Icons.settings_suggest_rounded,
                      title: 'Xerox Setup & Pricing',
                      subtitle: 'Paper size, color rates, spiral binding',
                      iconColor: const Color(0xFFF87171),
                      onTap: () => _navigate('/admin/setup',
                          label: 'Xerox Engine Config'),
                    ),
                    _buildMenuItem(
                      icon: Icons.cloud_done_rounded,
                      title: 'Cloud Services & Storage',
                      subtitle: 'Server status & database health',
                      iconColor: const Color(0xFFF87171),
                      onTap: () => _navigate('/admin/cloud-services',
                          label: 'Cloud Services & Storage'),
                    ),
                    const SizedBox(height: 8),
                    _buildDivider(),
                  ],

                  // 2. SHOP Section (Visible to Customer & Admin)
                  if (role == UserRole.customer || role == UserRole.admin) ...[
                    _buildSectionHeader('SHOP & SERVICES'),
                    _buildMenuItem(
                      icon: Icons.home_rounded,
                      title: 'Home',
                      onTap: () => _navigate('/home', label: 'Home'),
                    ),
                    _buildMenuItem(
                      icon: Icons.print_rounded,
                      title: 'Order My Xerox',
                      onTap: () =>
                          _navigate('/xerox-order', label: 'Order My Xerox'),
                    ),
                    _buildMenuItem(
                      icon: Icons.storefront_rounded,
                      title: 'Partner with us as a Xerox Shop',
                      subtitle: 'Register your shop and start earning',
                      iconColor: const Color(0xFFD97706),
                      onTap: () => _navigate('/auth/shop-registration'),
                    ),
                    const SizedBox(height: 8),
                  ],

                  // 3. XEROX SHOP ACCESS Section (Visible to Xerox Shop & Admin)
                  if (role == UserRole.seller || role == UserRole.admin) ...[
                    _buildDivider(),
                    _buildSectionHeader(
                      'XEROX SHOP PARTNER',
                      badge: 'STORE ADMIN',
                      badgeColor: const Color(0xFFD97706),
                      textColor: const Color(0xFFFCD34D),
                    ),
                    _buildMenuItem(
                      icon: Icons.storefront_rounded,
                      title: 'Shop Orders & Live Queue',
                      subtitle: 'Pending print jobs from nearby users',
                      onTap: () => _navigate('/shop/dashboard',
                          label: 'Shop Orders & Live Queue'),
                    ),
                    const SizedBox(height: 8),
                  ],

                  // 4. EMPLOYEE ACCESS Section (Visible to Employee & Admin)
                  if (role == UserRole.employee || role == UserRole.admin) ...[
                    _buildDivider(),
                    _buildSectionHeader(
                      'EMPLOYEE DISPATCH ACCESS',
                      badge: 'STAFF',
                      badgeColor: const Color(0xFF0284C7),
                      textColor: const Color(0xFF7DD3FC),
                    ),
                    _buildMenuItem(
                      icon: Icons.two_wheeler_rounded,
                      title: 'Delivery Orders Queue',
                      subtitle: 'Pickup from shop & campus drop',
                      iconColor: const Color(0xFF38BDF8),
                      onTap: () => _navigate('/delivery/dashboard',
                          label: 'Delivery Orders Queue'),
                    ),
                    const SizedBox(height: 8),
                  ],

                  // 5. ACCOUNT Section (Customer & Common)
                  if (role == UserRole.customer || role == UserRole.admin) ...[
                    _buildDivider(),
                    _buildSectionHeader('ACCOUNT & PREFERENCES'),
                    _buildMenuItem(
                      icon: Icons.inventory_2_rounded,
                      title: 'My Orders',
                      onTap: () => _navigate('/orders', label: 'My Orders'),
                    ),
                    _buildMenuItem(
                      icon: Icons.shopping_cart_rounded,
                      title: 'Cart',
                      onTap: () => _navigate('/cart', label: 'Cart'),
                    ),
                  ],

                  // Profile is available to EVERYONE
                  if (role != UserRole.customer && role != UserRole.admin) ...[
                    _buildDivider(),
                    _buildSectionHeader('ACCOUNT & PREFERENCES'),
                  ],
                  _buildMenuItem(
                    icon: Icons.person_rounded,
                    title: 'Profile & Account Settings',
                    onTap: () => _navigate('/profile', label: 'Profile'),
                  ),
                  const SizedBox(height: 8),

                  // ── Logout Item at bottom ──
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.logout_rounded,
                    title: 'Sign Out / Switch Account',
                    subtitle: 'Current: ${_roleManager.loggedInEmail}',
                    iconColor: const Color(0xFFF87171),
                    onTap: () async {
                      Navigator.of(context).pop();
                      await Supabase.instance.client.auth.signOut();
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/login', (route) => false);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    String title, {
    String? badge,
    Color? badgeColor,
    Color? textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 12, bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: textColor ?? const Color(0xFF94A3B8),
                letterSpacing: 0.6,
              ),
            ),
          ),
          if (badge != null) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: (badgeColor ?? _iconRed).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: (badgeColor ?? _iconRed).withValues(alpha: 0.4),
                ),
              ),
              child: Text(
                badge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w700,
                  color: badgeColor ?? _iconRed,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Divider(
        color: _borderDark,
        thickness: 1,
        height: 1,
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        splashColor: AppColors.primary.withValues(alpha: 0.1),
        hoverColor: Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: (iconColor ?? _iconRed).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: iconColor ?? _iconRed,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _textWhite,
                        letterSpacing: -0.1,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 1),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: _textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

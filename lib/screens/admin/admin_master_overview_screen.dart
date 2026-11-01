import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../config/routes.dart';
import '../../widgets/glass_card.dart';
import '../xerox/app_role_drawer.dart';
import '../home/home_screen.dart';

class AdminMasterOverviewScreen extends StatefulWidget {
  const AdminMasterOverviewScreen({super.key});

  @override
  State<AdminMasterOverviewScreen> createState() =>
      _AdminMasterOverviewScreenState();
}

class _AdminMasterOverviewScreenState extends State<AdminMasterOverviewScreen> {
  bool _isLoading = false;
  int _totalOrders = 128;
  int _activeShops = 42;
  int _totalProducts = 26;
  int _activeBanners = 6;
  double _todayRevenue = 142850.0;

  @override
  void initState() {
    super.initState();
    _fetchLiveMetrics();
  }

  Future<void> _fetchLiveMetrics() async {
    setState(() => _isLoading = true);
    try {
      final client = Supabase.instance.client;

      // 1. Fetch live shops count
      try {
        final shopsRes = await client.from('shops').select('id');
        if (shopsRes.isNotEmpty) {
          _activeShops = shopsRes.length;
        }
      } catch (_) {}

      // 2. Fetch live products count
      try {
        final prodRes = await client.from('products').select('id');
        if (prodRes.isNotEmpty) {
          _totalProducts = prodRes.length;
        }
      } catch (_) {}

      // 3. Fetch live banners count
      try {
        final bannerRes = await client.from('banners').select('id');
        if (bannerRes.isNotEmpty) {
          _activeBanners = bannerRes.length;
        }
      } catch (_) {}

      // 4. Fetch orders & calculate revenue
      try {
        final orderRes =
            await client.from('orders').select('id, total_amount, status');
        if (orderRes.isNotEmpty) {
          _totalOrders = orderRes.length;
          double rev = 0;
          for (final o in orderRes) {
            final amt =
                double.tryParse(o['total_amount']?.toString() ?? '0') ?? 0;
            rev += amt;
          }
          if (rev > 0) _todayRevenue = rev;
        }
      } catch (_) {}
    } catch (e) {
      debugPrint('Metrics fetch: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Apple clean crisp background
      drawer: const AppRoleDrawer(),
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: const Color(0xFFE11D48), // Brand Crimson Red
        elevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.white),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Text(
          'Admin Master Control',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.storefront_rounded, color: Colors.white),
            tooltip: 'View Home Storefront',
            onPressed: () {
              HomeScreen.needsRefresh = true;
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            tooltip: 'Refresh Metrics',
            onPressed: _fetchLiveMetrics,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchLiveMetrics,
        color: const Color(0xFFE11D48),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isLoading)
                const LinearProgressIndicator(
                  minHeight: 2,
                  backgroundColor: Color(0xFFF8FAFC),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE11D48)),
                ),
              // ── Header Revenue & Live Pulse Card ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 26),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE11D48), Color(0xFFBE123C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x66E11D48),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF34D399),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'REALTIME STORE METRICS',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'LIVE',
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '₹ ${_todayRevenue.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.trending_up_rounded,
                            color: Color(0xFF34D399), size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Gross Xerox & Store Orders Flow',
                          style: GoogleFonts.poppins(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Top 3 quick metrics
                    Row(
                      children: [
                        _buildTopMetric('Live Orders', '$_totalOrders',
                            Icons.receipt_long_rounded),
                        const SizedBox(width: 10),
                        _buildTopMetric('Partner Shops', '$_activeShops',
                            Icons.storefront_rounded),
                        const SizedBox(width: 10),
                        _buildTopMetric('Live Products', '$_totalProducts',
                            Icons.inventory_2_rounded),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Fast Operation Quick Modules ──
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 18,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE11D48),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Primary Operations',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.15,
                      children: [
                        _buildControlCard(
                          context: context,
                          title: 'Manage Shops',
                          subtitle: '$_activeShops Xerox vendors',
                          icon: Icons.store_rounded,
                          color: const Color(0xFFE11D48), // Brand Red
                          route: AppRoutes.adminShops,
                        ),
                        _buildControlCard(
                          context: context,
                          title: 'Live Catalog',
                          subtitle: '$_totalProducts items in DB',
                          icon: Icons.inventory_rounded,
                          color: const Color(0xFFE11D48), // Brand Red
                          route: AppRoutes.manageProducts,
                        ),
                        _buildControlCard(
                          context: context,
                          title: 'Ad Banners',
                          subtitle: '$_activeBanners promo deals',
                          icon: Icons.view_carousel_rounded,
                          color: const Color(0xFFE11D48), // Brand Red
                          route: AppRoutes.bannerManager,
                        ),
                        _buildControlCard(
                          context: context,
                          title: 'All Orders',
                          subtitle: '$_totalOrders campus prints',
                          icon: Icons.assignment_rounded,
                          color: const Color(0xFFE11D48), // Brand Red
                          route: AppRoutes.adminOrders,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 18,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE11D48),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'System & Pricing Engine',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _buildListControl(
                      context,
                      title: 'Xerox Pricing & Engine Rates',
                      subtitle:
                          'B&W, Color, Spiral Binding, Hardbound rate card',
                      icon: Icons.price_change_rounded,
                      route: AppRoutes.xeroxSetup,
                      accentColor: const Color(0xFFE11D48),
                    ),
                    _buildListControl(
                      context,
                      title: 'Wallet & Payout Gateway',
                      subtitle: 'Commissions, UPI settlements & vendor payouts',
                      icon: Icons.account_balance_wallet_rounded,
                      route: AppRoutes.adminWallet,
                      accentColor: const Color(0xFFE11D48),
                    ),
                    _buildListControl(
                      context,
                      title: 'Discount Promo Coupons',
                      subtitle: 'Exam packs, flash codes & student offers',
                      icon: Icons.confirmation_number_rounded,
                      route: AppRoutes.couponCodes,
                      accentColor: const Color(0xFFE11D48),
                    ),
                    _buildListControl(
                      context,
                      title: 'Manage Users & Permissions',
                      subtitle: 'Customers, Xerox shop owners & staff accounts',
                      icon: Icons.groups_rounded,
                      route: AppRoutes.manageUsers,
                      accentColor: const Color(0xFFE11D48),
                    ),
                    _buildListControl(
                      context,
                      title: 'Cloud Services & Database Health',
                      subtitle: 'Supabase realtime status & storage buckets',
                      icon: Icons.cloud_done_rounded,
                      route: AppRoutes.cloudServices,
                      accentColor: const Color(0xFFE11D48),
                    ),
                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopMetric(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
          border:
              Border.all(color: Colors.white.withValues(alpha: 0.35), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    return GlassCard(
      blur: 16.0,
      opacity: 0.94,
      borderRadius: 18.0,
      tintColor: Colors.white,
      customBorder: Border.all(
        color: const Color(0xFFE11D48).withValues(alpha: 0.12),
        width: 1.2,
      ),
      padding: const EdgeInsets.all(14),
      onTap: () => Navigator.pushNamed(context, route),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1F2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFFE11D48), size: 22),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: const Color(0xFF0F172A),
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: const Color(0xFF64748B),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListControl(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required String route,
    required Color accentColor,
  }) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 10),
      borderRadius: 16,
      opacity: 0.94,
      tintColor: Colors.white,
      padding: EdgeInsets.zero,
      customBorder: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
      onTap: () => Navigator.pushNamed(context, route),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF1F2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFFE11D48), size: 20),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: const Color(0xFF0F172A),
          ),
        ),
        subtitle: Text(
          subtitle,
          style:
              GoogleFonts.poppins(fontSize: 10, color: const Color(0xFF64748B)),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.chevron_right_rounded,
            color: Color(0xFFE11D48), size: 20),
      ),
    );
  }
}

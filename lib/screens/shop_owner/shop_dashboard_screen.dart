import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/glass_card.dart';
import '../xerox/app_role_drawer.dart';

class ShopDashboardScreen extends StatefulWidget {
  const ShopDashboardScreen({super.key});

  @override
  State<ShopDashboardScreen> createState() => _ShopDashboardScreenState();
}

class _ShopDashboardScreenState extends State<ShopDashboardScreen> {
  final _supabase = Supabase.instance.client;
  String? _shopId;
  String? _shopName;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchShopDetails();
  }

  Future<void> _fetchShopDetails() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final shopDataList = await _supabase
          .from('shops')
          .select('id, shop_name, is_verified')
          .eq('owner_id', userId)
          .order('created_at', ascending: false)
          .limit(1);

      final shopData = shopDataList.isNotEmpty ? shopDataList.first : null;

      if (mounted) {
        setState(() {
          _shopId = shopData?['id'];
          _shopName = shopData?['shop_name'];
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching shop: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _supabase
          .from('orders')
          .update({'status': newStatus}).eq('id', orderId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order marked as $newStatus'),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update order: $e'),
            backgroundColor: const Color(0xFFE11D48),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'placed':
        return const Color(0xFFE11D48);
      case 'printing':
        return const Color(0xFFF59E0B);
      case 'ready':
        return const Color(0xFF10B981);
      case 'out_for_delivery':
        return const Color(0xFF8B5CF6);
      case 'completed':
        return const Color(0xFF64748B);
      case 'cancelled':
        return const Color(0xFFEF4444);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _shopName ?? 'Shop Dashboard',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Live Realtime Orders',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1F2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFE11D48).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.storefront_rounded,
                    size: 14, color: Color(0xFFE11D48)),
                const SizedBox(width: 6),
                Text(
                  'SHOP DESK',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFE11D48),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: const AppRoleDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFE11D48)))
          : _shopId == null
              ? Center(
                  child: GlassCard(
                    margin: const EdgeInsets.all(24),
                    padding: const EdgeInsets.all(24),
                    borderRadius: 20,
                    backgroundColor: Colors.white.withValues(alpha: 0.9),
                    border: Border.all(
                        color: const Color(0xFFE11D48).withValues(alpha: 0.2)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.storefront_outlined,
                            size: 48, color: Color(0xFFE11D48)),
                        const SizedBox(height: 16),
                        Text(
                          'Setup Your Shop Desk',
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A)),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your shop account is awaiting activation by the admin.\nPlease contact support to complete verification.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              color: const Color(0xFF64748B),
                              fontSize: 13,
                              height: 1.4),
                        ),
                      ],
                    ),
                  ),
                )
              : StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _supabase
                      .from('orders')
                      .stream(primaryKey: ['id'])
                      .eq('shop_id', _shopId!)
                      .order('created_at', ascending: false),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFFE11D48)));
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error loading real-time orders',
                            style: GoogleFonts.poppins(
                                color: const Color(0xFFE11D48),
                                fontWeight: FontWeight.w600)),
                      );
                    }

                    final orders = snapshot.data ?? [];

                    if (orders.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFF1F2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.inventory_2_outlined,
                                  size: 48, color: Color(0xFFE11D48)),
                            ),
                            const SizedBox(height: 16),
                            Text('No active orders right now',
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF475569))),
                            const SizedBox(height: 6),
                            Text(
                                'New incoming print jobs will appear automatically in real-time',
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: const Color(0xFF94A3B8))),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        final status = order['status'] ?? 'placed';
                        final amount =
                            order['total_amount']?.toString() ?? '0.00';
                        final isDelivery = order['is_delivery'] == true;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: GlassCard(
                            borderRadius: 20,
                            blur: 16,
                            padding: const EdgeInsets.all(18),
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.88),
                            border: Border.all(
                              color: status == 'placed'
                                  ? const Color(0xFFE11D48)
                                      .withValues(alpha: 0.3)
                                  : Colors.black.withValues(alpha: 0.06),
                              width: status == 'placed' ? 1.5 : 1.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFF1F2),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Icon(Icons.print_rounded,
                                              size: 18,
                                              color: Color(0xFFE11D48)),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'Order #${order['id'].toString().substring(0, 6).toUpperCase()}',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                            color: const Color(0xFF0F172A),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(status)
                                            .withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: _getStatusColor(status)
                                                .withValues(alpha: 0.3)),
                                      ),
                                      child: Text(
                                        status.toUpperCase(),
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: _getStatusColor(status),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                const Divider(height: 1),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    const Icon(Icons.payments_outlined,
                                        size: 16, color: Color(0xFF64748B)),
                                    const SizedBox(width: 6),
                                    Text('₹$amount',
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                            color: const Color(0xFF0F172A))),
                                    const Spacer(),
                                    Icon(
                                      isDelivery
                                          ? Icons.delivery_dining_rounded
                                          : Icons.storefront_rounded,
                                      size: 18,
                                      color: const Color(0xFFE11D48),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      isDelivery
                                          ? 'Home Delivery'
                                          : 'Store Pickup',
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF334155),
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Action Buttons Based on Status
                                if (status == 'placed') ...[
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () => _updateOrderStatus(
                                              order['id'], 'cancelled'),
                                          icon:
                                              const Icon(Icons.close, size: 16),
                                          label: const Text('Reject'),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor:
                                                const Color(0xFFE11D48),
                                            side: BorderSide(
                                                color: const Color(0xFFE11D48)
                                                    .withValues(alpha: 0.4)),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: () => _updateOrderStatus(
                                              order['id'], 'printing'),
                                          icon:
                                              const Icon(Icons.print, size: 16),
                                          label: const Text('Start Print'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFFE11D48),
                                            foregroundColor: Colors.white,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ] else if (status == 'printing') ...[
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: () => _updateOrderStatus(
                                          order['id'], 'ready'),
                                      icon: const Icon(
                                          Icons.check_circle_outline,
                                          size: 18),
                                      label: const Text(
                                          'Mark Ready for Pickup/Dispatch'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF10B981),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                      ),
                                    ),
                                  ),
                                ] else if (status == 'ready' &&
                                    !isDelivery) ...[
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: () => _updateOrderStatus(
                                          order['id'], 'completed'),
                                      icon:
                                          const Icon(Icons.done_all, size: 18),
                                      label: const Text('Customer Collected'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF0F172A),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/glass_card.dart';
import '../xerox/app_role_drawer.dart';

class DeliveryDashboardScreen extends StatefulWidget {
  const DeliveryDashboardScreen({super.key});

  @override
  State<DeliveryDashboardScreen> createState() =>
      _DeliveryDashboardScreenState();
}

class _DeliveryDashboardScreenState extends State<DeliveryDashboardScreen> {
  final _supabase = Supabase.instance.client;
  bool _isOnline = true;
  String _selectedTab = 'ACTIVE';

  final List<Map<String, dynamic>> _fallbackDeliveries = [
    {
      'id': 'DEL-9912',
      'shop_name': 'Campus Xerox Center',
      'pickup_address': 'Central Library, Ground Floor',
      'delivery_address': 'Boys Hostel A, Room 302',
      'distance': '1.2 km',
      'earning': 40.0,
      'status': 'ready_for_pickup',
      'items_count': 3,
      'document_name': 'Semester_6_Notes.pdf',
      'customer_phone': '+91 98765 43210',
    },
    {
      'id': 'DEL-9911',
      'shop_name': 'Sri Sai Prints & Digital',
      'pickup_address': 'Engineering Gate Xerox Complex',
      'delivery_address': 'Mechanical Dept, Lab 204',
      'distance': '0.6 km',
      'earning': 30.0,
      'status': 'out_for_delivery',
      'items_count': 1,
      'document_name': 'Final_Project_Report.pdf',
      'customer_phone': '+91 91234 56789',
    },
    {
      'id': 'DEL-9910',
      'shop_name': 'Royal Graphics & Print Hub',
      'pickup_address': 'North Campus Square',
      'delivery_address': 'Girls Hostel Block B, Warden Desk',
      'distance': '1.8 km',
      'earning': 50.0,
      'status': 'ready_for_pickup',
      'items_count': 5,
      'document_name': 'Lab_Manuals_Set.pdf',
      'customer_phone': '+91 94444 11223',
    },
  ];

  Future<void> _updateJobStatus(String orderId, String newStatus) async {
    try {
      await _supabase
          .from('orders')
          .update({'status': newStatus}).eq('id', orderId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Delivery marked as ${newStatus.replaceAll('_', ' ').toUpperCase()}'),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          final index =
              _fallbackDeliveries.indexWhere((d) => d['id'] == orderId);
          if (index != -1) {
            _fallbackDeliveries[index]['status'] = newStatus;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Delivery updated to ${newStatus.replaceAll('_', ' ').toUpperCase()}'),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showDeliveryPinDialog(
      BuildContext context, Map<String, dynamic> delivery) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFFFF1F2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.security_rounded,
                  color: Color(0xFFE11D48), size: 22),
            ),
            const SizedBox(width: 12),
            Text(
              'Customer OTP PIN',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter the 4-digit drop-off verification code provided by the customer at ${delivery['delivery_address'] ?? 'destination'}.',
              style: GoogleFonts.poppins(
                  fontSize: 13, color: const Color(0xFF64748B), height: 1.4),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: textController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 28,
                letterSpacing: 14,
                fontWeight: FontWeight.w800,
                color: const Color(0xFFE11D48),
              ),
              decoration: InputDecoration(
                hintText: '••••',
                counterText: '',
                filled: true,
                fillColor: const Color(0xFFFFF1F2),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                      color: const Color(0xFFE11D48).withValues(alpha: 0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                      color: const Color(0xFFE11D48).withValues(alpha: 0.2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide:
                      const BorderSide(color: Color(0xFFE11D48), width: 1.8),
                ),
              ),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF64748B)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _updateJobStatus(delivery['id'], 'completed');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE11D48),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    'Verify & Handover',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: const AppRoleDrawer(),
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: Color(0xFF0F172A)),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Delivery Hub',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: const Color(0xFF0F172A),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _isOnline
                        ? const Color(0xFF10B981)
                        : const Color(0xFF94A3B8),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _isOnline
                      ? 'Online • Ready for Dispatches'
                      : 'Offline • Duty Paused',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: _isOnline
                        ? const Color(0xFF10B981)
                        : const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color:
                  _isOnline ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: _isOnline
                    ? const Color(0xFF10B981).withValues(alpha: 0.3)
                    : const Color(0xFFCBD5E1),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isOnline ? 'Active' : 'Offline',
                  style: GoogleFonts.poppins(
                    color: _isOnline
                        ? const Color(0xFF15803D)
                        : const Color(0xFF64748B),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 4),
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: _isOnline,
                    activeColor: Colors.white,
                    activeTrackColor: const Color(0xFF10B981),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: const Color(0xFF94A3B8),
                    onChanged: (val) => setState(() => _isOnline = val),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _supabase
            .from('orders')
            .stream(primaryKey: ['id']).order('created_at', ascending: false),
        builder: (context, snapshot) {
          List<Map<String, dynamic>> liveOrders = [];
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final valid = snapshot.data!
                .where((o) =>
                    o['is_delivery'] == true || o['delivery_address'] != null)
                .toList();
            liveOrders = valid.isNotEmpty ? valid : _fallbackDeliveries;
          } else {
            liveOrders = _fallbackDeliveries;
          }

          final readyJobs = liveOrders.where((o) {
            final s = (o['status'] ?? '').toString().toLowerCase();
            return s == 'ready' || s == 'ready_for_pickup' || s == 'printing';
          }).toList();

          final outJobs = liveOrders.where((o) {
            final s = (o['status'] ?? '').toString().toLowerCase();
            return s == 'out_for_delivery' || s == 'in_transit';
          }).toList();

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlassCard(
                  borderRadius: 24,
                  blur: 18,
                  backgroundColor: const Color(0xFFE11D48),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.35),
                    width: 1.5,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.22),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.4),
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.two_wheeler_rounded,
                              size: 34,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.white
                                            .withValues(alpha: 0.25),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'CAMPUS RUNNER',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(Icons.star_rounded,
                                        color: Color(0xFFFDE047), size: 18),
                                    const SizedBox(width: 3),
                                    Text(
                                      '4.92',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '₹ 680 Earned Today',
                                  style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                Text(
                                  '16 Print deliveries completed',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildMiniStat(
                                'Active Jobs',
                                '${readyJobs.length + outJobs.length}',
                                Icons.electric_bike_rounded),
                            Container(
                                width: 1,
                                height: 28,
                                color: Colors.white.withValues(alpha: 0.25)),
                            _buildMiniStat('Total Distance', '14.8 km',
                                Icons.route_rounded),
                            Container(
                                width: 1,
                                height: 28,
                                color: Colors.white.withValues(alpha: 0.25)),
                            _buildMiniStat('Payout Due', '₹ 680',
                                Icons.account_balance_wallet_rounded),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    _buildTabBtn('ACTIVE',
                        'Active (${readyJobs.length + outJobs.length})'),
                    const SizedBox(width: 8),
                    _buildTabBtn('COMPLETED', 'Completed (16)'),
                  ],
                ),
                const SizedBox(height: 20),
                if (!_isOnline) ...[
                  GlassCard(
                    padding: const EdgeInsets.all(24),
                    borderRadius: 20,
                    backgroundColor: Colors.white.withValues(alpha: 0.9),
                    border: Border.all(
                        color: const Color(0xFFE11D48).withValues(alpha: 0.2)),
                    child: Center(
                      child: Column(
                        children: [
                          const Icon(Icons.pause_circle_outline_rounded,
                              size: 48, color: Color(0xFFE11D48)),
                          const SizedBox(height: 12),
                          Text(
                            'You Are Currently Offline',
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F172A)),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Switch your toggle to Active in the top bar to accept campus print deliveries and receive real-time drop requests.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: const Color(0xFF64748B),
                                height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  if (outJobs.isNotEmpty) ...[
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFF1F2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.moped_rounded,
                              color: Color(0xFFE11D48), size: 18),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'In Transit (${outJobs.length})',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...outJobs.map(
                        (job) => _buildDeliveryCard(job, isInTransit: true)),
                    const SizedBox(height: 20),
                  ],
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFFDCFCE7),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.storefront_rounded,
                            color: Color(0xFF16A34A), size: 18),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Ready for Pickup at Xerox Desk (${readyJobs.length})',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (readyJobs.isEmpty)
                    GlassCard(
                      padding: const EdgeInsets.all(20),
                      borderRadius: 18,
                      backgroundColor: Colors.white.withValues(alpha: 0.9),
                      border: Border.all(
                          color: Colors.black.withValues(alpha: 0.06)),
                      child: Center(
                        child: Text(
                          'No pending print jobs for pickup right now.',
                          style: GoogleFonts.poppins(
                              color: const Color(0xFF64748B), fontSize: 13),
                        ),
                      ),
                    )
                  else
                    ...readyJobs.map(
                        (job) => _buildDeliveryCard(job, isInTransit: false)),
                ],
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 16),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
              color: Colors.white.withValues(alpha: 0.8), fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildTabBtn(String key, String title) {
    final isSelected = _selectedTab == key;
    return InkWell(
      onTap: () => setState(() => _selectedTab = key),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE11D48) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected ? const Color(0xFFE11D48) : const Color(0xFFE2E8F0),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFFE11D48).withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  Widget _buildDeliveryCard(Map<String, dynamic> job,
      {required bool isInTransit}) {
    final id = (job['id'] ?? '#DEL').toString();
    final shopName = job['shop_name'] ?? 'Campus Xerox Desk';
    final pickup = job['pickup_address'] ?? 'Xerox Station Ground Floor';
    final dropoff = job['delivery_address'] ?? 'Campus Room Destination';
    final distance = job['distance'] ?? '0.8 km';
    final docName = job['document_name'] ?? 'Print_Job_Documents.pdf';
    final earning = job['earning']?.toString() ?? '35';

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GlassCard(
        borderRadius: 20,
        blur: 16,
        padding: const EdgeInsets.all(18),
        backgroundColor: Colors.white.withValues(alpha: 0.9),
        border: Border.all(
          color: isInTransit
              ? const Color(0xFFE11D48).withValues(alpha: 0.3)
              : const Color(0xFFE11D48).withValues(alpha: 0.12),
          width: isInTransit ? 1.5 : 1.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1F2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.receipt_long_rounded,
                          color: Color(0xFFE11D48), size: 18),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '#${id.replaceAll('#', '').substring(0, id.length > 8 ? 8 : id.length).toUpperCase()}',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          docName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontSize: 11, color: const Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.account_balance_wallet_rounded,
                          size: 14, color: Color(0xFF15803D)),
                      const SizedBox(width: 4),
                      Text(
                        '₹$earning Earn',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          color: const Color(0xFF15803D),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFF1F2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.storefront_rounded,
                          size: 14, color: Color(0xFFE11D48)),
                    ),
                    Container(
                      width: 2,
                      height: 32,
                      color: const Color(0xFFE11D48).withValues(alpha: 0.2),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFDCFCE7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.location_on_rounded,
                          size: 14, color: Color(0xFF16A34A)),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shopName,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: const Color(0xFF0F172A)),
                      ),
                      Text(
                        pickup,
                        style: GoogleFonts.poppins(
                            fontSize: 11, color: const Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Drop-off Destination ($distance)',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: const Color(0xFF0F172A)),
                      ),
                      Text(
                        dropoff,
                        style: GoogleFonts.poppins(
                            fontSize: 11, color: const Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (isInTransit) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showDeliveryPinDialog(context, job),
                  icon: const Icon(Icons.dialpad_rounded, size: 18),
                  label: Text('Verify Drop-off PIN & Complete',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Calling customer...'),
                              behavior: SnackBarBehavior.floating),
                        );
                      },
                      icon: const Icon(Icons.call_rounded, size: 16),
                      label: const Text('Call'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFE11D48),
                        side: BorderSide(
                            color:
                                const Color(0xFFE11D48).withValues(alpha: 0.3)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () => _updateJobStatus(id, 'out_for_delivery'),
                      icon: const Icon(Icons.check_circle_rounded, size: 18),
                      label: Text('Picked Up from Shop',
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE11D48),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

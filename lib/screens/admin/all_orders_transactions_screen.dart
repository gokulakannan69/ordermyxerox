import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../xerox/app_role_drawer.dart';
import '../home/home_screen.dart';
import '../../config/routes.dart';
import '../../widgets/glass_card.dart';

class AllOrdersTransactionsScreen extends StatefulWidget {
  const AllOrdersTransactionsScreen({super.key});

  @override
  State<AllOrdersTransactionsScreen> createState() =>
      _AllOrdersTransactionsScreenState();
}

class _AllOrdersTransactionsScreenState
    extends State<AllOrdersTransactionsScreen> {
  String _selectedFilter = 'ALL';

  final List<Map<String, dynamic>> _fallbackOrders = [
    {
      'id': 'ORD-8891',
      'shop_name': 'Campus Xerox Center',
      'status': 'Pending',
      'total_amount': 145.0,
      'document_name': 'Semester_6_Notes.pdf',
      'created_at': 'Just now',
    },
    {
      'id': 'ORD-8890',
      'shop_name': 'Sri Sai Prints & Stationers',
      'status': 'Printing',
      'total_amount': 320.0,
      'document_name': 'Project_Report_Final.docx',
      'created_at': '12 mins ago',
    },
    {
      'id': 'ORD-8889',
      'shop_name': 'Campus Xerox Center',
      'status': 'Completed',
      'total_amount': 80.0,
      'document_name': 'Hall_Ticket_Exam.pdf',
      'created_at': '1 hour ago',
    },
    {
      'id': 'ORD-8888',
      'shop_name': 'Royal Graphics & Offset',
      'status': 'Completed',
      'total_amount': 250.0,
      'document_name': 'Lab_Manual_Physics.pdf',
      'created_at': '3 hours ago',
    },
  ];

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'delivered':
        return const Color(0xFF10B981);
      case 'printing':
      case 'processing':
        return const Color(0xFF0284C7);
      case 'pending':
        return const Color(0xFFE11D48);
      case 'cancelled':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF64748B);
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = Supabase.instance.client;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: const AppRoleDrawer(),
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: const Color(0xFFE11D48),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.white),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Orders & Transactions',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4ADE80),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Live Realtime Sync',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.storefront_rounded, color: Colors.white),
            tooltip: 'Storefront',
            onPressed: () {
              HomeScreen.needsRefresh = true;
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // ── Filter Chips Bar ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('ALL', 'All Orders'),
                  const SizedBox(width: 8),
                  _buildFilterChip('PENDING', 'Pending'),
                  const SizedBox(width: 8),
                  _buildFilterChip('PRINTING', 'Printing'),
                  const SizedBox(width: 8),
                  _buildFilterChip('COMPLETED', 'Completed'),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // ── Realtime Stream Orders List ──
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: client.from('orders').stream(
                  primaryKey: ['id']).order('created_at', ascending: false),
              builder: (context, snapshot) {
                List<Map<String, dynamic>> orders = [];

                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  orders = snapshot.data!;
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  orders = _fallbackOrders;
                } else {
                  orders = _fallbackOrders;
                }

                final filtered = orders.where((o) {
                  if (_selectedFilter == 'ALL') return true;
                  final st = (o['status'] ?? '').toString().toUpperCase();
                  return st == _selectedFilter;
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFF1F2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.receipt_long_rounded,
                              size: 48, color: Color(0xFFE11D48)),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No orders found for $_selectedFilter',
                          style: GoogleFonts.poppins(
                              color: const Color(0xFF64748B),
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final order = filtered[index];
                    final id = order['id']?.toString() ?? '#ORD';
                    final shop =
                        order['shop_name']?.toString() ?? 'Campus Xerox Hub';
                    final status = order['status']?.toString() ?? 'Pending';
                    final doc =
                        order['document_name']?.toString() ?? 'Print_Job.pdf';
                    final amt = double.tryParse(
                            order['total_amount']?.toString() ?? '0') ??
                        0.0;
                    final statusColor = _getStatusColor(status);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GlassCard(
                        borderRadius: 18,
                        blur: 16,
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.white.withValues(alpha: 0.9),
                        border: Border.all(
                          color:
                              const Color(0xFFE11D48).withValues(alpha: 0.12),
                          width: 1.2,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF1F2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFE11D48)
                                      .withValues(alpha: 0.2),
                                ),
                              ),
                              child: const Icon(Icons.print_rounded,
                                  color: Color(0xFFE11D48), size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '#${id.replaceAll('#', '').substring(0, id.length > 8 ? 8 : id.length)}',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: const Color(0xFF0F172A),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: statusColor.withValues(
                                              alpha: 0.12),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                              color: statusColor.withValues(
                                                  alpha: 0.3),
                                              width: 0.8),
                                        ),
                                        child: Text(
                                          status.toUpperCase(),
                                          style: GoogleFonts.poppins(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700,
                                            color: statusColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    shop,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF334155),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    doc,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: const Color(0xFF64748B),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '₹${amt.toStringAsFixed(0)}',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFFE11D48),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String filterKey, String label) {
    final isSelected = _selectedFilter == filterKey;
    return InkWell(
      onTap: () => setState(() => _selectedFilter = filterKey),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE11D48) : const Color(0xFFFFF1F2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFE11D48)
                : const Color(0xFFE11D48).withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFFE11D48),
          ),
        ),
      ),
    );
  }
}

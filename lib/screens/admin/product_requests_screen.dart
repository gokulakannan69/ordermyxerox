import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';
import '../xerox/app_role_drawer.dart';

class ProductRequestsScreen extends StatefulWidget {
  const ProductRequestsScreen({super.key});

  @override
  State<ProductRequestsScreen> createState() => _ProductRequestsScreenState();
}

class _ProductRequestsScreenState extends State<ProductRequestsScreen> {
  int _selectedFilter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      drawer: const AppRoleDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Text(
          'Product Requests',
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh_rounded, color: Colors.black54),
            style:
                IconButton.styleFrom(backgroundColor: const Color(0xFFF1F5F9)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Review customer item requests & inquiry specs',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Overview Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _buildStatCard('Total', '6', Icons.calendar_today_outlined),
                  const SizedBox(width: 8),
                  _buildStatCard('Pending', '4', Icons.hourglass_empty_rounded,
                      color: const Color(0xFFD97706)),
                  const SizedBox(width: 8),
                  _buildStatCard('Reviewed', '2', Icons.remove_red_eye_outlined,
                      color: const Color(0xFF0284C7)),
                  const SizedBox(width: 8),
                  _buildStatCard('Done', '1', Icons.check_circle_outline,
                      color: const Color(0xFF10B981)),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Filter Chips
            SizedBox(
              height: 32,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  _buildFilterPill('All (6)',
                      isSelected: _selectedFilter == 0,
                      onTap: () => setState(() => _selectedFilter = 0)),
                  const SizedBox(width: 8),
                  _buildFilterPill('Pending (4)',
                      isSelected: _selectedFilter == 1,
                      onTap: () => setState(() => _selectedFilter = 1)),
                  const SizedBox(width: 8),
                  _buildFilterPill('Reviewed (2)',
                      isSelected: _selectedFilter == 2,
                      onTap: () => setState(() => _selectedFilter = 2)),
                  const SizedBox(width: 8),
                  _buildFilterPill('Completed (1)',
                      isSelected: _selectedFilter == 3,
                      onTap: () => setState(() => _selectedFilter = 3)),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Request Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildRequestCard(
                    title: 'Sensor glove',
                    priority: 'High',
                    user: 'Tamizhkumaran',
                    email: 'tamizhkumaran1777@gmail...',
                    date: '14 Sept 2026, 07:47 pm',
                    category: 'Electronic / Kits',
                    qty: '1',
                    phone: '8760744707',
                    spec: 'Orange color',
                    status: 'Pending',
                    hasImage: true,
                  ),
                  const SizedBox(height: 16),
                  _buildRequestCard(
                    title: 'Nycil cool powder',
                    priority: 'Low Priority',
                    user: 'A90 N4 Gaming House',
                    email: 'a90n4gaming@gmail.com',
                    date: '18 Aug 2026, 11:55 am',
                    category: 'Other Essentials',
                    qty: '1',
                    phone: '',
                    warning: 'No mobile number saved in order request',
                    spec: '150g + 60g packet',
                    adminReply: '"Give a full name of product"',
                    status: 'Reviewed',
                  ),
                  const SizedBox(height: 16),
                  _buildRequestCard(
                    title: 'Pdf Documents (1...',
                    priority: 'Low Priority',
                    user: 'REKHA KS',
                    email: 'rekhaks1983@gmail.com',
                    date: '11 Aug 2026, 10:32 pm',
                    category: 'Xerox / Printing',
                    qty: '1 Copy (A4 B&W)',
                    phone: '9080233595',
                    spec: 'Ready for pickup at counter #2',
                    status: 'Completed',
                    isSpecSuccess: true,
                  ),
                  const SizedBox(height: 16),
                  _buildRequestCard(
                    title: 'Graph Sheet Booklet',
                    priority: 'High',
                    user: 'Sam',
                    email: 'samuel.s@gmail.com',
                    date: '28 Aug 2026, 04:03 pm',
                    category: 'Stationery',
                    qty: '2 Units',
                    phone: '8888888888',
                    spec: '',
                    status: 'Pending',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon,
      {Color color = Colors.black87}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(height: 8),
            Text(count,
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w700, color: color)),
            Text(title,
                style:
                    GoogleFonts.poppins(fontSize: 10, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPill(String label,
      {required bool isSelected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF991B1B) : const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestCard({
    required String title,
    required String priority,
    required String user,
    required String email,
    required String date,
    required String category,
    required String qty,
    required String phone,
    String warning = '',
    String spec = '',
    bool isSpecSuccess = false,
    String adminReply = '',
    required String status,
    bool hasImage = false,
  }) {
    final isHigh = priority == 'High';
    final isPending = status == 'Pending';
    final isReviewed = status == 'Reviewed';
    final isCompleted = status == 'Completed';

    Color statusColor = const Color(0xFFFDE68A); // Yellow
    if (isReviewed) statusColor = const Color(0xFFBAE6FD); // Blue
    if (isCompleted) statusColor = const Color(0xFFA7F3D0); // Green

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(title,
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isHigh
                            ? const Color(0xFFFFE4E6)
                            : const Color(0xFFD1FAE5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                  color: isHigh
                                      ? AppColors.primary
                                      : const Color(0xFF059669),
                                  shape: BoxShape.circle)),
                          const SizedBox(width: 4),
                          Text(priority,
                              style: GoogleFonts.poppins(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: isHigh
                                      ? AppColors.primary
                                      : const Color(0xFF059669))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: statusColor, borderRadius: BorderRadius.circular(8)),
                child: Text(status,
                    style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87)),
              )
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.person_outline, size: 12, color: Colors.black54),
              const SizedBox(width: 4),
              Text(user,
                  style:
                      GoogleFonts.poppins(fontSize: 11, color: Colors.black87)),
            ],
          ),
          Text(email,
              style: GoogleFonts.poppins(fontSize: 11, color: Colors.black54)),
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined,
                  size: 12, color: Colors.black54),
              const SizedBox(width: 4),
              Text(date,
                  style:
                      GoogleFonts.poppins(fontSize: 10, color: Colors.black54)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6)),
                child: Row(
                  children: [
                    const Icon(Icons.category_outlined,
                        size: 12, color: Colors.black54),
                    const SizedBox(width: 4),
                    Text(category,
                        style: GoogleFonts.poppins(
                            fontSize: 10, color: Colors.black87)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6)),
                child: Row(
                  children: [
                    const Icon(Icons.tag, size: 12, color: Colors.black54),
                    const SizedBox(width: 4),
                    Text('Qty: $qty',
                        style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87)),
                  ],
                ),
              ),
            ],
          ),
          if (hasImage) ...[
            const SizedBox(height: 12),
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  const Center(
                      child: Icon(Icons.image_outlined,
                          color: Colors.white38,
                          size: 32)), // dummy image placeholder
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Row(
                      children: [
                        const Icon(Icons.image, size: 12, color: Colors.white),
                        const SizedBox(width: 4),
                        Text('Attached Reference Sample',
                            style: GoogleFonts.poppins(
                                fontSize: 9, color: Colors.white)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          if (warning.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      size: 16, color: Color(0xFFB45309)),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text(warning,
                          style: GoogleFonts.poppins(
                              fontSize: 11, color: const Color(0xFF92400E)))),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ] else ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  const Icon(Icons.phone_outlined,
                      size: 14, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(phone,
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w500)),
                  const Spacer(),
                  const Icon(Icons.call_outlined,
                      size: 18, color: Colors.black54),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                        color: Color(0xFF10B981), shape: BoxShape.circle),
                    child: const Icon(Icons.chat_bubble_outline,
                        size: 14, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (spec.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: isSpecSuccess
                      ? const Color(0xFFF0FDF4)
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                      isSpecSuccess
                          ? Icons.check_circle_outline
                          : Icons.format_quote_rounded,
                      size: 16,
                      color: isSpecSuccess
                          ? const Color(0xFF16A34A)
                          : Colors.black54),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isSpecSuccess)
                          Text('USER SPECIFICATION',
                              style: GoogleFonts.poppins(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54)),
                        Text(spec,
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: isSpecSuccess
                                    ? const Color(0xFF16A34A)
                                    : Colors.black87,
                                fontWeight: isSpecSuccess
                                    ? FontWeight.w500
                                    : FontWeight.w400)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (adminReply.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: const Color(0xFFF0F9FF),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.reply_rounded,
                      size: 16, color: Color(0xFF0284C7)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('ADMIN REPLY SENT',
                                style: GoogleFonts.poppins(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF0284C7))),
                            const Spacer(),
                            Text('Today',
                                style: GoogleFonts.poppins(
                                    fontSize: 9,
                                    color: const Color(0xFF0284C7))),
                          ],
                        ),
                        Text(adminReply,
                            style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontStyle: FontStyle.italic,
                                color: Colors.black87)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text('Status: $status',
                        style: GoogleFonts.poppins(
                            fontSize: 11, fontWeight: FontWeight.w500)),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_down_rounded, size: 14),
                  ],
                ),
              ),
              const Spacer(),
              if (isPending)
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.reply_rounded,
                      size: 14, color: Colors.white),
                  label: Text('Reply',
                      style: GoogleFonts.poppins(
                          fontSize: 11, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF991B1B),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                )
              else if (isReviewed)
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit_outlined,
                      size: 14, color: Colors.black87),
                  label: Text('Edit Reply',
                      style: GoogleFonts.poppins(
                          fontSize: 11, color: Colors.black87)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF1F5F9),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                )
              else if (isCompleted)
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.history_rounded,
                      size: 14, color: Colors.black87),
                  label: Text('Log',
                      style: GoogleFonts.poppins(
                          fontSize: 11, color: Colors.black87)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF1F5F9),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete_outline,
                    color: AppColors.primary, size: 16),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFFEF2F2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  minimumSize: const Size(36, 36),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

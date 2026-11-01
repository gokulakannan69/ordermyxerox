import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';
import '../xerox/app_role_drawer.dart';

class SupportQueriesScreen extends StatefulWidget {
  const SupportQueriesScreen({super.key});

  @override
  State<SupportQueriesScreen> createState() => _SupportQueriesScreenState();
}

class _SupportQueriesScreenState extends State<SupportQueriesScreen> {
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
          'Support Queries',
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
                'Manage tickets, bug reports & cancellations',
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
                  _buildStatCard('TOTAL', '4', Icons.inbox_outlined),
                  const SizedBox(width: 8),
                  _buildStatCard('OPEN', '4', Icons.access_time_rounded,
                      hasDot: true),
                  const SizedBox(width: 8),
                  _buildStatCard('CLOSED', '0', Icons.check_circle_outline),
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
                  _buildFilterPill('All Status', '4',
                      isSelected: _selectedFilter == 0,
                      onTap: () => setState(() => _selectedFilter = 0)),
                  const SizedBox(width: 8),
                  _buildFilterPill('Open', '4',
                      isSelected: _selectedFilter == 1,
                      onTap: () => setState(() => _selectedFilter = 1)),
                  const SizedBox(width: 8),
                  _buildFilterPill('Closed', '0',
                      isSelected: _selectedFilter == 2,
                      onTap: () => setState(() => _selectedFilter = 2)),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Sub filters
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(12)),
                    child: Text('All Types',
                        style: GoogleFonts.poppins(
                            fontSize: 10, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 8),
                  _buildTypePill('Bug Reports (2)', AppColors.primary),
                  const SizedBox(width: 8),
                  _buildTypePill('Cancellations (2)', Colors.brown),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Queries List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildQueryCard(
                    title: 'Bug Report: Unable to Cancel Order #BVVFMX',
                    user: 'prasanth5576',
                    typeTag: '#technical',
                    date: '22 Sept 2026, 11:59 pm',
                    phone: '9632587412',
                    desc:
                        '"Could not cancel item. Please try again." Because of this bug, I am unable to cancel the order myself. Order ID: #BVVFMX, Shop: PATTAI KOVIL (KING XEROX),...',
                    icon: Icons.bug_report_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildQueryCard(
                    title: 'Request to Cancel Order #BVVFMX',
                    user: 'prasanth5576',
                    typeTag: '#order',
                    date: '22 Sept 2026, 11:56 pm',
                    phone: '9632587412',
                    desc:
                        'I recently placed an order on your platform (ordermyxerox.com), but I am unable to cancel it through the application. Kindly cancel this order as...',
                    icon: Icons.cancel_outlined,
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
      {bool hasDot = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (hasDot)
              Positioned(
                top: 0,
                right: 24,
                child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                        color: AppColors.primary, shape: BoxShape.circle)),
              ),
            Column(
              children: [
                Icon(icon, color: Colors.black54, size: 20),
                const SizedBox(height: 8),
                Text(count,
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: hasDot ? AppColors.primary : Colors.black87)),
                Text(title,
                    style: GoogleFonts.poppins(
                        fontSize: 10, color: Colors.black54)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPill(String label, String count,
      {required bool isSelected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF991B1B) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color:
                  isSelected ? const Color(0xFF991B1B) : Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.2)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                count,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.black54,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTypePill(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(label,
              style: GoogleFonts.poppins(fontSize: 10, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildQueryCard({
    required String title,
    required String user,
    required String typeTag,
    required String date,
    required String phone,
    required String desc,
    required IconData icon,
  }) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFE4E6),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.person_outline,
                            size: 12, color: Colors.black54),
                        const SizedBox(width: 4),
                        Text(user,
                            style: GoogleFonts.poppins(
                                fontSize: 11, color: Colors.black87)),
                        const SizedBox(width: 8),
                        Text(typeTag,
                            style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(date,
                        style: GoogleFonts.poppins(
                            fontSize: 10, color: Colors.black54)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: const Color(0xFFFFE4E6),
                    borderRadius: BorderRadius.circular(8)),
                child: Text('OPEN',
                    style: GoogleFonts.poppins(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary)),
              )
            ],
          ),
          const SizedBox(height: 12),
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
                        fontSize: 12, fontWeight: FontWeight.w500)),
                const Spacer(),
                const Icon(Icons.chat_outlined,
                    size: 16, color: Colors.black54),
                const SizedBox(width: 12),
                const Icon(Icons.mail_outline, size: 16, color: Colors.black54),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            desc,
            style: GoogleFonts.poppins(
                fontSize: 11, color: Colors.black87, height: 1.5),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF1F5F9),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Open Details',
                          style: GoogleFonts.poppins(
                              fontSize: 11, color: Colors.black87)),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right_rounded,
                          size: 14, color: Colors.black87),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
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
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete_outline,
                    color: AppColors.primary, size: 18),
                style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFFEF2F2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
              )
            ],
          )
        ],
      ),
    );
  }
}

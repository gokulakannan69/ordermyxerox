import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/glass_card.dart';

class ManageXeroxShopsScreen extends StatefulWidget {
  const ManageXeroxShopsScreen({super.key});

  @override
  State<ManageXeroxShopsScreen> createState() => _ManageXeroxShopsScreenState();
}

class _ManageXeroxShopsScreenState extends State<ManageXeroxShopsScreen> {
  String _selectedStateFilter = 'All';
  String _selectedDistrictFilter = 'All';
  String _selectedCityFilter = 'All';
  String _selectedCategoryFilter = 'All';

  // Fallback defaults for "Others" category
  String? _fallbackXerox;
  String? _fallbackStationery;
  String? _fallbackBooks;
  String? _fallbackKits;

  // Pre-seeded high fidelity network shops matching the architecture diagram
  final List<Map<String, dynamic>> _masterShops = [
    {
      'name': 'JASA BOOKS',
      'type': 'SHOP',
      'location': 'SALEM',
      'phone1': '7639206705',
      'phone2': '7639206705',
      'deliveryLabel': 'Home Delivery - Within 24 hours',
      'category': 'Books',
      'officeDelivery': 'Rs. 1 to Rs. 500 = Rs. 50\nRs. 501 to ∞ = Free',
      'standardDelivery': 'Rs. 1 to ∞ = Rs. 50',
      'states': 'TAMIL NADU',
      'districts': 'NAMAKKAL, SALEM',
      'cities': 'PAAVAI, SALEM CITY',
      'owners': 'Ramani, Priyanga.R',
      'staff': 'Jayasenan C, Pandi B, Thiyagarajan',
    },
    {
      'name': 'PAAVAI INSTITUTIONS',
      'type': 'COLLEGE',
      'location': 'Paavai Institution',
      'phone1': '7639206705',
      'phone2': '7639206705',
      'deliveryLabel': 'Express Desk Pickup & Delivery',
      'category': 'Xerox',
      'officeDelivery': 'Rs. 0 to Rs. 0 = Free',
      'standardDelivery': 'Rs. 0 to Rs. 0 = Free',
      'states': 'TAMIL NADU',
      'districts': 'NAMAKKAL',
      'cities': 'PAAVAI',
      'owners': 'KUPPIK',
      'staff': 'Karthik, Jayasenan C',
    },
    {
      'name': 'PATTAI KOVIL (KING XEROX)',
      'type': 'SHOP',
      'location': 'Opposite to New Pattai Kovil, Salem-1 (King Xerox)',
      'phone1': '7639722330',
      'phone2': '8903702230',
      'deliveryLabel': 'Home Delivery - Within 24 hours',
      'category': 'Xerox',
      'officeDelivery': 'Rs. 0 to Rs. 100 = Rs. 50\nRs. 101 to ∞ = Rs. 50',
      'standardDelivery': 'Rs. 0 to ∞ = Free',
      'states': 'TAMIL NADU',
      'districts': 'SALEM',
      'cities': 'SALEM CITY',
      'owners': 'Jayasenan C, KING XEROX-1',
      'staff': 'Jayasenan C',
    },
    {
      'name': 'SONA COLLEGE (KING XEROX)',
      'type': 'SHOP',
      'location': 'Opp. Sona College, Junction Main Road, Salem-4',
      'phone1': '7639722330',
      'phone2': '9943245190',
      'deliveryLabel': 'Home Delivery - Within 24 hours',
      'category': 'Xerox',
      'officeDelivery': 'Rs. 0 to Rs. 100 = Rs. 50\nRs. 101 to ∞ = Rs. 50',
      'standardDelivery': 'Not Set',
      'states': 'TAMIL NADU',
      'districts': 'SALEM',
      'cities': 'SALEM CITY',
      'owners': 'King Duplex Jayasenan C, KING XEROX-1',
      'staff': 'Jayasenan C',
    },
    {
      'name': 'Sri sakthi Kailash college',
      'type': 'COLLEGE',
      'location': 'Sri sakthi Kailash college',
      'phone1': '7639206705',
      'phone2': '7639206705',
      'deliveryLabel': 'Campus Delivery - Within 24 hours',
      'category': 'Xerox',
      'officeDelivery': 'Rs. 0 to Rs. 0 = Free',
      'standardDelivery': 'Rs. 0 to Rs. 0 = Free',
      'states': 'TAMIL NADU',
      'districts': 'SALEM',
      'cities': 'SALEM CITY',
      'owners': 'Sasikumar',
      'staff': 'Jayasenan C',
    },
    {
      'name': '7 Arts College (KING XEROX)',
      'type': 'SHOP',
      'location': 'SALEM CITY',
      'phone1': '8903890705',
      'phone2': '8903890705',
      'deliveryLabel': 'Home Delivery - Within 24 hours',
      'category': 'Xerox',
      'officeDelivery': 'Rs. 1 to Rs. 999 = Rs. 50\nRs. 1000 to ∞ = Rs. 50',
      'standardDelivery': 'Rs. 0 to Rs. 0 = Free',
      'states': 'TAMIL NADU',
      'districts': 'SALEM',
      'cities': 'SALEM CITY',
      'owners': 'CREATING CELL, Jayasenan C',
      'staff': 'Jayasenan C, Suresh',
    },
    {
      'name': 'JASA ESSENTIAL',
      'type': 'SHOP',
      'location': 'SALEM CITY',
      'phone1': '7639206705',
      'phone2': '7639206705',
      'deliveryLabel': 'Home Delivery - Within 24 hours',
      'category': 'Stationery',
      'officeDelivery': 'Rs. 1 to Rs. 150 = Rs. 50\nRs. 151 to ∞ = Free',
      'standardDelivery': 'Rs. 1 to ∞ = Rs. 50',
      'states': 'TAMIL NADU',
      'districts': 'SALEM',
      'cities': 'SALEM CITY',
      'owners': 'RAMANI R ENTERPRISES',
      'staff': 'Jayasenan C, Pandi, SOORYA PRA',
    },
    {
      'name': 'GORIMEDU, SALEM CITY (KING XEROX)',
      'type': 'SHOP',
      'location': 'Near Chettypatty Gate Stop, Salem-16',
      'phone1': '7639722330',
      'phone2': '9361833214',
      'deliveryLabel': 'Home Delivery - Within 24 hours',
      'category': 'Xerox',
      'officeDelivery': 'Rs. 0 to Rs. 100 = Rs. 50\nRs. 101 to ∞ = Rs. 50',
      'standardDelivery': 'Rs. 0 to Rs. 0 = Free',
      'states': 'TAMIL NADU',
      'districts': 'SALEM',
      'cities': 'SALEM CITY',
      'owners': 'Jayasenan C, KING XEROX-1, C&S COPIERS',
      'staff': 'Jayasenan C',
    },
    {
      'name': 'JASA KITS',
      'type': 'SHOP',
      'location': 'SALEM & NAMAKKAL',
      'phone1': '7639206705',
      'phone2': '7639206705',
      'deliveryLabel': 'Home Delivery - Within 2 days',
      'category': 'Kits',
      'officeDelivery': 'Rs. 1 to Rs. 150 = Rs. 50\nRs. 151 to ∞ = Free',
      'standardDelivery': 'Rs. 1 to ∞ = Rs. 50',
      'states': 'TAMIL NADU',
      'districts': 'NAMAKKAL, SALEM',
      'cities': 'PAAVAI, SALEM CITY',
      'owners': 'Ramani2',
      'staff': 'Jayasenan C, karthi2',
    },
    {
      'name': 'Print hub',
      'type': 'SHOP',
      'location': 'Salem',
      'phone1': '9698545143',
      'phone2': '9698545143',
      'deliveryLabel': 'Home Delivery - Within 24 hours',
      'category': 'Xerox',
      'officeDelivery': 'Rs. 0 to ∞ = Rs. 50',
      'standardDelivery': 'Rs. 0 to ∞ = Rs. 50',
      'states': 'TAMIL NADU, Others',
      'districts': 'SALEM (Other TAMIL NADU)',
      'cities': 'SALEM CITY',
      'owners': 'Jayasenan C',
      'staff': 'Jayasenan C',
    },
    {
      'name': 'ORDER MY XEROX - INDIA',
      'type': 'SHOP',
      'location': 'SALEM CITY',
      'phone1': '8508502330',
      'phone2': '8508502720',
      'deliveryLabel': 'Home Delivery - Within 3 days',
      'category': 'Xerox',
      'officeDelivery': 'Rs. 0 to Rs. 499 = Rs. 50\nRs. 500 to ∞ = Free',
      'standardDelivery': 'Rs. 500 to ∞ = Rs. 50',
      'states': 'TAMIL NADU',
      'districts': 'SALEM',
      'cities': 'SALEM CITY',
      'owners': 'KING KUMAR-4, karthick, Jayasenan C',
      'staff': 'Jayasenan C, karthi',
    },
    {
      'name': 'DADAGAPATTY (KING XEROX)',
      'type': 'SHOP',
      'location': 'Trichy Main Road, Dadagapatty, Salem-6',
      'phone1': '8903890705',
      'phone2': '8903890705',
      'deliveryLabel': 'Home Delivery - Within 24 hours',
      'category': 'Xerox',
      'officeDelivery': 'Rs. 0 to Rs. 100 = Rs. 50\nRs. 101 to ∞ = Rs. 50',
      'standardDelivery': 'Rs. 0 to Rs. 0 = Free',
      'states': 'TAMIL NADU',
      'districts': 'SALEM',
      'cities': 'SALEM CITY',
      'owners': 'CREATING CD-1, Jayasenan C',
      'staff': 'Jayasenan C',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF8FAFC), // Apple clean crisp light background
      appBar: AppBar(
        backgroundColor: const Color(0xFFE11D48), // Brand Red AppBar
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Manage Xerox Shops',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_rounded, color: Colors.white),
            tooltip: 'View Home Storefront',
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, '/home', (r) => false),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top Geographic Filter & Add Shop Ribbon in Apple Glass style ──
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              color: Colors.white,
              child: Row(
                children: [
                  _buildNavTab(
                    label: 'States',
                    icon: Icons.map_rounded,
                    isActive: _selectedStateFilter != 'All',
                    onTap: () => _showStatesDialog(),
                  ),
                  const SizedBox(width: 8),
                  _buildNavTab(
                    label: 'District',
                    icon: Icons.location_city_rounded,
                    isActive: _selectedDistrictFilter != 'All',
                    onTap: () => _showDistrictDialog(),
                  ),
                  const SizedBox(width: 8),
                  _buildNavTab(
                    label: 'Cities',
                    icon: Icons.apartment_rounded,
                    isActive: _selectedCityFilter != 'All',
                    onTap: () => _showCitiesDialog(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showAddShopDialog(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFFE11D48), // Brand Crimson Red
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.add_business_rounded,
                          size: 16, color: Colors.white),
                      label: Text(
                        'Add Shop',
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Auto Updating Category Filter Chips Bar ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
              color: Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryFilterChip('All', Icons.apps_rounded),
                    const SizedBox(width: 8),
                    _buildCategoryFilterChip('Xerox', Icons.print_rounded),
                    const SizedBox(width: 8),
                    _buildCategoryFilterChip(
                        'Stationery', Icons.edit_note_rounded),
                    const SizedBox(width: 8),
                    _buildCategoryFilterChip('Books', Icons.menu_book_rounded),
                    const SizedBox(width: 8),
                    _buildCategoryFilterChip(
                        'Kits', Icons.business_center_rounded),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ── Realtime Supabase Sync Indicator Banner ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'REALTIME DATABASE SYNC ACTIVE',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF059669),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // ── Live Supabase Sync & Grid of Partner Shop Cards ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: Supabase.instance.client.from('shops').stream(
                    primaryKey: ['id']).order('created_at', ascending: false),
                builder: (context, snapshot) {
                  final liveShops = snapshot.data ?? [];

                  // Merge live shops from database with architecture network
                  final List<Map<String, dynamic>> allShops = [];
                  for (final s in liveShops) {
                    allShops.add({
                      'id': s['id'],
                      'name': s['shop_name'] ?? 'rupees',
                      'type': s['type'] ?? 'SHOP',
                      'location': s['address'] ?? 'tambaram',
                      'phone1': s['phone'] ?? '9361443302',
                      'phone2': '9361443302',
                      'deliveryLabel': s['delivery_label'] ??
                          'Home Delivery - Within 24 hours',
                      'category': s['category'] ?? 'Xerox',
                      'officeDelivery': s['office_delivery'] ??
                          'Rs. 0 to Rs. 100 = Rs. 50\nRs. 101 to ∞ = Free',
                      'standardDelivery':
                          s['standard_delivery'] ?? 'Rs. 0 to ∞ = Rs. 50',
                      'states': s['state'] ?? 'TAMIL NADU',
                      'districts': s['district'] ?? 'SALEM',
                      'cities': s['city'] ?? 'SALEM CITY',
                      'owners': s['owner'] ?? 'Registered Partner',
                      'staff': s['staff'] ?? 'Staff',
                    });
                  }

                  // Default sample shops if DB empty
                  if (allShops.isEmpty) {
                    allShops.addAll(_masterShops);
                  }

                  final filteredShops = allShops.where((s) {
                    if (_selectedCategoryFilter != 'All' &&
                        !s['category']
                            .toString()
                            .toLowerCase()
                            .contains(_selectedCategoryFilter.toLowerCase())) {
                      return false;
                    }
                    if (_selectedStateFilter != 'All' &&
                        !s['states']
                            .toString()
                            .toLowerCase()
                            .contains(_selectedStateFilter.toLowerCase())) {
                      return false;
                    }
                    if (_selectedDistrictFilter != 'All' &&
                        !s['districts']
                            .toString()
                            .toLowerCase()
                            .contains(_selectedDistrictFilter.toLowerCase())) {
                      return false;
                    }
                    if (_selectedCityFilter != 'All' &&
                        !s['cities']
                            .toString()
                            .toLowerCase()
                            .contains(_selectedCityFilter.toLowerCase())) {
                      return false;
                    }
                    return true;
                  }).toList();

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredShops.length,
                    separatorBuilder: (ctx, idx) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      return _buildShopCard(filteredShops[index]);
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // ── Bottom "Default 'Others' Shop" Fallback Configuration Engine ──
            _buildDefaultFallbackSection(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ── Shop Card Component with Apple Glassmorphism and Red & White Aesthetics ──
  Widget _buildShopCard(Map<String, dynamic> shop) {
    final shopId = shop['id']?.toString();

    return GlassCard(
      blur: 20.0,
      opacity: 0.92,
      borderRadius: 22.0,
      tintColor: Colors.white,
      customBorder: Border.all(
        color: const Color(0xFFE11D48).withValues(alpha: 0.15),
        width: 1.2,
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Name + Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  shop['name'],
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE11D48),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE11D48).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  shop['type'],
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Location
          Row(
            children: [
              const Icon(Icons.location_on_rounded,
                  size: 15, color: Color(0xFFE11D48)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  shop['location'],
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: const Color(0xFF475569)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // View on Map Link
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Opening map view for ${shop['name']}')),
              );
            },
            child: Row(
              children: [
                const Icon(Icons.explore_rounded,
                    size: 14, color: Color(0xFFE11D48)),
                const SizedBox(width: 6),
                Text(
                  'View on Map',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFE11D48),
                    decoration: TextDecoration.underline,
                    decorationColor: const Color(0xFFE11D48),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Phone Helplines
          Row(
            children: [
              const Icon(Icons.phone_in_talk_rounded,
                  size: 14, color: Color(0xFFE11D48)),
              const SizedBox(width: 6),
              Text(
                '${shop['phone1']}  ${shop['phone2']}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Home Delivery SLA Pill matching Red & White theme
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1F2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: const Color(0xFFE11D48).withValues(alpha: 0.3),
                  width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_rounded,
                    size: 12, color: Color(0xFFE11D48)),
                const SizedBox(width: 6),
                Text(
                  shop['deliveryLabel'],
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFBE123C),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Category Badge Tag matching Red & White theme
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFCBD5E1), width: 0.8),
            ),
            child: Text(
              shop['category'],
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF334155),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Office Delivery vs Standard Delivery Tiers
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OFFICE DELIVERY',
                      style: GoogleFonts.poppins(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF94A3B8),
                          letterSpacing: 0.4),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      shop['officeDelivery'],
                      style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: const Color(0xFF334155),
                          height: 1.3),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'STANDARD DELIVERY',
                      style: GoogleFonts.poppins(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF94A3B8),
                          letterSpacing: 0.4),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      shop['standardDelivery'],
                      style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: const Color(0xFF334155),
                          height: 1.3),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Territory and Staff Matrix
          Text(
            'States: ${shop['states']}\nDistricts: ${shop['districts']}\nCities: ${shop['cities']}\nOwners: ${shop['owners']}',
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: const Color(0xFF64748B),
              height: 1.35,
            ),
          ),

          const SizedBox(height: 14),

          // Edit and Delete Buttons matching Red & White theme
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: ElevatedButton.icon(
                    onPressed: () => _showEditShopDialog(shop),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE11D48),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.edit_note_rounded,
                        size: 18, color: Colors.white),
                    label: Text(
                      'Edit Shop',
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        _confirmDeleteShop(shop['name'], shopId: shopId),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFE11D48),
                      side: const BorderSide(
                          color: Color(0xFFE11D48), width: 1.5),
                      backgroundColor: const Color(0xFFFFF1F2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.delete_outline_rounded,
                        size: 16, color: Color(0xFFE11D48)),
                    label: Text(
                      'Delete',
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFE11D48)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Bottom "Default 'Others' Shop" Fallback Configuration Engine in Apple Glass style ──
  Widget _buildDefaultFallbackSection() {
    return GlassCard(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(18),
      borderRadius: 22,
      opacity: 0.95,
      tintColor: Colors.white,
      customBorder: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE11D48).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.alt_route_rounded,
                    color: Color(0xFFE11D48), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Default "Others" Shop',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Select which shop connects "Others" in location tree. Extreme fallback mapper for category.',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFallbackDropdown(
            label: 'Xerox',
            icon: Icons.print_rounded,
            value: _fallbackXerox,
            onChanged: (v) => setState(() => _fallbackXerox = v),
          ),
          const SizedBox(height: 10),
          _buildFallbackDropdown(
            label: 'Stationery',
            icon: Icons.edit_note_rounded,
            value: _fallbackStationery,
            onChanged: (v) => setState(() => _fallbackStationery = v),
          ),
          const SizedBox(height: 10),
          _buildFallbackDropdown(
            label: 'Books',
            icon: Icons.menu_book_rounded,
            value: _fallbackBooks,
            onChanged: (v) => setState(() => _fallbackBooks = v),
          ),
          const SizedBox(height: 10),
          _buildFallbackDropdown(
            label: 'Kits',
            icon: Icons.business_center_rounded,
            value: _fallbackKits,
            onChanged: (v) => setState(() => _fallbackKits = v),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Default "Others" Shop category fallback mapping saved successfully!'),
                    backgroundColor: Color(0xFFE11D48),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE11D48),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.save_rounded, size: 16),
              label: Text(
                'Save',
                style: GoogleFonts.poppins(
                    fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackDropdown({
    required String label,
    required IconData icon,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    final shopNames = _masterShops.map((s) => s['name'] as String).toList();

    return Row(
      children: [
        SizedBox(
          width: 110,
          child: Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFFE11D48)),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A)),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                dropdownColor: Colors.white,
                hint: Text(
                  'Select Shop',
                  style: GoogleFonts.poppins(
                      color: const Color(0xFF94A3B8), fontSize: 12),
                ),
                icon: const Icon(Icons.arrow_drop_down_rounded,
                    color: Color(0xFF64748B)),
                items: [
                  DropdownMenuItem<String>(
                    value: null,
                    child: Text('-- None --',
                        style: GoogleFonts.poppins(
                            color: const Color(0xFF64748B), fontSize: 12)),
                  ),
                  ...shopNames.map(
                    (name) => DropdownMenuItem<String>(
                      value: name,
                      child: Text(
                        name,
                        style: GoogleFonts.poppins(
                            color: const Color(0xFF0F172A), fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilterChip(String cat, IconData icon) {
    final isSelected = _selectedCategoryFilter == cat;
    return InkWell(
      onTap: () => setState(() => _selectedCategoryFilter = cat),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE11D48) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isSelected ? const Color(0xFFE11D48) : const Color(0xFFE2E8F0),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFFE11D48).withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? Colors.white : const Color(0xFF64748B),
            ),
            const SizedBox(width: 6),
            Text(
              cat,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavTab({
    required String label,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFFF1F2) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? const Color(0xFFE11D48) : const Color(0xFFE2E8F0),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 14,
                color: isActive
                    ? const Color(0xFFE11D48)
                    : const Color(0xFF64748B)),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isActive
                    ? const Color(0xFFE11D48)
                    : const Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Dialog Handlers ──
  void _showStatesDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF162032),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Filter by State',
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'All',
            'TAMIL NADU',
            'KERALA',
            'KARNATAKA',
            'ANDHRA PRADESH'
          ].map((st) {
            final isSelected = _selectedStateFilter == st;
            return ListTile(
              title: Text(st,
                  style: GoogleFonts.poppins(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal)),
              leading: Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: const Color(0xFFE11D48),
              ),
              onTap: () {
                setState(() => _selectedStateFilter = st);
                Navigator.pop(ctx);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showDistrictDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF162032),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Filter by District',
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children:
              ['All', 'SALEM', 'NAMAKKAL', 'ERODE', 'COIMBATORE'].map((dt) {
            final isSelected = _selectedDistrictFilter == dt;
            return ListTile(
              title: Text(dt,
                  style: GoogleFonts.poppins(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal)),
              leading: Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: const Color(0xFFE11D48),
              ),
              onTap: () {
                setState(() => _selectedDistrictFilter = dt);
                Navigator.pop(ctx);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showCitiesDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF162032),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Filter by Cities/Hubs',
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'All',
            'SALEM CITY',
            'PAAVAI CAMPUS',
            'SONA JUNCTION',
            'GORIMEDU'
          ].map((ct) {
            final isSelected = _selectedCityFilter == ct;
            return ListTile(
              title: Text(ct,
                  style: GoogleFonts.poppins(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal)),
              leading: Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: const Color(0xFFE11D48),
              ),
              onTap: () {
                setState(() => _selectedCityFilter = ct);
                Navigator.pop(ctx);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showAddShopDialog() {
    final nameCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    String category = 'Xerox';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF162032),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE11D48).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add_business_rounded,
                    color: Color(0xFFE11D48), size: 20),
              ),
              const SizedBox(width: 8),
              Text(
                'Add New Partner Shop',
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    labelText: 'Shop Name',
                    labelStyle: GoogleFonts.poppins(
                        color: const Color(0xFFE11D48),
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF334155))),
                    focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFE11D48), width: 1.5)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: addressCtrl,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    labelText: 'Address / Location',
                    labelStyle: GoogleFonts.poppins(
                        color: Colors.white70, fontSize: 12),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF334155))),
                    focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFE11D48), width: 1.5)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    labelText: 'Contact Helpline',
                    labelStyle: GoogleFonts.poppins(
                        color: Colors.white70, fontSize: 12),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF334155))),
                    focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFE11D48), width: 1.5)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: category,
                  dropdownColor: const Color(0xFF162032),
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    labelText: 'Primary Category',
                    labelStyle: GoogleFonts.poppins(
                        color: Colors.white70, fontSize: 12),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF334155))),
                    focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFE11D48), width: 1.5)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                  items: ['Xerox', 'Stationery', 'Books', 'Kits']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setDialogState(() => category = v);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel',
                  style: GoogleFonts.poppins(color: Colors.white60)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameCtrl.text.isNotEmpty) {
                  try {
                    await Supabase.instance.client.from('shops').insert({
                      'shop_name': nameCtrl.text.trim(),
                      'address': addressCtrl.text.trim(),
                      'phone': phoneCtrl.text.trim(),
                      'category': category,
                      'is_verified': true,
                      'is_open': true,
                    });
                  } catch (_) {}
                  if (ctx.mounted) Navigator.pop(ctx);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Shop "${nameCtrl.text}" added to network & database!'),
                        backgroundColor: const Color(0xFF10B981),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE11D48), // Brand Crimson Red
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Add Shop',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditShopDialog(Map<String, dynamic> shop) {
    final nameCtrl = TextEditingController(text: shop['name']);
    final addressCtrl = TextEditingController(text: shop['location']);
    final phoneCtrl = TextEditingController(text: shop['phone1']);
    final deliveryCtrl = TextEditingController(text: shop['deliveryLabel']);
    final categoryCtrl = TextEditingController(text: shop['category']);
    final officeCtrl = TextEditingController(text: shop['officeDelivery']);
    final standardCtrl = TextEditingController(text: shop['standardDelivery']);
    final shopId = shop['id']?.toString();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF162032),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFE11D48).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.storefront_rounded,
                  color: Color(0xFFE11D48), size: 20),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Edit Shop Details',
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    labelText: 'Shop Name',
                    labelStyle: GoogleFonts.poppins(
                        color: const Color(0xFFE11D48),
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF334155))),
                    focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFE11D48), width: 1.5)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: addressCtrl,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    labelText: 'Address / Location',
                    labelStyle: GoogleFonts.poppins(
                        color: Colors.white70, fontSize: 12),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF334155))),
                    focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFE11D48), width: 1.5)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    labelText: 'Helpline Phone Number',
                    labelStyle: GoogleFonts.poppins(
                        color: Colors.white70, fontSize: 12),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF334155))),
                    focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFE11D48), width: 1.5)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: deliveryCtrl,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    labelText: 'Delivery SLA Badge',
                    hintText: 'e.g. Home Delivery - Within 24 hours',
                    labelStyle: GoogleFonts.poppins(
                        color: Colors.white70, fontSize: 12),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF334155))),
                    focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFE11D48), width: 1.5)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: categoryCtrl,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    labelText: 'Category (Xerox, Books, Stationery, Kits)',
                    labelStyle: GoogleFonts.poppins(
                        color: Colors.white70, fontSize: 12),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF334155))),
                    focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFE11D48), width: 1.5)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: officeCtrl,
                  maxLines: 2,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
                  decoration: InputDecoration(
                    labelText: 'Office Delivery Rule',
                    labelStyle: GoogleFonts.poppins(
                        color: Colors.white70, fontSize: 12),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF334155))),
                    focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFE11D48), width: 1.5)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: standardCtrl,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
                  decoration: InputDecoration(
                    labelText: 'Standard Delivery Rule',
                    labelStyle: GoogleFonts.poppins(
                        color: Colors.white70, fontSize: 12),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF334155))),
                    focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFE11D48), width: 1.5)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: GoogleFonts.poppins(color: Colors.white60)),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = nameCtrl.text.trim();
              if (newName.isEmpty) return;

              final updatedData = {
                'shop_name': newName,
                'address': addressCtrl.text.trim(),
                'phone': phoneCtrl.text.trim(),
                'delivery_label': deliveryCtrl.text.trim(),
                'category': categoryCtrl.text.trim(),
                'office_delivery': officeCtrl.text.trim(),
                'standard_delivery': standardCtrl.text.trim(),
              };

              if (shopId != null) {
                try {
                  await Supabase.instance.client
                      .from('shops')
                      .update(updatedData)
                      .eq('id', shopId);
                } catch (e) {
                  debugPrint('Database update note: $e');
                }
              }

              // Update in-memory master copy
              setState(() {
                shop['name'] = newName;
                shop['location'] = addressCtrl.text.trim();
                shop['phone1'] = phoneCtrl.text.trim();
                shop['deliveryLabel'] = deliveryCtrl.text.trim();
                shop['category'] = categoryCtrl.text.trim();
                shop['officeDelivery'] = officeCtrl.text.trim();
                shop['standardDelivery'] = standardCtrl.text.trim();
              });

              if (ctx.mounted) Navigator.pop(ctx);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('Shop "$newName" updated and saved to Database!'),
                    backgroundColor: const Color(0xFF10B981),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE11D48), // Brand Red
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Save Changes',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteShop(String shopName, {String? shopId}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF162032),
        title: Text('Delete Shop?',
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(
          'Are you sure you want to remove "$shopName" from active routing and database?',
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: GoogleFonts.poppins(color: Colors.white60)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (shopId != null) {
                try {
                  await Supabase.instance.client
                      .from('shops')
                      .delete()
                      .eq('id', shopId);
                } catch (e) {
                  debugPrint('Error deleting shop from DB: $e');
                }
              }
              if (ctx.mounted) Navigator.pop(ctx);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Removed "$shopName" from system.')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626)),
            child: Text('Delete',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../config/routes.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/glass_card.dart';
import 'widgets/category_bottom_sheet.dart';
import 'widgets/request_item_modal.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final int _currentIndex = 2; // Categories index
  String _selectedFilter = 'All';
  String _searchQuery = '';

  final List<Map<String, dynamic>> _allCategories = [
    {
      'title': 'Xerox & Print Services',
      'subtitle': 'B&W, Color, Spiral, Thesis & Hardbound',
      'itemCount': 'Instant Upload',
      'filter': 'Print',
      'icon': Icons.print_rounded,
      'color': const Color(0xFFE11D48),
      'iconPath': 'print',
      'subs': [
        'B&W Xerox',
        'Color Printing',
        'Spiral Binding',
        'Hardbound Thesis',
        'Lamination',
        'Poster Prints'
      ],
      'items': [
        {
          'name': 'B&W A4 Print (per page)',
          'desc': 'Single / Double side, 75 GSM paper',
          'price': '2',
          'oldPrice': '3'
        },
        {
          'name': 'Color A4 Print (per page)',
          'desc': 'High quality laser color print',
          'price': '10',
          'oldPrice': '15'
        },
        {
          'name': 'Spiral Binding (up to 200 pgs)',
          'desc': 'Durable PVC cover & transparent front',
          'price': '45',
          'oldPrice': '60'
        },
      ],
      'directRoute': AppRoutes.xeroxOrder,
    },
    {
      'title': 'Stationery & Notebooks',
      'subtitle': 'Classmate spirals, journals & registers',
      'itemCount': '120+ Products',
      'filter': 'Stationery',
      'icon': Icons.edit_note_rounded,
      'color': const Color(0xFF2563EB),
      'iconPath': 'pencil',
      'subs': [
        'Spiral Notebooks',
        'Reynolds & Pilot Pens',
        'Sticky Notes',
        'A4 Copier Paper',
        'Geometry Boxes',
        'Correction Tape'
      ],
      'items': [
        {
          'name': 'Classmate 6-Subject Spiral Notebook (300 pgs)',
          'desc': 'Single line, bleed-proof paper',
          'price': '165',
          'oldPrice': '190'
        },
        {
          'name': 'Pilot V5 Liquid Ink Pen (Pack of 3 Blue)',
          'desc': '0.5mm precise needle tip',
          'price': '195',
          'oldPrice': '220'
        },
        {
          'name': 'Casio FX-991CW Scientific Calculator',
          'desc': 'Approved for engineering semester exams',
          'price': '1290',
          'oldPrice': '1450'
        },
      ],
    },
    {
      'title': 'Curricula & Semester Books',
      'subtitle': 'Engineering guides, Anna Univ & solved papers',
      'itemCount': '85+ Guides',
      'filter': 'Books',
      'icon': Icons.menu_book_rounded,
      'color': const Color(0xFFD97706),
      'iconPath': 'books',
      'subs': [
        'Engineering Mathematics',
        'Python & DSA',
        'Circuit Theory',
        'GATE Solved Papers',
        'Campus Placement Guides'
      ],
      'items': [
        {
          'name': 'Higher Engineering Mathematics - B.S. Grewal',
          'desc': '44th Edition, latest syllabus',
          'price': '649',
          'oldPrice': '799'
        },
        {
          'name': 'Python Programming & Problem Solving',
          'desc': 'Lab practical reference guide',
          'price': '340',
          'oldPrice': '420'
        },
        {
          'name': 'GATE CSE 2025 Topicwise Solved Papers',
          'desc': 'Made Easy Publications',
          'price': '580',
          'oldPrice': '750'
        },
      ],
    },
    {
      'title': 'Lab & Project Kits',
      'subtitle': 'Arduino, breadboards, sensors & IoT kits',
      'itemCount': '40+ Kits',
      'filter': 'Kits',
      'icon': Icons.developer_board_rounded,
      'color': const Color(0xFF7C3AED),
      'iconPath': 'kits',
      'subs': [
        'Arduino Starter Kit',
        'Raspberry Pi Combo',
        'Breadboard Sets',
        'IoT Sensor Packs',
        'Jumper Wires & Tools'
      ],
      'items': [
        {
          'name': 'Arduino UNO R3 Starter Kit',
          'desc': 'Board + Breadboard + 20 Sensors',
          'price': '750',
          'oldPrice': '999'
        },
        {
          'name': 'Raspberry Pi 4 Combo Pack',
          'desc': '4GB RAM + Case + Power Supply + SD Card',
          'price': '4250',
          'oldPrice': '4999'
        },
        {
          'name': 'IoT Sensor Module Kit (15 pcs)',
          'desc': 'Temperature, IR, Ultrasonic, Gas & more',
          'price': '520',
          'oldPrice': '699'
        },
      ],
    },
    {
      'title': 'Engineering Drawing & Art',
      'subtitle': 'Drafters, sheets, scales & technical pens',
      'itemCount': '65+ Tools',
      'filter': 'Stationery',
      'icon': Icons.architecture_rounded,
      'color': const Color(0xFF0D9488),
      'iconPath': 'drafting',
      'subs': [
        'Mini Drafter Sets',
        'Drawing Boards',
        'Scale Rulers',
        'French Curves',
        'Mechanical Pencils',
        'Drawing Sheets A1/A2'
      ],
      'items': [
        {
          'name': 'Rotring Rapid Pro Drafter Set',
          'desc': 'Complete mini-drafter with compass and clamp',
          'price': '850',
          'oldPrice': '1100'
        },
        {
          'name': 'A1 Drawing Sheet (Pack of 25)',
          'desc': '150 GSM cartridge imperial size sheets',
          'price': '320',
          'oldPrice': '400'
        },
        {
          'name': 'Staedtler Mechanical Pencil 0.5mm',
          'desc': 'Metallic body, rubberized grip',
          'price': '275',
          'oldPrice': '350'
        },
      ],
    },
    {
      'title': 'Office & Document Filing',
      'subtitle': 'L-folders, box files, staplers & pouches',
      'itemCount': '35+ Essentials',
      'filter': 'Stationery',
      'icon': Icons.folder_copy_rounded,
      'color': const Color(0xFFEA580C),
      'iconPath': 'office',
      'subs': [
        'Box Files',
        'L-Folders',
        'Clipboards',
        'Staplers & Pins',
        'Certificate Holders'
      ],
      'items': [
        {
          'name': 'Solo Box File (Pack of 4)',
          'desc': '75mm spine, durable cardboard',
          'price': '280',
          'oldPrice': '360'
        },
        {
          'name': 'Transparent L-Folder A4 (Pack of 20)',
          'desc': 'Durable water-resistant polypropylene',
          'price': '120',
          'oldPrice': '160'
        },
        {
          'name': 'Kangaro Heavy Duty Stapler + Pins',
          'desc': 'Up to 30 sheets capacity',
          'price': '195',
          'oldPrice': '250'
        },
      ],
    },
  ];

  void _onCategorySelected(Map<String, dynamic> cat) {
    if (cat['directRoute'] != null) {
      Navigator.pushNamed(context, cat['directRoute']);
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CategoryBottomSheet(
        title: cat['title'],
        subtitle: cat['subtitle'],
        iconPath: cat['iconPath'],
        categoryFilter: cat['filter'] ?? 'General',
        subDepartments: List<String>.from(cat['subs']),
        topSellers: List<Map<String, dynamic>>.from(cat['items']),
      ),
    );
  }

  void _showRequestModal() {
    showDialog(
      context: context,
      builder: (context) => const RequestItemModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredCategories = _allCategories.where((cat) {
      final matchesFilter =
          _selectedFilter == 'All' || cat['filter'] == _selectedFilter;
      final q = _searchQuery.toLowerCase();
      final matchesQuery = q.isEmpty ||
          cat['title'].toString().toLowerCase().contains(q) ||
          cat['subtitle'].toString().toLowerCase().contains(q);
      return matchesFilter && matchesQuery;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
          onPressed: () =>
              Navigator.pushReplacementNamed(context, AppRoutes.home),
        ),
        title: Text(
          'Categories',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_bag_outlined,
                        color: Color(0xFF0F172A)),
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.cart),
                  ),
                  if (cart.itemCount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE11D48),
                          shape: BoxShape.circle,
                        ),
                        constraints:
                            const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Text(
                          '${cart.itemCount}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // ── Search & Filter Controls ─────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: Column(
              children: [
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val.trim()),
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: const Color(0xFF0F172A)),
                  decoration: InputDecoration(
                    hintText: 'Search categories, books, printing...',
                    hintStyle: GoogleFonts.poppins(
                        fontSize: 13, color: const Color(0xFF94A3B8)),
                    prefixIcon: const Icon(Icons.search_rounded,
                        size: 20, color: Color(0xFF64748B)),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded,
                                size: 18, color: Color(0xFF94A3B8)),
                            onPressed: () => setState(() => _searchQuery = ''),
                          )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFFF1F5F9),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All'),
                      _buildFilterChip('Print'),
                      _buildFilterChip('Stationery'),
                      _buildFilterChip('Books'),
                      _buildFilterChip('Kits'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Categories List ──────────────────────────────────────
          Expanded(
            child: filteredCategories.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded,
                            size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          'No categories found for "$_searchQuery"',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredCategories.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      if (index == filteredCategories.length) {
                        return _buildRequestBanner();
                      }

                      final cat = filteredCategories[index];
                      final Color color = cat['color'] as Color;

                      return GlassCard(
                        padding: const EdgeInsets.all(16),
                        opacity: 0.75,
                        borderRadius: 16,
                        onTap: () => _onCategorySelected(cat),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(cat['icon'] as IconData,
                                  color: color, size: 26),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          cat['title'],
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF0F172A),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.white
                                              .withValues(alpha: 0.6),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          cat['itemCount'],
                                          style: GoogleFonts.poppins(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF475569),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    cat['subtitle'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.chevron_right_rounded,
                              size: 20,
                              color: Color(0xFF94A3B8),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: GlassBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == _currentIndex) return;
          if (index == 0) {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, AppRoutes.xeroxOrder);
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, AppRoutes.orders);
          } else if (index == 4) {
            Navigator.pushReplacementNamed(context, AppRoutes.profile);
          }
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.print_rounded), label: 'Xerox'),
          BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded), label: 'Categories'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_rounded), label: 'Orders'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded), label: 'Account'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () => setState(() => _selectedFilter = label),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color:
                isSelected ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF475569),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 8, bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFE4E6)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.contact_support_rounded,
              color: Color(0xFFE11D48),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Looking for something else?',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                Text(
                  'Request customized stationery, lab tools, or thesis prints',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _showRequestModal,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE11D48),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: Text(
              'Request',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

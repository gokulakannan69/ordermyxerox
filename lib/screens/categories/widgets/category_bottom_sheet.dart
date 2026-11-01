import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/cart_item.dart';
import '../../../providers/cart_provider.dart';

class CategoryBottomSheet extends StatefulWidget {
  final String title;
  final String subtitle;
  final String iconPath;
  final String categoryFilter;
  final List<String> subDepartments;
  final List<Map<String, dynamic>> topSellers;

  const CategoryBottomSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconPath,
    this.categoryFilter = 'General',
    required this.subDepartments,
    required this.topSellers,
  });

  @override
  State<CategoryBottomSheet> createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<CategoryBottomSheet> {
  List<Map<String, dynamic>> _liveItems = [];
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadLiveProducts();
  }

  Future<void> _loadLiveProducts() async {
    try {
      final res = await Supabase.instance.client
          .from('products')
          .select()
          .eq('is_available', true)
          .order('created_at', ascending: false);

      final dbProducts = List<Map<String, dynamic>>.from(res);

      final matchingLive = dbProducts.where((p) {
        final cat = p['category']?.toString().toLowerCase() ?? '';
        final current = widget.categoryFilter.toLowerCase();
        return cat.contains(current) || current.contains(cat);
      }).toList();

      final List<Map<String, dynamic>> displayItems = [];
      for (final p in matchingLive) {
        final num priceNum = p['base_price'] is num
            ? p['base_price']
            : num.tryParse(p['base_price']?.toString() ?? '0') ?? 0;
        displayItems.add({
          'name': p['name'] ?? '',
          'desc':
              p['description'] ?? 'Instant campus stock • Ready for delivery',
          'price': priceNum.toInt().toString(),
          'oldPrice': (priceNum * 1.3).toInt().toString(),
          'isLive': true,
        });
      }

      if (mounted) {
        setState(() {
          _liveItems = displayItems;
          _isRefreshing = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading category items: $e');
      if (mounted) setState(() => _isRefreshing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color iconBgColor;
    Color iconColor;
    switch (widget.iconPath) {
      case 'pencil':
        icon = Icons.edit_note_rounded;
        iconBgColor = const Color(0xFFFFE4E6);
        iconColor = const Color(0xFFE11D48);
        break;
      case 'books':
        icon = Icons.menu_book_rounded;
        iconBgColor = const Color(0xFFFEF3C7);
        iconColor = const Color(0xFFD97706);
        break;
      case 'print':
        icon = Icons.print_rounded;
        iconBgColor = const Color(0xFFFFE4E6);
        iconColor = const Color(0xFFE11D48);
        break;
      case 'kits':
        icon = Icons.business_center_rounded;
        iconBgColor = const Color(0xFFE0E7FF);
        iconColor = const Color(0xFF4F46E5);
        break;
      case 'drafting':
        icon = Icons.architecture_rounded;
        iconBgColor = const Color(0xFFCCFBF1);
        iconColor = const Color(0xFF0D9488);
        break;
      case 'office':
        icon = Icons.folder_copy_rounded;
        iconBgColor = const Color(0xFFFEF3C7);
        iconColor = const Color(0xFFEA580C);
        break;
      default:
        icon = Icons.category_rounded;
        iconBgColor = const Color(0xFFF1F5F9);
        iconColor = const Color(0xFF64748B);
    }

    final List<Map<String, dynamic>> combinedDisplayItems =
        List.from(_liveItems);
    for (final item in widget.topSellers) {
      if (!combinedDisplayItems.any((d) => d['name'] == item['name'])) {
        combinedDisplayItems.add(item);
      }
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: iconBgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: iconColor, size: 26),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              widget.subtitle,
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF64748B),
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, size: 20),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFF1F5F9),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Sub-departments Wrap
            Text(
              'SUB-DEPARTMENTS',
              style: GoogleFonts.poppins(
                color: const Color(0xFF94A3B8),
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.subDepartments.map((sub) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Text(
                    sub,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF475569),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 22),

            // Real-Time Live Catalog Products
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'CATALOG PRODUCTS',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF94A3B8),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                InkWell(
                  onTap: _isRefreshing
                      ? null
                      : () {
                          setState(() => _isRefreshing = true);
                          _loadLiveProducts();
                        },
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        _isRefreshing
                            ? const SizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(
                                    strokeWidth: 1.5, color: Color(0xFF2563EB)),
                              )
                            : const Icon(Icons.refresh_rounded,
                                size: 12, color: Color(0xFF2563EB)),
                        const SizedBox(width: 4),
                        Text(
                          _isRefreshing ? 'Checking...' : 'Refresh',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF2563EB),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Efficient cached items without continuous stream reloads
            Column(
              children: combinedDisplayItems.map((item) {
                final isLiveDb = item['isLive'] == true;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isLiveDb
                          ? const Color(0xFF10B981).withValues(alpha: 0.3)
                          : const Color(0xFFE2E8F0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item['name'],
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                      color: const Color(0xFF0F172A),
                                    ),
                                  ),
                                ),
                                if (isLiveDb)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF10B981)
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'NEW',
                                      style: GoogleFonts.poppins(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF059669),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              item['desc'],
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF64748B),
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Text(
                                  '₹${item['price']}',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '₹${item['oldPrice']}',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF94A3B8),
                                    fontSize: 11,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          final price =
                              double.tryParse(item['price'].toString()) ?? 0.0;
                          final cartItem = CartItemModel(
                            id: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                            serviceName: item['name'],
                            pricePerPage: price,
                          );
                          Provider.of<CartProvider>(context, listen: false)
                              .addItem(cartItem);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Added "${item['name']}" to cart!'),
                              backgroundColor: const Color(0xFF0F172A),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE11D48),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          elevation: 0,
                        ),
                        child: Text(
                          'ADD +',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  'Back to Categories',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF475569),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

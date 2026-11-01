import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../xerox_widgets.dart';
import '../../../widgets/glass_card.dart';

class ShopSelectionStep extends StatefulWidget {
  final int selectedShopIndex;
  final ValueChanged<int> onShopSelected;

  const ShopSelectionStep({
    super.key,
    required this.selectedShopIndex,
    required this.onShopSelected,
  });

  @override
  State<ShopSelectionStep> createState() => _ShopSelectionStepState();
}

class _ShopSelectionStepState extends State<ShopSelectionStep> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _fallbackShops = [
    {
      'shop_name': 'SK Xerox & Digital',
      'address': 'Main Road, Salem • 1.2 km away',
      'is_open': true,
      'delivery_label': 'Ready in 20 min',
      'category': 'Xerox',
      'price_from': '₹1.50/page',
      'rating': 4.8,
      'order_count': '320+ orders',
      'has_free_pickup': true,
    },
    {
      'shop_name': 'Campus Print Hub',
      'address': 'University Gate 2 • 2.5 km away',
      'is_open': true,
      'delivery_label': 'Ready in 10-15 min',
      'category': 'Xerox',
      'price_from': '₹1.20/page',
      'rating': 4.5,
      'order_count': '180+ orders',
      'has_free_pickup': false,
    },
    {
      'shop_name': 'Quick Copy Center',
      'address': 'Bus Stand Road • 3.1 km away',
      'is_open': false,
      'delivery_label': 'Ready in 30 min',
      'category': 'Xerox',
      'price_from': '₹1.00/page',
      'rating': 4.2,
      'order_count': '95+ orders',
      'has_free_pickup': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title ──
          Text('Choose a xerox shop',
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: XeroxColors.darkText)),
          const SizedBox(height: 6),
          Text(
            'Select the best print partner near your location for instant processing.',
            style: GoogleFonts.poppins(
                fontSize: 13, color: XeroxColors.grayText, height: 1.5),
          ),
          const SizedBox(height: 16),

          // ── Search bar ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: XeroxColors.cardWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: XeroxColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, size: 20, color: XeroxColors.hintText),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    onChanged: (val) =>
                        setState(() => _searchQuery = val.trim().toLowerCase()),
                    decoration: InputDecoration(
                      hintText: 'Search shops by name or area...',
                      hintStyle: GoogleFonts.poppins(
                          fontSize: 13, color: XeroxColors.hintText),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Realtime DB Live Shop Stream ──
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: Supabase.instance.client.from('shops').stream(
                primaryKey: ['id']).order('created_at', ascending: false),
            builder: (context, snapshot) {
              final liveShops = (snapshot.hasData && snapshot.data!.isNotEmpty)
                  ? snapshot.data!
                  : _fallbackShops;

              final filtered = liveShops.where((s) {
                if (_searchQuery.isEmpty) return true;
                final name = (s['shop_name'] ?? s['name'] ?? '')
                    .toString()
                    .toLowerCase();
                final addr = (s['address'] ?? s['location'] ?? '')
                    .toString()
                    .toLowerCase();
                return name.contains(_searchQuery) ||
                    addr.contains(_searchQuery);
              }).toList();

              if (filtered.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      'No partner shops found matching "$_searchQuery"',
                      style:
                          GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
                    ),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filtered.length,
                separatorBuilder: (ctx, idx) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final shop = filtered[index];
                  final name =
                      shop['shop_name'] ?? shop['name'] ?? 'Partner Shop';
                  final addr =
                      shop['address'] ?? shop['location'] ?? 'Salem Hub';
                  final isOpen = shop['is_open'] ?? true;
                  final readyTime = shop['delivery_label'] ?? 'Ready in 20 min';
                  final priceFrom = shop['price_from'] ?? '₹1.00/page';
                  final rating = (shop['rating'] is num)
                      ? (shop['rating'] as num).toDouble()
                      : 4.8;
                  final orderCount = shop['order_count'] ?? '150+ orders';
                  final hasFreePickup = shop['has_free_pickup'] ?? true;

                  return _ShopCard(
                    index: index,
                    name: name,
                    address: addr,
                    isOpen: isOpen,
                    readyTime: readyTime,
                    priceFrom: priceFrom,
                    rating: rating,
                    orderCount: orderCount,
                    hasFreePickup: hasFreePickup,
                    isSelected: widget.selectedShopIndex == index,
                    onTap: () => widget.onShopSelected(index),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ── Individual shop card ──
class _ShopCard extends StatelessWidget {
  final int index;
  final String name;
  final String address;
  final bool isOpen;
  final String readyTime;
  final String priceFrom;
  final double rating;
  final String orderCount;
  final bool hasFreePickup;
  final bool isSelected;
  final VoidCallback onTap;

  const _ShopCard({
    required this.index,
    required this.name,
    required this.address,
    required this.isOpen,
    required this.readyTime,
    required this.priceFrom,
    required this.rating,
    required this.orderCount,
    required this.hasFreePickup,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      borderRadius: 18,
      opacity: 0.94,
      tintColor: isSelected ? const Color(0xFFFFF1F2) : Colors.white,
      customBorder: Border.all(
        color: isSelected ? const Color(0xFFE11D48) : const Color(0xFFE2E8F0),
        width: isSelected ? 1.8 : 1.0,
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name + Open badge
          Row(
            children: [
              Expanded(
                child: Text(name,
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: XeroxColors.darkText)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isOpen
                      ? XeroxColors.successLight
                      : XeroxColors.warningLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(isOpen ? 'Open' : 'Closed',
                    style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isOpen
                            ? XeroxColors.success
                            : XeroxColors.warning)),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Address
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 14, color: XeroxColors.grayText),
              const SizedBox(width: 4),
              Expanded(
                child: Text(address,
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: XeroxColors.grayText)),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Ready time + Price
          Row(
            children: [
              const Icon(Icons.access_time,
                  size: 14, color: XeroxColors.grayText),
              const SizedBox(width: 4),
              Text(readyTime,
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: XeroxColors.bodyText)),
              const SizedBox(width: 16),
              const Icon(Icons.currency_rupee,
                  size: 14, color: XeroxColors.grayText),
              Text('From $priceFrom',
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: XeroxColors.bodyText,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 10),

          // Rating + Order count + Free Pickup
          Row(
            children: [
              const Icon(Icons.star, size: 14, color: Color(0xFFF59E0B)),
              const SizedBox(width: 3),
              Text('$rating',
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: XeroxColors.darkText)),
              const SizedBox(width: 4),
              Text('($orderCount)',
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: XeroxColors.grayText)),
              const Spacer(),
              if (hasFreePickup)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: XeroxColors.successLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_shipping_outlined,
                          size: 12, color: XeroxColors.success),
                      const SizedBox(width: 3),
                      Text('Free Pickup available',
                          style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: XeroxColors.success)),
                    ],
                  ),
                ),
            ],
          ),

          // Selected indicator
          if (isSelected) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle,
                    size: 16, color: XeroxColors.primaryRed),
                const SizedBox(width: 4),
                Text('Selected',
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: XeroxColors.primaryRed)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

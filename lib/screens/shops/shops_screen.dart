import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../config/theme.dart';

class ShopsScreen extends StatelessWidget {
  const ShopsScreen({super.key});

  final List<Map<String, dynamic>> _fallbackShops = const [
    {
      'shop_name': 'Campus Xerox Center',
      'address': '0.2 km away',
      'rating': '4.9',
      'status': 'Active Now'
    },
    {
      'shop_name': 'Sri Sai Prints',
      'address': '1.5 km away',
      'rating': '4.5',
      'status': 'Active Now'
    },
    {
      'shop_name': 'Krishna Stationery & Xerox',
      'address': '2.8 km away',
      'rating': '4.2',
      'status': 'Closed'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded,
                color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context)),
        title: Text('Nearby Xerox Shops',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: Supabase.instance.client
            .from('shops')
            .stream(primaryKey: ['id']).order('created_at', ascending: false),
        builder: (context, snapshot) {
          final shops = (snapshot.hasData && snapshot.data!.isNotEmpty)
              ? snapshot.data!
              : _fallbackShops;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: shops.length,
            itemBuilder: (context, index) {
              final s = shops[index];
              final name = s['shop_name'] ?? s['name'] ?? 'Partner Shop';
              final addr = s['address'] ?? s['location'] ?? 'Salem Area';
              final isOpen = s['is_open'] == true;
              return _buildShopCard(name, addr, '4.8',
                  isOpen ? 'Active Now' : 'Closed', const Color(0xFFE11D48));
            },
          );
        },
      ),
    );
  }

  Widget _buildShopCard(String name, String distance, String rating,
      String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 120,
            decoration: const BoxDecoration(
              color: Color(0xFFE2E8F0),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: const Center(
                child: Icon(Icons.storefront_rounded,
                    size: 64, color: Colors.black26)),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(name,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold, fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis)),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(rating,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(distance,
                        style: GoogleFonts.poppins(
                            color: AppColors.textSecondary, fontSize: 13)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12)),
                      child: Text(status,
                          style: GoogleFonts.poppins(
                              color: statusColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

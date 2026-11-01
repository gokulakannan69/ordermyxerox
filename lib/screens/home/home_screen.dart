import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../models/cart_item.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/glass_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static bool needsRefresh = false;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _selectedFilter = 'All';
  final PageController _bannerController = PageController();
  int _activeBannerIndex = 0;
  Timer? _bannerTimer;

  final List<String> _filters = ['All', 'Xerox', 'Stationery', 'Books', 'Kits'];

  // Flipkart/Swiggy styled dynamic promo banners (syncs from DB + fallback)
  List<Map<String, dynamic>> _offerBanners = [
    {
      'tag': 'FLAT 50% OFF',
      'code': 'WELCOME50',
      'title': 'First Xerox Order?',
      'subtitle': 'Get 50% Cashback + Instant Spiral Binding',
      'gradient': [const Color(0xFFE11D48), const Color(0xFF9F1239)],
      'icon': Icons.print_rounded,
      'badge': 'NEW USER',
      'badgeColor': const Color(0xFFFBBF24),
    },
    {
      'tag': 'STUDENT DEAL',
      'code': 'EXAM20',
      'title': 'Semester Exam Pack',
      'subtitle': 'Free Delivery on Orders above ₹99',
      'gradient': [const Color(0xFF4F46E5), const Color(0xFF312E81)],
      'icon': Icons.menu_book_rounded,
      'badge': 'TRENDING',
      'badgeColor': const Color(0xFF34D399),
    },
    {
      'tag': 'FLASH OFFER',
      'code': 'COLOR30',
      'title': 'Color Prints at ₹3.5/pg',
      'subtitle': 'Lab Record & Project Submission special',
      'gradient': [const Color(0xFF0D9488), const Color(0xFF115E59)],
      'icon': Icons.color_lens_rounded,
      'badge': 'LIMITED',
      'badgeColor': const Color(0xFFF43F5E),
    },
  ];

  final List<Map<String, dynamic>> _defaultBannersFallback = [
    {
      'tag': 'FLAT 50% OFF',
      'code': 'WELCOME50',
      'title': 'First Xerox Order?',
      'subtitle': 'Get 50% Cashback + Instant Spiral Binding',
      'gradient': [const Color(0xFFE11D48), const Color(0xFF9F1239)],
      'icon': Icons.print_rounded,
      'badge': 'NEW USER',
      'badgeColor': const Color(0xFFFBBF24),
    },
    {
      'tag': 'STUDENT DEAL',
      'code': 'EXAM20',
      'title': 'Semester Exam Pack',
      'subtitle': 'Free Delivery on Orders above ₹99',
      'gradient': [const Color(0xFF4F46E5), const Color(0xFF312E81)],
      'icon': Icons.menu_book_rounded,
      'badge': 'TRENDING',
      'badgeColor': const Color(0xFF34D399),
    },
    {
      'tag': 'FLASH OFFER',
      'code': 'COLOR30',
      'title': 'Color Prints at ₹3.5/pg',
      'subtitle': 'Lab Record & Project Submission special',
      'gradient': [const Color(0xFF0D9488), const Color(0xFF115E59)],
      'icon': Icons.color_lens_rounded,
      'badge': 'LIMITED',
      'badgeColor': const Color(0xFFF43F5E),
    },
  ];

  // Swiggy/Zomato style curated quick categories
  final List<Map<String, dynamic>> _quickCategories = [
    {
      'title': 'Instant Xerox',
      'subtitle': 'from ₹0.75/pg',
      'icon': Icons.print_rounded,
      'color': const Color(0xFFFFE4E6),
      'iconColor': const Color(0xFFE11D48),
      'route': AppRoutes.xeroxOrder,
      'tag': '20 MINS',
    },
    {
      'title': 'Color Prints',
      'subtitle': 'Glossy & Matt',
      'icon': Icons.palette_rounded,
      'color': const Color(0xFFE0E7FF),
      'iconColor': const Color(0xFF4F46E5),
      'route': AppRoutes.xeroxOrder,
      'tag': 'HOT',
    },
    {
      'title': 'Spiral & Bind',
      'subtitle': 'Hard & Soft',
      'icon': Icons.auto_stories_rounded,
      'color': const Color(0xFFFEF3C7),
      'iconColor': const Color(0xFFD97706),
      'route': AppRoutes.xeroxOrder,
      'tag': 'PRO',
    },
    {
      'title': 'Stationery',
      'subtitle': 'Pens & Files',
      'icon': Icons.edit_note_rounded,
      'color': const Color(0xFFCCFBF1),
      'iconColor': const Color(0xFF0D9488),
      'route': AppRoutes.categories,
      'tag': 'DEALS',
    },
    {
      'title': 'Engineering Kits',
      'subtitle': 'Drafters & Tools',
      'icon': Icons.architecture_rounded,
      'color': const Color(0xFFFCE7F3),
      'iconColor': const Color(0xFFDB2777),
      'route': AppRoutes.categories,
      'tag': 'LABS',
    },
    {
      'title': 'Textbooks',
      'subtitle': 'Syllabus Guides',
      'icon': Icons.menu_book_rounded,
      'color': const Color(0xFFEDE9FE),
      'iconColor': const Color(0xFF7C3AED),
      'route': AppRoutes.categories,
      'tag': 'GUIDES',
    },
  ];

  // Swiggy/Zomato style flash coupon strips
  final List<Map<String, dynamic>> _stripCoupons = [
    {
      'icon': Icons.bolt_rounded,
      'title': 'FLAT ₹50 OFF',
      'desc': 'On orders over ₹199',
      'code': 'SPEEDY50',
      'color': const Color(0xFFEA580C),
    },
    {
      'icon': Icons.local_shipping_rounded,
      'title': 'FREE PICKUP & DROP',
      'desc': 'Campus hostels & classes',
      'code': 'FREEDEL',
      'color': const Color(0xFF059669),
    },
    {
      'icon': Icons.stars_rounded,
      'title': 'BUY 1 GET 1 SPIRAL',
      'desc': 'On lab records',
      'code': 'BOGOBIND',
      'color': const Color(0xFF7C3AED),
    },
  ];

  bool _isLoadingProducts = false;
  List<Map<String, dynamic>> _liveProducts = [];

  // Default initial catalog
  static const List<Map<String, dynamic>> _defaultCatalog = [
    {
      'name': 'Classmate 6-Subject Spiral Notebook',
      'category': 'Stationery',
      'base_price': 165,
      'image_url':
          'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400&q=80',
    },
    {
      'name': 'Pilot V5 Liquid Ink Pen (Pack of 3)',
      'category': 'Stationery',
      'base_price': 195,
      'image_url':
          'https://images.unsplash.com/photo-1583485088034-697b5bc54ccd?w=400&q=80',
    },
    {
      'name': 'Higher Engineering Mathematics - BS Grewal',
      'category': 'Books',
      'base_price': 649,
      'image_url':
          'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400&q=80',
    },
    {
      'name': 'Arduino UNO R3 Starter Kit + Sensors',
      'category': 'Kits',
      'base_price': 750,
      'image_url':
          'https://images.unsplash.com/photo-1518770660439-4636190af475?w=400&q=80',
    },
    {
      'name': 'Rotring Rapid Pro Mini Drafter',
      'category': 'Stationery',
      'base_price': 850,
      'image_url':
          'https://images.unsplash.com/photo-1513542789411-b6a5d4f31634?w=400&q=80',
    },
    {
      'name': 'B&W A4 Double Side Xerox (Per Page)',
      'category': 'Xerox',
      'base_price': 2,
      'image_url':
          'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=400&q=80',
    },
  ];

  @override
  void initState() {
    super.initState();
    _liveProducts = List.from(_defaultCatalog);
    _fetchProductsOnce();

    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_bannerController.hasClients) {
        final nextPage = (_activeBannerIndex + 1) % _offerBanners.length;
        _bannerController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (HomeScreen.needsRefresh) {
      HomeScreen.needsRefresh = false;
      _fetchProductsOnce();
    }
  }

  // Efficient one-time fetch & manual refresh (saves battery, data and CPU)
  Future<void> _fetchProductsOnce() async {
    try {
      // 1. Fetch live products from DB
      final res = await Supabase.instance.client
          .from('products')
          .select()
          .eq('is_available', true)
          .order('created_at', ascending: false);

      final List<Map<String, dynamic>> dbProducts =
          List<Map<String, dynamic>>.from(res);
      final List<Map<String, dynamic>> merged = List.from(dbProducts);

      for (final item in _defaultCatalog) {
        if (!merged.any((p) =>
            (p['name']?.toString().toLowerCase() ?? '') ==
            item['name'].toString().toLowerCase())) {
          merged.add(item);
        }
      }

      // 2. Fetch live ad banners from DB
      List<Map<String, dynamic>> updatedBanners =
          List.from(_defaultBannersFallback);
      try {
        final bannerRes = await Supabase.instance.client
            .from('banners')
            .select()
            .eq('is_active', true)
            .order('created_at', ascending: false);

        if (bannerRes.isNotEmpty) {
          final List<Map<String, dynamic>> dynamicBanners = [];
          final gradients = [
            [const Color(0xFFE11D48), const Color(0xFF9F1239)],
            [const Color(0xFF4F46E5), const Color(0xFF312E81)],
            [const Color(0xFF0D9488), const Color(0xFF115E59)],
            [const Color(0xFF7C3AED), const Color(0xFF4C1D95)],
          ];

          for (int i = 0; i < bannerRes.length; i++) {
            final b = bannerRes[i];
            dynamicBanners.add({
              'tag': b['tag'] ?? b['price_text'] ?? 'SPECIAL OFFER',
              'code': b['code'] ?? 'OFFER${i + 1}',
              'title': b['title'] ?? 'Exclusive Deal',
              'subtitle': b['subtitle'] ??
                  'Order now and enjoy instant campus delivery',
              'gradient': gradients[i % gradients.length],
              'icon': Icons.print_rounded,
              'badge': b['price_text'] != null &&
                      b['price_text'].toString().isNotEmpty
                  ? b['price_text'].toString()
                  : 'OFFER',
              'badgeColor': const Color(0xFFFBBF24),
              'image_url': b['image_url'],
            });
          }
          if (dynamicBanners.isNotEmpty) {
            updatedBanners = dynamicBanners;
          }
        }
      } catch (err) {
        debugPrint('Banner fetch note: $err');
      }

      if (mounted) {
        setState(() {
          _liveProducts = merged;
          _offerBanners = updatedBanners;
          _isLoadingProducts = false;
        });
      }
    } catch (e) {
      debugPrint('Manual fetch error: $e');
      if (mounted) setState(() => _isLoadingProducts = false);
    }
  }

  Future<void> _handleManualRefresh() async {
    setState(() => _isLoadingProducts = true);
    await _fetchProductsOnce();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                'Products refreshed! (${_liveProducts.length} items available)',
                style: GoogleFonts.poppins(fontSize: 12),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF10B981),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Swiggy/Zomato Delivery Location pill
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Delivery available across all campus blocks & hostels!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE4E6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.location_on_rounded,
                                color: AppColors.primary, size: 18),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Campus Central',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF0F172A),
                                      ),
                                    ),
                                    const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        size: 16,
                                        color: Color(0xFF64748B)),
                                  ],
                                ),
                                Text(
                                  'Delivery in 20-30 mins',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF10B981),
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
                  ),

                  // Cart Icon with badge
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_bag_outlined,
                            color: Color(0xFF0F172A)),
                        onPressed: () =>
                            Navigator.pushNamed(context, AppRoutes.cart),
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Consumer<CartProvider>(
                          builder: (context, cart, child) {
                            if (cart.itemCount == 0) {
                              return const SizedBox.shrink();
                            }
                            return Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${cart.itemCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  // Account / Profile Avatar
                  InkWell(
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.profile),
                    borderRadius: BorderRadius.circular(20),
                    child: const CircleAvatar(
                      radius: 17,
                      backgroundColor: Color(0xFF0F172A),
                      child: Icon(Icons.person_rounded,
                          color: Colors.white, size: 19),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _handleManualRefresh,
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Flipkart/Zomato Search & Quick Xerox Bar ──
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search prints, notes, pens, books...',
                            hintStyle: GoogleFonts.poppins(
                                color: const Color(0xFF94A3B8), fontSize: 13),
                            prefixIcon: const Icon(Icons.search_rounded,
                                color: AppColors.primary, size: 20),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Mic / Scan button
                    InkWell(
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.xeroxOrder),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE11D48), Color(0xFFBE123C)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE11D48)
                                  .withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.upload_file_rounded,
                                color: Colors.white, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              'Print Now',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Carousel Offer Banners (Flipkart / Swiggy Style) ──
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                  height: 165,
                  child: PageView.builder(
                    controller: _bannerController,
                    itemCount: _offerBanners.length,
                    onPageChanged: (idx) =>
                        setState(() => _activeBannerIndex = idx),
                    itemBuilder: (context, idx) {
                      final banner = _offerBanners[idx];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: banner['gradient'],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: (banner['gradient'][0] as Color)
                                    .withValues(alpha: 0.35),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Optional uploaded banner photo or watermark pattern
                              if (banner['image_url'] != null &&
                                  banner['image_url'].toString().isNotEmpty)
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: banner['image_url']
                                            .toString()
                                            .startsWith('http')
                                        ? Image.network(
                                            banner['image_url'],
                                            fit: BoxFit.cover,
                                            errorBuilder: (c, e, s) =>
                                                const SizedBox.shrink(),
                                          )
                                        : (File(banner['image_url'])
                                                .existsSync()
                                            ? Image.file(
                                                File(banner['image_url']),
                                                fit: BoxFit.cover,
                                              )
                                            : const SizedBox.shrink()),
                                  ),
                                ),
                              if (banner['image_url'] != null &&
                                  banner['image_url'].toString().isNotEmpty)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black.withValues(alpha: 0.75),
                                          Colors.black.withValues(alpha: 0.35),
                                        ],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                      ),
                                    ),
                                  ),
                                ),
                              // Background watermark pattern
                              Positioned(
                                right: -15,
                                bottom: -20,
                                child: Icon(
                                  banner['icon'] ?? Icons.print_rounded,
                                  size: 150,
                                  color: Colors.white.withValues(alpha: 0.12),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(18),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: banner['badgeColor'],
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            banner['badge'],
                                            style: GoogleFonts.poppins(
                                              color: const Color(0xFF0F172A),
                                              fontSize: 9,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.white
                                                .withValues(alpha: 0.2),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            banner['tag'],
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 9,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          banner['title'],
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                            height: 1.15,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          banner['subtitle'],
                                          style: GoogleFonts.poppins(
                                            color: Colors.white
                                                .withValues(alpha: 0.9),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Promo Code ${banner['code']} applied to your order!'),
                                                backgroundColor:
                                                    const Color(0xFF10B981),
                                              ),
                                            );
                                            Navigator.pushNamed(
                                                context, AppRoutes.xeroxOrder);
                                          },
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 14, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Apply ${banner['code']}',
                                                  style: GoogleFonts.poppins(
                                                    color:
                                                        const Color(0xFF0F172A),
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                const Icon(
                                                    Icons.arrow_forward_rounded,
                                                    size: 13,
                                                    color: Color(0xFF0F172A)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Banner indicator dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_offerBanners.length, (idx) {
                  final isActive = idx == _activeBannerIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
                    width: isActive ? 18 : 6,
                    height: 5,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primary
                          : const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 12),

              // ── Swiggy/Zomato Flash Coupon Ticket Strip ──
              SizedBox(
                height: 48,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: _stripCoupons.length,
                  separatorBuilder: (context, idx) => const SizedBox(width: 10),
                  itemBuilder: (context, idx) {
                    final cp = _stripCoupons[idx];
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color:
                                (cp['color'] as Color).withValues(alpha: 0.3)),
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
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: (cp['color'] as Color)
                                  .withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child:
                                Icon(cp['icon'], size: 16, color: cp['color']),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                cp['title'],
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              Text(
                                cp['desc'],
                                style: GoogleFonts.poppins(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Copied coupon: ${cp['code']}!'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: (cp['color'] as Color)
                                    .withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                cp['code'],
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: cp['color'],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // ── What's on your mind? (Swiggy Style Grid Circles) ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'WHAT ARE YOU PRINTING TODAY?',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                        Text(
                          'Top Services & Kits',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.categories),
                      child: Row(
                        children: [
                          Text(
                            'See All',
                            style: GoogleFonts.poppins(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded,
                              size: 11, color: AppColors.primary),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Quick Category Cards (3 columns Swiggy / Flipkart grid)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _quickCategories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, idx) {
                    final cat = _quickCategories[idx];
                    return GlassCard(
                      onTap: () => Navigator.pushNamed(context, cat['route']),
                      borderRadius: 18,
                      opacity: 0.94,
                      tintColor: Colors.white,
                      customBorder: Border.all(
                        color:
                            (cat['iconColor'] as Color).withValues(alpha: 0.18),
                        width: 1.2,
                      ),
                      padding: EdgeInsets.zero,
                      child: Stack(
                        children: [
                          // Top corner micro tag (e.g. 20 MINS, HOT, DEALS)
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(
                                color: (cat['iconColor'] as Color)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                cat['tag'],
                                style: GoogleFonts.poppins(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800,
                                  color: cat['iconColor'],
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: cat['color'],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(cat['icon'],
                                        color: cat['iconColor'], size: 24),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    cat['title'],
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF0F172A),
                                    ),
                                  ),
                                  Text(
                                    cat['subtitle'],
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // ── Flipkart Style "Deals of the Day" / Filter Chips ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBBF24).withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.flash_on_rounded,
                          color: Color(0xFFD97706), size: 18),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Deals of the Day',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const Spacer(),
                    // Manual Refresh Button (stops auto-reload battery/performance drain)
                    InkWell(
                      onTap: _isLoadingProducts ? null : _handleManualRefresh,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFDBEAFE)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _isLoadingProducts
                                ? const SizedBox(
                                    width: 12,
                                    height: 12,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFF2563EB)),
                                  )
                                : const Icon(Icons.refresh_rounded,
                                    size: 14, color: Color(0xFF2563EB)),
                            const SizedBox(width: 4),
                            Text(
                              _isLoadingProducts ? 'Syncing...' : 'Refresh',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF2563EB),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Filter Chips
              SizedBox(
                height: 36,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final filter = _filters[index];
                    final isSelected = _selectedFilter == filter;
                    return InkWell(
                      onTap: () => setState(() => _selectedFilter = filter),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 7),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF0F172A)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF0F172A)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Text(
                          filter,
                          style: GoogleFonts.poppins(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF475569),
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 14),

              // ── Products Grid (Manual Refresh Based for Super Fast Performance) ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Builder(
                  builder: (context) {
                    final filteredProducts = _selectedFilter == 'All'
                        ? _liveProducts
                        : _liveProducts
                            .where((p) =>
                                p['category']?.toString().toLowerCase() ==
                                _selectedFilter.toLowerCase())
                            .toList();

                    if (filteredProducts.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(32),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Icon(Icons.inventory_2_outlined,
                                size: 48, color: Colors.grey.shade400),
                            const SizedBox(height: 8),
                            Text(
                              'No items in $_selectedFilter right now',
                              style: GoogleFonts.poppins(
                                  color: const Color(0xFF94A3B8), fontSize: 13),
                            ),
                            const SizedBox(height: 8),
                            TextButton.icon(
                              onPressed: _handleManualRefresh,
                              icon: const Icon(Icons.refresh_rounded, size: 16),
                              label:
                                  const Text('Tap to check for new products'),
                            ),
                          ],
                        ),
                      );
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredProducts.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.60,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                      ),
                      itemBuilder: (context, index) {
                        final p = filteredProducts[index];
                        final num priceNum = p['base_price'] is num
                            ? p['base_price']
                            : num.tryParse(
                                    p['base_price']?.toString() ?? '0') ??
                                0;
                        final int price = priceNum.toInt();
                        final int oldPrice = (price * 1.35).toInt();
                        final int discountPercent =
                            (((oldPrice - price) / oldPrice) * 100).round();
                        final String? imgUrl = p['image_url']?.toString();

                        return _FlipkartProductCard(
                          category: p['category'] ?? 'General',
                          title: p['name'] ?? 'Product',
                          imageUrl: (imgUrl != null &&
                                  imgUrl.isNotEmpty &&
                                  !imgUrl.contains('placeholder.com'))
                              ? imgUrl
                              : null,
                          price: price,
                          oldPrice: oldPrice,
                          discountPercent:
                              discountPercent > 0 ? discountPercent : 25,
                          rating: 4.8,
                          deliveryMins: '25 MINS',
                          icon: Icons.inventory_2_rounded,
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // ── Urgent Print Quick Action Banner (Zomato/Swiggy Express banner) ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.flash_on_rounded,
                            color: AppColors.primary, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'EXPRESS',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Exam in 30 Mins?',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Upload PDF & pickup from campus hub in 10 mins.',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF94A3B8),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, AppRoutes.xeroxOrder),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: Text(
                          'Upload',
                          style: GoogleFonts.poppins(
                              fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GlassBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacementNamed(context, AppRoutes.xeroxOrder);
            return;
          }
          if (index == 2) {
            Navigator.pushReplacementNamed(context, AppRoutes.categories);
            return;
          }
          if (index == 3) {
            Navigator.pushReplacementNamed(context, AppRoutes.orders);
            return;
          }
          if (index == 4) {
            Navigator.pushReplacementNamed(context, AppRoutes.profile);
            return;
          }
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.print_rounded),
            label: 'Xerox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_rounded),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

// ── Flipkart / Swiggy Style Product Card Component ──
class _FlipkartProductCard extends StatelessWidget {
  final String category;
  final String title;
  final int price;
  final int oldPrice;
  final int discountPercent;
  final double rating;
  final String deliveryMins;
  final String? imageUrl;
  final IconData icon;

  const _FlipkartProductCard({
    required this.category,
    required this.title,
    this.imageUrl,
    required this.price,
    required this.oldPrice,
    required this.discountPercent,
    required this.rating,
    required this.deliveryMins,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.zero,
      borderRadius: 18,
      opacity: 0.94,
      tintColor: Colors.white,
      customBorder: Border.all(
        color: const Color(0xFFE11D48).withValues(alpha: 0.12),
        width: 1.2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Visual Product Preview with Badges
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      child: imageUrl != null && imageUrl!.startsWith('http')
                          ? Image.network(
                              imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) => Center(
                                child: Container(
                                  width: 58,
                                  height: 58,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withValues(alpha: 0.04),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Icon(icon,
                                      size: 30, color: const Color(0xFFE11D48)),
                                ),
                              ),
                            )
                          : (imageUrl != null && File(imageUrl!).existsSync()
                              ? Image.file(
                                  File(imageUrl!),
                                  fit: BoxFit.cover,
                                )
                              : Center(
                                  child: Container(
                                    width: 58,
                                    height: 58,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.04),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: Icon(icon,
                                        size: 30,
                                        color: const Color(0xFFE11D48)),
                                  ),
                                )),
                    ),
                  ),
                  // Offer badge (Flipkart style green pill)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '$discountPercent% OFF',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  // Delivery speed badge (Swiggy / Zepto style)
                  Positioned(
                    bottom: 6,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.timer_outlined,
                              size: 10, color: Color(0xFF0F172A)),
                          const SizedBox(width: 3),
                          Text(
                            deliveryMins,
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content section
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category & Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        category.toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF64748B),
                          letterSpacing: 0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color(0xFF16A34A),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '$rating',
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 2),
                          const Icon(Icons.star, size: 8, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Title
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                // Price & Old Price
                Row(
                  children: [
                    Text(
                      '₹$price',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '₹$oldPrice',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF94A3B8),
                        fontSize: 11,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Add to Cart Button (Swiggy / Flipkart style)
                SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: OutlinedButton(
                    onPressed: () {
                      final item = CartItemModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        serviceName: title,
                        pricePerPage: price.toDouble(),
                      );
                      Provider.of<CartProvider>(context, listen: false)
                          .addItem(item);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added "$title" to cart!'),
                          duration: const Duration(seconds: 1),
                          backgroundColor: const Color(0xFF0F172A),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFE11D48),
                      side: const BorderSide(
                          color: Color(0xFFE11D48), width: 1.2),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      'ADD +',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

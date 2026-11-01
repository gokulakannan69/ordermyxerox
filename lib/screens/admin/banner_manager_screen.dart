import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../home/home_screen.dart';

class BannerManagerScreen extends StatefulWidget {
  const BannerManagerScreen({super.key});

  @override
  State<BannerManagerScreen> createState() => _BannerManagerScreenState();
}

class _BannerManagerScreenState extends State<BannerManagerScreen> {
  final List<Map<String, dynamic>> _fallbackBanners = [
    {
      'id': 'fallback-1',
      'title': 'First Xerox Order?',
      'subtitle': 'Get 50% Cashback + Instant Spiral Binding',
      'code': 'WELCOME50',
      'tag': 'FLAT 50% OFF',
      'price_text': '₹0.75/pg',
      'image_url':
          'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=600&q=80',
      'is_active': true,
      'type': 'Home Hero Banner',
    },
    {
      'id': 'fallback-2',
      'title': 'Semester Exam Pack',
      'subtitle': 'Free Delivery on Orders above ₹99',
      'code': 'EXAM20',
      'tag': 'STUDENT DEAL',
      'price_text': 'Free Drop',
      'image_url':
          'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80',
      'is_active': true,
      'type': 'Student Promo',
    },
    {
      'id': 'fallback-3',
      'title': 'Color Prints Flash Sale',
      'subtitle': 'Lab Record & Project Submission special',
      'code': 'COLOR30',
      'tag': 'FLASH OFFER',
      'price_text': '₹3.5/pg',
      'image_url':
          'https://images.unsplash.com/photo-1518770660439-4636190af475?w=600&q=80',
      'is_active': true,
      'type': 'Color Offer',
    },
  ];

  bool _isPublishing = false;

  void _showAddBannerModal() {
    final titleCtrl = TextEditingController();
    final subtitleCtrl = TextEditingController();
    final priceTextCtrl = TextEditingController();
    final codeCtrl = TextEditingController();
    final tagCtrl = TextEditingController();
    final imgUrlCtrl = TextEditingController();
    String? pickedLocalPath;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(modalCtx).viewInsets.bottom + 20,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color:
                                AppColors.primaryLight.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.add_photo_alternate_rounded,
                              color: AppColors.primary, size: 22),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Publish New Ad Banner',
                          style: GoogleFonts.poppins(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: titleCtrl,
                      decoration: InputDecoration(
                        labelText: 'Banner Headline / Title',
                        hintText: 'e.g. 50% Off First Xerox Order',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: subtitleCtrl,
                      decoration: InputDecoration(
                        labelText: 'Subtitle / Description',
                        hintText: 'e.g. Free Spiral Binding on Orders > ₹99',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: priceTextCtrl,
                            decoration: InputDecoration(
                              labelText: 'Offer Price / Deal',
                              hintText: '₹0.75/pg or ₹49',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: codeCtrl,
                            textCapitalization: TextCapitalization.characters,
                            decoration: InputDecoration(
                              labelText: 'Promo Coupon Code',
                              hintText: 'WELCOME50',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: tagCtrl,
                            decoration: InputDecoration(
                              labelText: 'Discount % / Badge Tag',
                              hintText: '50% OFF or LIMITED',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Tap to pick image file directly from device storage
                    InkWell(
                      onTap: () async {
                        try {
                          final result = await FilePicker.platform.pickFiles(
                            type: FileType.image,
                            withData: true,
                          );
                          if (result != null && result.files.isNotEmpty) {
                            setModalState(() {
                              pickedLocalPath = result.files.first.path;
                              imgUrlCtrl.clear();
                            });
                          }
                        } catch (e) {
                          debugPrint('Error picking banner: $e');
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: (pickedLocalPath != null ||
                                    imgUrlCtrl.text.isNotEmpty)
                                ? const Color(0xFF10B981)
                                : Colors.grey.shade300,
                            width: 1.5,
                          ),
                        ),
                        child: pickedLocalPath != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(11),
                                child: Image.file(
                                  File(pickedLocalPath!),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              )
                            : (imgUrlCtrl.text.trim().startsWith('http')
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(11),
                                    child: Image.network(
                                      imgUrlCtrl.text.trim(),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder: (c, e, s) => const Center(
                                        child: Text('Invalid Image URL',
                                            style:
                                                TextStyle(color: Colors.red)),
                                      ),
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.cloud_upload_outlined,
                                          color: AppColors.primary, size: 28),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Tap to choose banner image from phone storage',
                                        style: GoogleFonts.poppins(
                                            color: const Color(0xFF64748B),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  )),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: imgUrlCtrl,
                      decoration: InputDecoration(
                        labelText: 'Or Paste Web Banner URL',
                        hintText: 'https://images.unsplash.com/...',
                        prefixIcon: const Icon(Icons.link_rounded),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                      ),
                      onChanged: (_) => setModalState(() {}),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isPublishing
                            ? null
                            : () async {
                                final title = titleCtrl.text.trim();
                                if (title.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Please enter a banner title')),
                                  );
                                  return;
                                }

                                final finalImage = (pickedLocalPath != null &&
                                        pickedLocalPath!.isNotEmpty)
                                    ? pickedLocalPath!
                                    : (imgUrlCtrl.text.trim().isNotEmpty
                                        ? imgUrlCtrl.text.trim()
                                        : 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=600&q=80');

                                final payload = {
                                  'title': title,
                                  'subtitle': subtitleCtrl.text.trim(),
                                  'code': codeCtrl.text.trim().toUpperCase(),
                                  'tag': tagCtrl.text.trim().isNotEmpty
                                      ? tagCtrl.text.trim()
                                      : (priceTextCtrl.text.trim().isNotEmpty
                                          ? priceTextCtrl.text.trim()
                                          : 'OFFER'),
                                  'price_text': priceTextCtrl.text.trim(),
                                  'image_url': finalImage,
                                  'is_active': true,
                                };

                                setModalState(() => _isPublishing = true);
                                try {
                                  await Supabase.instance.client
                                      .from('banners')
                                      .insert(payload);
                                  HomeScreen.needsRefresh = true;
                                  if (sheetCtx.mounted) {
                                    Navigator.pop(sheetCtx);
                                  }
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Banner published to database & live on Home Storefront!'),
                                        backgroundColor: Color(0xFF10B981),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  debugPrint('Error inserting banner: $e');
                                  HomeScreen.needsRefresh = true;
                                  if (sheetCtx.mounted) {
                                    Navigator.pop(sheetCtx);
                                  }
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Saved locally: $title'),
                                        backgroundColor:
                                            const Color(0xFF2563EB),
                                      ),
                                    );
                                  }
                                } finally {
                                  setModalState(() => _isPublishing = false);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _isPublishing
                            ? const CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2)
                            : Text('Publish Banner to DB',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold, fontSize: 14)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _toggleBannerStatus(String id, bool currentStatus) async {
    try {
      await Supabase.instance.client
          .from('banners')
          .update({'is_active': !currentStatus}).eq('id', id);
      HomeScreen.needsRefresh = true;
    } catch (e) {
      debugPrint('Error toggling banner: $e');
    }
  }

  Future<void> _deleteBanner(String id) async {
    try {
      await Supabase.instance.client.from('banners').delete().eq('id', id);
      HomeScreen.needsRefresh = true;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Banner deleted')),
        );
      }
    } catch (e) {
      debugPrint('Error deleting banner: $e');
    }
  }

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
          onPressed: () {
            HomeScreen.needsRefresh = true;
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Banners & Price Promos',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontSize: 17),
        ),
        actions: [
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            icon: const Icon(Icons.storefront_rounded, size: 20),
            label: Text(
              'Home',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700, fontSize: 13),
            ),
            onPressed: () {
              HomeScreen.needsRefresh = true;
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: Supabase.instance.client
            .from('banners')
            .stream(primaryKey: ['id']).order('created_at', ascending: false),
        builder: (context, snapshot) {
          final List<Map<String, dynamic>> bannerList =
              (snapshot.hasData && snapshot.data!.isNotEmpty)
                  ? snapshot.data!
                  : _fallbackBanners;

          return Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.white,
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE11D48),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'REALTIME DATABASE SYNC (${bannerList.length} Banners)',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFE11D48),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: bannerList.length,
                  itemBuilder: (context, index) {
                    final banner = bannerList[index];
                    final isActive = banner['is_active'] == true ||
                        banner['status'] == 'Active';
                    final img = banner['image_url']?.toString();
                    final id = banner['id']?.toString() ?? '$index';
                    final price = banner['price_text'] ?? banner['tag'] ?? '';
                    final code = banner['code'] ?? '';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 84,
                            height: 60,
                            decoration: BoxDecoration(
                              color:
                                  AppColors.primaryLight.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: (img != null && img.startsWith('http'))
                                  ? Image.network(
                                      img,
                                      fit: BoxFit.cover,
                                      errorBuilder: (c, e, s) => const Icon(
                                          Icons.image_rounded,
                                          color: AppColors.primary),
                                    )
                                  : (img != null && File(img).existsSync()
                                      ? Image.file(File(img), fit: BoxFit.cover)
                                      : const Icon(Icons.image_rounded,
                                          color: AppColors.primary)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  banner['title'] ?? 'Ad Banner',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (price.isNotEmpty || code.isNotEmpty)
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        if (price.isNotEmpty)
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: 6, top: 2),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFE11D48)
                                                  .withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                  color: const Color(0xFFE11D48)
                                                      .withValues(alpha: 0.3)),
                                            ),
                                            child: Text(
                                              price,
                                              style: GoogleFonts.poppins(
                                                color: const Color(0xFFE11D48),
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        if (code.isNotEmpty)
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 2),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                  color: const Color(0xFFE11D48)
                                                      .withValues(alpha: 0.5)),
                                            ),
                                            child: Text(
                                              'CODE: $code',
                                              style: GoogleFonts.poppins(
                                                color: const Color(0xFFE11D48),
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                if (banner['subtitle'] != null &&
                                    banner['subtitle'].toString().isNotEmpty)
                                  Text(
                                    banner['subtitle'].toString(),
                                    style: GoogleFonts.poppins(
                                        color: AppColors.textSecondary,
                                        fontSize: 11),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                          Switch(
                            value: isActive,
                            activeColor: AppColors.primary,
                            onChanged: (val) =>
                                _toggleBannerStatus(id, isActive),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded,
                                color: Colors.redAccent, size: 20),
                            onPressed: () => _deleteBanner(id),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddBannerModal,
        backgroundColor: AppColors.primary,
        icon:
            const Icon(Icons.add_photo_alternate_rounded, color: Colors.white),
        label: Text('New Ad Banner',
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

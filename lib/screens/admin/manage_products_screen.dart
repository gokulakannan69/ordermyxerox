import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../widgets/glass_card.dart';
import '../home/home_screen.dart';

class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({super.key});

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _originalPriceController =
      TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  String? _pickedImagePath;
  String _selectedCategory = 'Stationery';
  bool _isLoading = false;

  final List<String> _categories = [
    'Stationery',
    'Books',
    'Kits',
    'Xerox',
    'General',
  ];

  Future<void> _addProduct() async {
    final name = _nameController.text.trim();
    final priceStr = _priceController.text.trim();
    final desc = _descController.text.trim();
    final customImage = _imageUrlController.text.trim();

    if (name.isEmpty || priceStr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter product name and price')),
      );
      return;
    }

    final price = double.tryParse(priceStr);
    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid price')),
      );
      return;
    }

    final origPrice =
        double.tryParse(_originalPriceController.text.trim()) ?? (price * 1.35);
    final discountVal = _discountController.text.trim().isNotEmpty
        ? _discountController.text.trim()
        : '${(((origPrice - price) / origPrice) * 100).round()}% OFF';

    setState(() => _isLoading = true);

    // Default high-quality category image if custom not provided
    final defaultCatImages = {
      'Stationery':
          'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400&q=80',
      'Books':
          'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400&q=80',
      'Kits':
          'https://images.unsplash.com/photo-1518770660439-4636190af475?w=400&q=80',
      'Xerox':
          'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=400&q=80',
      'General':
          'https://images.unsplash.com/photo-1583485088034-697b5bc54ccd?w=400&q=80',
    };

    final finalImageUrl = (_pickedImagePath != null &&
            _pickedImagePath!.isNotEmpty)
        ? _pickedImagePath!
        : (customImage.isNotEmpty
            ? customImage
            : (defaultCatImages[_selectedCategory] ??
                'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400&q=80'));

    try {
      await Supabase.instance.client.from('products').insert({
        'name': name,
        'base_price': price,
        'original_price': origPrice,
        'discount_text': discountVal,
        'category': _selectedCategory,
        'description': desc.isNotEmpty ? desc : null,
        'image_url': finalImageUrl,
        'is_available': true,
      });

      _nameController.clear();
      _priceController.clear();
      _originalPriceController.clear();
      _discountController.clear();
      _descController.clear();
      _imageUrlController.clear();
      setState(() => _pickedImagePath = null);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Product "$name" added! It is now live on Home & Category pages.',
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF10B981),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding product: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleAvailability(String id, bool currentStatus) async {
    try {
      await Supabase.instance.client
          .from('products')
          .update({'is_available': !currentStatus}).eq('id', id);
    } catch (e) {
      debugPrint('Error toggling availability: $e');
    }
  }

  Future<void> _deleteProduct(String id, String name) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Product?'),
        content: Text('Are you sure you want to delete "$name"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await Supabase.instance.client.from('products').delete().eq('id', id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Deleted "$name"')),
          );
        }
      } catch (e) {
        debugPrint('Error deleting product: $e');
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          tooltip: 'Back',
          onPressed: () {
            HomeScreen.needsRefresh = true;
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Manage Products',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFFE11D48),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            icon: const Icon(Icons.storefront_rounded, size: 20),
            label: Text(
              'Home',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.white,
              ),
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
      body: Column(
        children: [
          // ── Realtime Add Product Form ──
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE4E6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.add_shopping_cart_rounded,
                          color: Color(0xFFE11D48), size: 18),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Add New Product to Store',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    hintText: 'e.g. Classmate 300 Pgs Spiral Notebook',
                    labelStyle: GoogleFonts.poppins(fontSize: 13),
                    hintStyle: GoogleFonts.poppins(
                        fontSize: 12, color: Colors.grey.shade400),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: TextField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Offer Price (₹)',
                          hintText: '150',
                          prefixText: '₹ ',
                          labelStyle: GoogleFonts.poppins(fontSize: 12),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 4,
                      child: TextField(
                        controller: _originalPriceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Original MRP',
                          hintText: '220',
                          prefixText: '₹ ',
                          labelStyle: GoogleFonts.poppins(fontSize: 12),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 4,
                      child: TextField(
                        controller: _discountController,
                        decoration: InputDecoration(
                          labelText: 'Discount %',
                          hintText: '30% OFF',
                          labelStyle: GoogleFonts.poppins(fontSize: 12),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      isExpanded: true,
                      items: _categories.map((c) {
                        return DropdownMenuItem(
                          value: c,
                          child: Text('Category: $c',
                              style: GoogleFonts.poppins(fontSize: 13)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedCategory = val);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _descController,
                  decoration: InputDecoration(
                    labelText: 'Description (optional)',
                    hintText: 'e.g. Ruled, 75 GSM, bleed-proof',
                    labelStyle: GoogleFonts.poppins(fontSize: 13),
                    hintStyle: GoogleFonts.poppins(
                        fontSize: 12, color: Colors.grey.shade400),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                  ),
                ),
                const SizedBox(height: 10),
                // Tap to pick image directly from mobile storage
                InkWell(
                  onTap: () async {
                    try {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.image,
                        withData: true,
                      );
                      if (result != null && result.files.isNotEmpty) {
                        setState(() {
                          _pickedImagePath = result.files.first.path;
                          _imageUrlController.clear();
                        });
                      }
                    } catch (e) {
                      debugPrint('Error picking image from mobile storage: $e');
                    }
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 85,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _pickedImagePath != null
                            ? const Color(0xFF10B981)
                            : Colors.grey.shade300,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: _pickedImagePath != null
                        ? Stack(
                            children: [
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(9),
                                  child: Image.file(
                                    File(_pickedImagePath!),
                                    height: 85,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: InkWell(
                                  onTap: () =>
                                      setState(() => _pickedImagePath = null),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close_rounded,
                                        size: 14, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFE4E6),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                    Icons.add_photo_alternate_rounded,
                                    color: Color(0xFFE11D48),
                                    size: 20),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Choose Photo from Mobile Storage',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF0F172A),
                                    ),
                                  ),
                                  Text(
                                    'Tap to pick product image from phone gallery/storage',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _imageUrlController,
                  decoration: InputDecoration(
                    labelText: 'Or Paste Web Image URL (optional)',
                    hintText:
                        'https://images.unsplash.com/... or paste image link',
                    prefixIcon: const Icon(Icons.link_rounded, size: 20),
                    labelStyle: GoogleFonts.poppins(fontSize: 12),
                    hintStyle: GoogleFonts.poppins(
                        fontSize: 11, color: Colors.grey.shade400),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                  ),
                  onChanged: (_) {
                    if (_pickedImagePath != null) {
                      setState(() => _pickedImagePath = null);
                    }
                  },
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _addProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE11D48),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            'Publish Product (Instant Live)',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ── Realtime Live Catalog View ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text(
                  'Live Catalog',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'REALTIME SYNC ACTIVE',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF059669),
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: Supabase.instance.client.from('products').stream(
                  primaryKey: ['id']).order('created_at', ascending: false),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child:
                          CircularProgressIndicator(color: AppColors.primary));
                }

                final products = snapshot.data ?? [];

                if (products.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_outlined,
                            size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 10),
                        Text(
                          'No products in catalog yet.\nUse the form above to publish your first item.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              color: const Color(0xFF64748B), fontSize: 13),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final p = products[index];
                    final isAvailable = p['is_available'] == true;

                    return GlassCard(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      borderRadius: 18,
                      opacity: 0.92,
                      tintColor: Colors.white,
                      customBorder: Border.all(
                        color: isAvailable
                            ? const Color(0xFFE11D48).withValues(alpha: 0.12)
                            : Colors.grey.withValues(alpha: 0.2),
                        width: 1.2,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE4E6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: (p['image_url'] != null &&
                                      p['image_url']
                                          .toString()
                                          .startsWith('http') &&
                                      !p['image_url']
                                          .toString()
                                          .contains('placeholder.com'))
                                  ? Image.network(
                                      p['image_url'].toString(),
                                      fit: BoxFit.cover,
                                      errorBuilder: (ctx, err, stack) =>
                                          const Icon(
                                        Icons.inventory_2_rounded,
                                        color: Color(0xFFE11D48),
                                        size: 22,
                                      ),
                                    )
                                  : (p['image_url'] != null &&
                                          File(p['image_url'].toString())
                                              .existsSync()
                                      ? Image.file(
                                          File(p['image_url'].toString()),
                                          fit: BoxFit.cover,
                                        )
                                      : const Icon(
                                          Icons.inventory_2_rounded,
                                          color: Color(0xFFE11D48),
                                          size: 22,
                                        )),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        p['name'] ?? 'Unnamed',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                          color: const Color(0xFF0F172A),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isAvailable
                                            ? const Color(0xFF10B981)
                                                .withValues(alpha: 0.1)
                                            : Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        isAvailable
                                            ? 'IN STOCK'
                                            : 'OUT OF STOCK',
                                        style: GoogleFonts.poppins(
                                          fontSize: 8,
                                          fontWeight: FontWeight.w800,
                                          color: isAvailable
                                              ? const Color(0xFF059669)
                                              : Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Text(
                                      '₹${p['base_price']}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFFE11D48),
                                      ),
                                    ),
                                    if (p['original_price'] != null) ...[
                                      const SizedBox(width: 6),
                                      Text(
                                        '₹${p['original_price']}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: Colors.grey.shade500,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ],
                                    if (p['discount_text'] != null) ...[
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 1),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE11D48)
                                              .withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          '${p['discount_text']}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFFE11D48),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                Text(
                                  'Category: ${p['category']}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              isAvailable
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                              color: isAvailable
                                  ? const Color(0xFF059669)
                                  : Colors.grey,
                              size: 20,
                            ),
                            tooltip: 'Toggle Live Status',
                            onPressed: () =>
                                _toggleAvailability(p['id'], isAvailable),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded,
                                color: Colors.red, size: 20),
                            tooltip: 'Delete',
                            onPressed: () =>
                                _deleteProduct(p['id'], p['name'] ?? 'Product'),
                          ),
                        ],
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
}

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/shop.dart';

class ShopProvider extends ChangeNotifier {
  List<ShopModel> _shops = [];
  bool _isLoading = false;

  List<ShopModel> get shops => _shops;
  bool get isLoading => _isLoading;

  ShopProvider() {
    _initShopStream();
  }

  void _initShopStream() {
    _isLoading = true;
    notifyListeners();

    Supabase.instance.client
        .from('shops')
        .stream(primaryKey: ['id'])
        .eq('is_verified', true)
        .listen((data) {
          _shops = data.map((json) {
            return ShopModel(
              id: json['id'] ?? '',
              name: json['shop_name'] ?? 'Unknown Shop',
              address: json['address'] ?? '',
              city: '', // Extract from address if needed
              phone: '', // Needs join with profiles or add to shops
              rating: 5.0, // Default for now
              latitude: json['latitude']?.toDouble() ?? 0.0,
              longitude: json['longitude']?.toDouble() ?? 0.0,
              services: [
                'B&W Print',
                'Color Print'
              ], // Hardcoded or link to shop_services
            );
          }).toList();
          _isLoading = false;
          notifyListeners();
        }, onError: (err) {
          debugPrint('Error streaming shops: $err');
          _isLoading = false;
          notifyListeners();
        });
  }

  Future<void> fetchNearbyShops() async {
    // Left for compatibility, but the stream handles it now.
  }
}

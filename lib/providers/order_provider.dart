import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order.dart';

class OrderProvider extends ChangeNotifier {
  List<OrderModel> _orders = [];
  bool _isLoading = false;

  List<OrderModel> get orders => List.unmodifiable(_orders);
  bool get isLoading => _isLoading;

  OrderProvider() {
    _initOrdersStream();
  }

  void _initOrdersStream() {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    _isLoading = true;
    notifyListeners();

    Supabase.instance.client
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('customer_id', userId)
        .order('created_at')
        .listen((data) {
          _orders = (data as List).map((json) {
            return OrderModel(
              id: json['id'] ?? '',
              userId: userId,
              shopId: json['shop_id'] ?? '',
              shopName: 'Shop', // Needs a join or fetch separate
              createdAt: json['created_at'] != null
                  ? DateTime.parse(json['created_at'])
                  : DateTime.now(),
              totalAmount: json['total_amount']?.toDouble() ?? 0.0,
              status: _parseStatus(json['status']),
              items: [], // Need to join order_documents
            );
          }).toList();
          _isLoading = false;
          notifyListeners();
        }, onError: (err) {
          debugPrint('Error streaming orders: $err');
          _isLoading = false;
          notifyListeners();
        });
  }

  OrderStatus _parseStatus(String? status) {
    switch (status) {
      case 'printing':
        return OrderStatus.printing;
      case 'ready':
        return OrderStatus.ready;
      case 'out_for_delivery':
      case 'completed':
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'placed':
      default:
        return OrderStatus.placed;
    }
  }

  Future<void> fetchOrders() async {
    // Handled by stream
  }

  Future<void> placeOrder(OrderModel order) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception('Not logged in');

      await Supabase.instance.client.from('orders').insert({
        'customer_id': userId,
        'shop_id':
            '00000000-0000-0000-0000-000000000000', // Replace with real shop ID
        'status': 'placed',
        'total_amount': order.totalAmount,
        'is_delivery': false, // Add this to order model
      });
      // The stream will automatically update the UI
    } catch (e) {
      debugPrint('Error placing order: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}

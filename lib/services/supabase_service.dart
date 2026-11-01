import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  final SupabaseClient client = Supabase.instance.client;

  // Check if Supabase is properly configured in .env
  bool get isConfigured {
    final url = dotenv.env['SUPABASE_URL'] ?? '';
    return url.isNotEmpty && url.contains('supabase.co');
  }

  // Stream active banners
  Stream<List<Map<String, dynamic>>> getBannersStream() {
    if (!isConfigured) return const Stream.empty();
    return client
        .from('banners')
        .stream(primaryKey: ['id'])
        .eq('is_active', true)
        .order('created_at');
  }

  // Stream available products
  Stream<List<Map<String, dynamic>>> getProductsStream() {
    if (!isConfigured) return const Stream.empty();
    return client
        .from('products')
        .stream(primaryKey: ['id'])
        .eq('is_available', true)
        .order('created_at');
  }
}

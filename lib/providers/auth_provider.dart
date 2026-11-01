import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isAuthenticated = false;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _initAuthListener();
  }

  void _initAuthListener() {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        _isAuthenticated = true;
        _user = UserModel(
          id: session.user.id,
          name: session.user.userMetadata?['full_name'] ?? 'User',
          phone: session.user.phone ?? '',
          email: session.user.email ?? '',
        );
      } else {
        _isAuthenticated = false;
        _user = null;
      }
      notifyListeners();
    });
  }

  Future<void> login(String phone) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Supabase.instance.client.auth.signInWithOtp(
        phone: '+91$phone',
      );
    } catch (e) {
      debugPrint('Error logging in: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> verifyOtp(String phone, String otp) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Supabase.instance.client.auth.verifyOTP(
        phone: '+91$phone',
        token: otp,
        type: OtpType.sms,
      );
    } catch (e) {
      debugPrint('Error verifying OTP: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();
  }
}

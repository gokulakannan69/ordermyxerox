import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum UserRole {
  customer,
  seller,
  employee,
  admin,
}

class RoleManager with ChangeNotifier {
  static final RoleManager _instance = RoleManager._internal();
  factory RoleManager() => _instance;
  RoleManager._internal() {
    _initAuthListener();
  }

  UserRole _currentRole = UserRole.customer; // Default logged in as Customer
  String _loggedInUser = 'Guest';
  String _loggedInPhone = '';
  String _loggedInEmail = '';
  bool _isGoogleAuth = true;

  UserRole get currentRole => _currentRole;
  String get loggedInUser => _loggedInUser;
  String get loggedInPhone => _loggedInPhone;
  String get loggedInEmail => _loggedInEmail;
  bool get isGoogleAuth => _isGoogleAuth;

  String get roleDisplayName {
    switch (_currentRole) {
      case UserRole.customer:
        return 'User';
      case UserRole.seller:
        return 'Xerox Shop';
      case UserRole.employee:
        return 'Employee';
      case UserRole.admin:
        return 'Admin';
    }
  }

  void _initAuthListener() {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
      final session = data.session;
      if (session != null) {
        await fetchProfile(session.user);
      } else {
        _resetProfile();
      }
    });
  }

  Future<void> fetchProfile(User user) async {
    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (response != null) {
        final roleString = response['role'] ?? 'customer';
        _currentRole = _parseRole(roleString);
        _loggedInUser = response['full_name'] ?? 'User';
        _loggedInPhone = response['phone_number'] ?? '';
        _loggedInEmail = user.email ?? '';
        _isGoogleAuth = user.appMetadata['provider'] == 'google';
        notifyListeners();
      } else {
        // Create profile if it doesn't exist
        await createProfile(user);
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    }
  }

  Future<void> createProfile(User user,
      {String? fullName, String? phone}) async {
    try {
      final name = fullName ??
          user.userMetadata?['full_name'] ??
          user.userMetadata?['name'] ??
          user.email?.split('@').first ??
          'Customer';
      final phoneNumber =
          phone ?? user.userMetadata?['phone_number'] ?? user.phone;

      await Supabase.instance.client.from('profiles').upsert({
        'id': user.id,
        'full_name': name,
        if (phoneNumber != null && phoneNumber.toString().isNotEmpty)
          'phone_number': phoneNumber,
        'role': 'customer',
      }, onConflict: 'id');
      await fetchProfile(user); // Fetch again to update state
    } catch (e) {
      debugPrint('Error creating profile: $e');
    }
  }

  void _resetProfile() {
    _currentRole = UserRole.customer;
    _loggedInUser = 'Guest';
    _loggedInPhone = '';
    _loggedInEmail = '';
    notifyListeners();
  }

  Future<bool> updateUserRole(String userId, UserRole newRole) async {
    try {
      final roleStr = newRole.name;
      await Supabase.instance.client
          .from('profiles')
          .update({'role': roleStr}).eq('id', userId);

      final currentUserId = Supabase.instance.client.auth.currentUser?.id;
      if (currentUserId == userId) {
        _currentRole = newRole;
        notifyListeners();
      }
      return true;
    } catch (e) {
      debugPrint('Error updating user role: $e');
      return false;
    }
  }

  UserRole _parseRole(String role) {
    switch (role) {
      case 'seller':
        return UserRole.seller;
      case 'employee':
        return UserRole.employee;
      case 'admin':
        return UserRole.admin;
      case 'customer':
      default:
        return UserRole.customer;
    }
  }
}

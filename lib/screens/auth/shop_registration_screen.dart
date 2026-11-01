import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../services/role_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ShopRegistrationScreen extends StatefulWidget {
  const ShopRegistrationScreen({super.key});

  @override
  State<ShopRegistrationScreen> createState() => _ShopRegistrationScreenState();
}

class _ShopRegistrationScreenState extends State<ShopRegistrationScreen> {
  int _currentStep = 0;
  bool _isLoading = false;

  final _shopNameCtrl = TextEditingController();
  final _ownerNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  @override
  void dispose() {
    _shopNameCtrl.dispose();
    _ownerNameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitRegistration() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Please sign in or create an account first before registering your shop.',
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFE11D48),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    final shopName = _shopNameCtrl.text.trim();
    final address = _addressCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();

    if (shopName.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill out the shop name and address.',
            style: GoogleFonts.poppins(fontSize: 13),
          ),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Ensure profile exists for the user
      await Supabase.instance.client.from('profiles').upsert({
        'id': user.id,
        'full_name': _ownerNameCtrl.text.trim().isNotEmpty
            ? _ownerNameCtrl.text.trim()
            : (user.userMetadata?['full_name'] ?? 'Shop Owner'),
        if (phone.isNotEmpty)
          'phone_number': phone.startsWith('+91') ? phone : '+91$phone',
        'role': 'seller',
      }, onConflict: 'id');

      // 2. Insert or update the shop
      await Supabase.instance.client.from('shops').insert({
        'owner_id': user.id,
        'shop_name': shopName,
        'address': address,
        'is_verified': true, // Auto-verify on registration
        'is_open': true,
        'latitude': 13.0827,
        'longitude': 80.2707,
      });

      // 3. Update local role manager state
      await RoleManager().fetchProfile(user);

      if (!mounted) return;
      _showSuccessDialog();
    } catch (e) {
      debugPrint('Shop registration error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error registering shop: ${e.toString()}'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Register Xerox Shop',
          style: GoogleFonts.poppins(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        elevation: 0,
        onStepContinue: () {
          if (_currentStep < 1) {
            setState(() => _currentStep += 1);
          } else {
            // Final Submission
            _submitRegistration();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep -= 1);
          }
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading && _currentStep == 1
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : Text(
                            _currentStep == 1
                                ? 'Submit Registration'
                                : 'Continue',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                  ),
                ),
                if (_currentStep > 0) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: details.onStepCancel,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Back',
                          style: TextStyle(
                              fontSize: 16, color: AppColors.textPrimary)),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        steps: [
          _buildBasicDetailsStep(),
          _buildLocationStep(),
        ],
      ),
    );
  }

  Step _buildBasicDetailsStep() {
    return Step(
      title: const Text('Basic', style: TextStyle(fontSize: 12)),
      isActive: _currentStep >= 0,
      state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Shop Information',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Enter your primary business details',
              style: GoogleFonts.poppins(
                  fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          _buildTextField(
              'Shop Name', Icons.store_rounded, 'e.g. Campus Print Hub',
              controller: _shopNameCtrl),
          const SizedBox(height: 16),
          _buildTextField('Owner Name', Icons.person_rounded, 'e.g. John Doe',
              controller: _ownerNameCtrl),
          const SizedBox(height: 16),
          _buildTextField(
              'Phone Number', Icons.phone_rounded, '10-digit mobile number',
              isNumber: true, controller: _phoneCtrl),
        ],
      ),
    );
  }

  Step _buildLocationStep() {
    return Step(
      title: const Text('Location', style: TextStyle(fontSize: 12)),
      isActive: _currentStep >= 1,
      state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pinpoint on Map',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Drag the map to set your exact shop location',
              style: GoogleFonts.poppins(
                  fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 24),

          // Google Map Mockup Container
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
              // We use a dummy color and a grid pattern manually to avoid 403 API errors.
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Mock Grid lines
                CustomPaint(
                    painter: GridPainter(),
                    size: const Size(double.infinity, 200)),

                // Map Pin
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('Move map to adjust',
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontSize: 10)),
                    ),
                    const SizedBox(height: 4),
                    const Icon(Icons.location_on, color: Colors.red, size: 48),
                    Container(
                      width: 12,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ],
                ),

                // Current Location Button
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton.small(
                    backgroundColor: Colors.white,
                    onPressed: () {},
                    child: const Icon(Icons.my_location_rounded,
                        color: AppColors.primary),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildTextField('Complete Address', Icons.location_city_rounded,
              'Door No, Street Name, Landmark',
              controller: _addressCtrl),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, String hint,
      {bool isNumber = false, TextEditingController? controller}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle),
              child: const Icon(Icons.check_circle_rounded,
                  color: Colors.green, size: 48),
            ),
            const SizedBox(height: 24),
            Text('Shop Registered Successfully!',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 19)),
            const SizedBox(height: 8),
            Text(
              'Your Xerox Shop has been registered and verified. You can now access your Shop Dashboard and manage print orders.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 12, color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx); // close dialog
                  Navigator.pushNamedAndRemoveUntil(
                      context, AppRoutes.shopDashboard, (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Go to Shop Dashboard',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..strokeWidth = 1.0;

    for (var i = 0.0; i < size.width; i += 20) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (var i = 0.0; i < size.height; i += 20) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

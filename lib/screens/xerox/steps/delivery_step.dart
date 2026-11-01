import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../xerox_widgets.dart';
import '../../../widgets/glass_card.dart';

class DeliveryStep extends StatefulWidget {
  final String deliveryMethod;
  final ValueChanged<String> onMethodChanged;
  final String? customerName;
  final String? streetAddress;
  final String? city;
  final String? postalCode;
  final ValueChanged<String>? onAddressChanged;

  const DeliveryStep({
    super.key,
    required this.deliveryMethod,
    required this.onMethodChanged,
    this.customerName,
    this.streetAddress,
    this.city,
    this.postalCode,
    this.onAddressChanged,
  });

  @override
  State<DeliveryStep> createState() => _DeliveryStepState();
}

class _DeliveryStepState extends State<DeliveryStep> {
  late TextEditingController _nameController;
  late TextEditingController _streetController;
  late TextEditingController _cityController;
  late TextEditingController _postalController;
  final _instructionsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.customerName ?? 'Gokul Kannan');
    _streetController = TextEditingController(
        text: widget.streetAddress ?? 'New Fairlands, 5th Cross Road');
    _cityController = TextEditingController(text: widget.city ?? 'Salem');
    _postalController =
        TextEditingController(text: widget.postalCode ?? '636016');
  }

  @override
  void didUpdateWidget(covariant DeliveryStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.streetAddress != null &&
        widget.streetAddress != oldWidget.streetAddress) {
      _streetController.text = widget.streetAddress!;
    }
    if (widget.city != null && widget.city != oldWidget.city) {
      _cityController.text = widget.city!;
    }
    if (widget.postalCode != null &&
        widget.postalCode != oldWidget.postalCode) {
      _postalController.text = widget.postalCode!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _postalController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDelivery = widget.deliveryMethod == 'home';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title ──
          Text('How do you want it?',
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: XeroxColors.darkText)),
          const SizedBox(height: 6),
          Text(
            'Choose how you\'d like to receive your printed documents.',
            style: GoogleFonts.poppins(
                fontSize: 13, color: XeroxColors.grayText, height: 1.5),
          ),
          const SizedBox(height: 20),

          // ── Delivery method toggle cards ──
          Row(
            children: [
              Expanded(
                child: _MethodCard(
                  icon: Icons.home_rounded,
                  title: 'Home Delivery',
                  subtitle: 'Delivered to your\ndoorstep (+₹50)',
                  isSelected: isDelivery,
                  onTap: () => widget.onMethodChanged('home'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MethodCard(
                  icon: Icons.store_rounded,
                  title: 'Store Pickup',
                  subtitle: 'Ready in 15 mins\n(Free)',
                  isSelected: !isDelivery,
                  onTap: () => widget.onMethodChanged('pickup'),
                ),
              ),
            ],
          ),

          // ── Delivery Address Form ──
          if (isDelivery) ...[
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.location_on,
                    size: 18, color: XeroxColors.primaryRed),
                const SizedBox(width: 6),
                Text('Delivery Address',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: XeroxColors.darkText)),
              ],
            ),
            const SizedBox(height: 14),

            // Full Name
            const SectionLabel(title: 'Full Name'),
            _buildTextField(_nameController, 'Alex Johnson'),
            const SizedBox(height: 14),

            // Street Address
            const SectionLabel(title: 'Street Address / Apartment / Room'),
            _buildTextField(
                _streetController, 'e.g. Room 402, Block B, Campus Hostel'),
            const SizedBox(height: 14),

            // City + Postal Code
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionLabel(title: 'City'),
                      _buildTextField(_cityController, 'Bengaluru'),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionLabel(title: 'Postal Code'),
                      _buildTextField(_postalController, '960001'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Delivery Instructions
            const SectionLabel(title: 'Delivery Instructions (Optional)'),
            _buildTextField(
                _instructionsController, 'Any special instructions...',
                maxLines: 3),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: XeroxColors.cardWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: XeroxColors.border),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: GoogleFonts.poppins(fontSize: 14, color: XeroxColors.darkText),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
              GoogleFonts.poppins(fontSize: 13, color: XeroxColors.hintText),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

// ── Delivery method card ──
class _MethodCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _MethodCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      borderRadius: 18,
      opacity: 0.94,
      tintColor: isSelected ? const Color(0xFFFFF1F2) : Colors.white,
      customBorder: Border.all(
        color: isSelected ? const Color(0xFFE11D48) : const Color(0xFFE2E8F0),
        width: isSelected ? 1.8 : 1.0,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFE11D48).withValues(alpha: 0.12)
                  : const Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: Icon(icon,
                size: 24,
                color: isSelected
                    ? const Color(0xFFE11D48)
                    : XeroxColors.grayText),
          ),
          const SizedBox(height: 10),
          Text(title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? const Color(0xFFE11D48)
                      : XeroxColors.darkText)),
          const SizedBox(height: 4),
          Text(subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 11, color: XeroxColors.grayText, height: 1.4)),
        ],
      ),
    );
  }
}

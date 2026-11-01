import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../xerox_widgets.dart';
import '../../../widgets/glass_card.dart';

class PaymentStep extends StatefulWidget {
  final double total;
  final String paymentMethod;
  final ValueChanged<String> onMethodChanged;

  const PaymentStep({
    super.key,
    required this.total,
    required this.paymentMethod,
    required this.onMethodChanged,
  });

  @override
  State<PaymentStep> createState() => _PaymentStepState();
}

class _PaymentStepState extends State<PaymentStep> {
  final _upiController = TextEditingController();

  @override
  void dispose() {
    _upiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title ──
          Text('Secure Payment',
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: XeroxColors.darkText)),
          const SizedBox(height: 6),
          Text(
            'Choose your preferred payment method to complete the order.',
            style: GoogleFonts.poppins(
                fontSize: 13, color: XeroxColors.grayText, height: 1.5),
          ),
          const SizedBox(height: 20),

          // ── Total Amount in Apple Glass style ──
          GlassCard(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            borderRadius: 20,
            opacity: 0.94,
            tintColor: const Color(0xFFFFF1F2),
            customBorder: Border.all(
                color: XeroxColors.primaryRed.withValues(alpha: 0.25),
                width: 1.2),
            child: Column(
              children: [
                Text('Total Amount to Pay',
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: XeroxColors.grayText)),
                const SizedBox(height: 4),
                Text('₹${widget.total.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: XeroxColors.primaryRed)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Payment Options header ──
          Text('Payment Options',
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: XeroxColors.darkText)),
          const SizedBox(height: 14),

          // ── UPI Option ──
          _PaymentOptionCard(
            icon: Icons.phone_android,
            title: 'UPI App / ID',
            subtitle: 'Google Pay, PhonePe, Paytm, BHIM',
            isSelected: widget.paymentMethod == 'upi',
            onTap: () => widget.onMethodChanged('upi'),
            expandedContent: widget.paymentMethod == 'upi'
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 14),
                      const Divider(color: XeroxColors.border),
                      const SizedBox(height: 12),
                      Text('Enter UPI ID',
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: XeroxColors.darkText)),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: XeroxColors.divider,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: XeroxColors.border),
                        ),
                        child: TextField(
                          controller: _upiController,
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: XeroxColors.darkText),
                          decoration: InputDecoration(
                            hintText: 'username@oksbi',
                            hintStyle: GoogleFonts.poppins(
                                fontSize: 13, color: XeroxColors.hintText),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'A collect request will be sent to your UPI app.',
                        style: GoogleFonts.poppins(
                            fontSize: 11, color: XeroxColors.grayText),
                      ),
                    ],
                  )
                : null,
          ),
          const SizedBox(height: 12),

          // ── Credit / Debit Card Option ──
          _PaymentOptionCard(
            icon: Icons.credit_card,
            title: 'Credit / Debit Card',
            subtitle: 'Visa, Mastercard, RuPay & more',
            isSelected: widget.paymentMethod == 'card',
            onTap: () => widget.onMethodChanged('card'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ── Payment option card ──
class _PaymentOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget? expandedContent;

  const _PaymentOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
    this.expandedContent,
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? XeroxColors.primaryRed.withValues(alpha: 0.1)
                      : XeroxColors.divider,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon,
                    size: 22,
                    color: isSelected
                        ? XeroxColors.primaryRed
                        : XeroxColors.grayText),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? XeroxColors.primaryRed
                                : XeroxColors.darkText)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: XeroxColors.grayText)),
                  ],
                ),
              ),
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      isSelected ? XeroxColors.primaryRed : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? XeroxColors.primaryRed
                        : XeroxColors.hintText,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
            ],
          ),
          if (expandedContent != null) expandedContent!,
        ],
      ),
    );
  }
}

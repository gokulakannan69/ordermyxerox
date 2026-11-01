import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../xerox_widgets.dart';
import '../../../widgets/glass_card.dart';

class OrderSummaryStep extends StatelessWidget {
  final double total;
  final String? fileName;
  final String? fileSize;
  final int pageCount;
  final String sheetSize;
  final String paperGsm;
  final String colorMode;
  final int copies;
  final String printSides;
  final String binding;
  final String lamination;
  final String deliveryMethod;

  const OrderSummaryStep({
    super.key,
    required this.total,
    this.fileName,
    this.fileSize,
    this.pageCount = 1,
    this.sheetSize = 'A4',
    this.paperGsm = '75 GSM',
    this.colorMode = 'Black & White',
    this.copies = 1,
    this.printSides = 'Single Sided',
    this.binding = 'None',
    this.lamination = 'None',
    this.deliveryMethod = 'home',
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title ──
          Text('Review your order',
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: XeroxColors.darkText)),
          const SizedBox(height: 6),
          Text(
            'Please double-check your print settings and delivery details before proceeding to payment.',
            style: GoogleFonts.poppins(
                fontSize: 13, color: XeroxColors.grayText, height: 1.5),
          ),
          const SizedBox(height: 20),

          // ── File details card in Apple Glass style ──
          GlassCard(
            padding: const EdgeInsets.all(16),
            borderRadius: 18,
            opacity: 0.94,
            tintColor: Colors.white,
            customBorder:
                Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: XeroxColors.lightRedBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.picture_as_pdf,
                      color: XeroxColors.primaryRed, size: 26),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fileName != null && fileName!.isNotEmpty
                            ? fileName!
                            : 'Uploaded Document',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: XeroxColors.darkText),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${fileSize != null && fileSize!.isNotEmpty ? fileSize! : 'Ready for print'}${pageCount > 0 ? ' • $pageCount Page${pageCount > 1 ? 's' : ''}' : ''}',
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: XeroxColors.grayText),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Print Configuration card in Apple Glass style ──
          GlassCard(
            padding: const EdgeInsets.all(16),
            borderRadius: 18,
            opacity: 0.94,
            tintColor: Colors.white,
            customBorder:
                Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Print Configuration',
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: XeroxColors.darkText)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: XeroxColors.lightRedBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('Custom Print',
                          style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: XeroxColors.primaryRed)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (pageCount > 0) ...[
                  _configRow('Document Pages',
                      '$pageCount Page${pageCount > 1 ? 's' : ''}'),
                  const SizedBox(height: 8),
                ],
                _configRow('Format & Paper', '$sheetSize • $paperGsm'),
                const SizedBox(height: 8),
                _configRow('Color & Copies', '$colorMode • $copies Set(s)'),
                const SizedBox(height: 8),
                _configRow('Sides', printSides),
                const SizedBox(height: 8),
                _configRow('Binding', binding),
                const SizedBox(height: 8),
                _configRow('Lamination', lamination),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Xerox Shop + Fulfillment cards ──
          Row(
            children: [
              Expanded(
                child: GlassCard(
                  padding: const EdgeInsets.all(14),
                  borderRadius: 16,
                  opacity: 0.94,
                  tintColor: Colors.white,
                  customBorder:
                      Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: XeroxColors.primaryRed,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text('XEROX SHOP',
                              style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: XeroxColors.primaryRed,
                                  letterSpacing: 0.5)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('SK Xerox & Digital',
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: XeroxColors.darkText)),
                      const SizedBox(height: 2),
                      Text('Main Street, City\nCenter',
                          style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: XeroxColors.grayText,
                              height: 1.4)),
                      const SizedBox(height: 6),
                      Text('₹${total.toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: XeroxColors.darkText)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GlassCard(
                  padding: const EdgeInsets.all(14),
                  borderRadius: 16,
                  opacity: 0.94,
                  tintColor: Colors.white,
                  customBorder:
                      Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: XeroxColors.primaryRed,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text('FULFILLMENT',
                              style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: XeroxColors.primaryRed,
                                  letterSpacing: 0.5)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                          deliveryMethod == 'home'
                              ? 'Home Delivery (+₹50)'
                              : 'Self Store Pickup (Free)',
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: XeroxColors.darkText)),
                      const SizedBox(height: 2),
                      Text(
                          deliveryMethod == 'home'
                              ? 'Estimated 30 mins'
                              : 'Ready in 15 mins',
                          style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: XeroxColors.grayText,
                              height: 1.4)),
                      const SizedBox(height: 6),
                      const SizedBox(height: 16), // align height
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _configRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style:
                GoogleFonts.poppins(fontSize: 13, color: XeroxColors.grayText)),
        Text(value,
            style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: XeroxColors.darkText)),
      ],
    );
  }
}

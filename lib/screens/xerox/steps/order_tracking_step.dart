import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../config/theme.dart';
import '../../../widgets/glass_card.dart';

class OrderTrackingStep extends StatefulWidget {
  final double total;
  final String? fileName;
  final String? sheetSize;
  final String? paperGsm;
  final String? colorMode;
  final int copies;
  final String shopName;
  final String deliveryMethod;

  const OrderTrackingStep({
    super.key,
    required this.total,
    this.fileName,
    this.sheetSize = 'A4',
    this.paperGsm = '75 GSM',
    this.colorMode = 'Black & White',
    this.copies = 1,
    this.shopName = 'SK Xerox & Digital',
    this.deliveryMethod = 'home',
  });

  @override
  State<OrderTrackingStep> createState() => _OrderTrackingStepState();
}

class _OrderTrackingStepState extends State<OrderTrackingStep>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Order Placed Animated Banner ──
          ScaleTransition(
            scale: _scaleAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: GlassCard(
                borderRadius: 24,
                blur: 16,
                backgroundColor: const Color(0xFFE11D48),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.35),
                  width: 1.5,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.4),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Order Confirmed',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Your request has been sent to ${widget.shopName}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.95),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // ── Order ID & Live Tracking ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tracking Status',
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFE11D48).withValues(alpha: 0.2),
                  ),
                ),
                child: Text('#XRX0834215',
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFE11D48))),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Timeline steps ──
          const _TimelineItem(
            title: 'Order Received',
            subtitle: 'Shop has acknowledged your document.',
            status: _TimelineStatus.completed,
            isLast: false,
          ),
          const _TimelineItem(
            title: 'Printing in Progress',
            subtitle: 'Estimated time: 10 mins',
            status: _TimelineStatus.inProgress,
            isLast: false,
          ),
          const _TimelineItem(
            title: 'Out for Delivery',
            subtitle: 'Awaiting completion of print job.',
            status: _TimelineStatus.pending,
            isLast: true,
          ),

          const SizedBox(height: 32),

          // ── Print Summary card ──
          Text('Order Summary',
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          GlassCard(
            borderRadius: 20,
            blur: 16,
            padding: const EdgeInsets.all(20),
            backgroundColor: Colors.white.withValues(alpha: 0.85),
            border: Border.all(
              color: const Color(0xFFE11D48).withValues(alpha: 0.12),
              width: 1.2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1F2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.description_outlined,
                        color: Color(0xFFE11D48),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.fileName != null &&
                                    widget.fileName!.isNotEmpty
                                ? widget.fileName!
                                : 'Document ready for print',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text('Paid Successfully',
                                style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF15803D))),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(height: 1),
                const SizedBox(height: 20),
                _summaryRow(
                    'Format', '${widget.sheetSize} • ${widget.colorMode}'),
                const SizedBox(height: 10),
                _summaryRow('Quantity', '${widget.copies} Set(s)'),
                const SizedBox(height: 10),
                _summaryRow(
                    'Fulfillment',
                    widget.deliveryMethod == 'home'
                        ? 'Home Delivery'
                        : 'Store Pickup'),
                const SizedBox(height: 20),
                const Divider(height: 1),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Amount',
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary)),
                    Text('₹${widget.total.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFE11D48))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24), const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 13, color: AppColors.textSecondary)),
        Text(value,
            style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
      ],
    );
  }
}

// ── Timeline status ──
enum _TimelineStatus { completed, inProgress, pending }

// ── Timeline item widget ──
class _TimelineItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final _TimelineStatus status;
  final bool isLast;

  const _TimelineItem({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Vertical line + dot ──
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _dotColor,
                    border: Border.all(color: _dotBorderColor, width: 2),
                  ),
                  child: Center(child: _dotIcon),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: status == _TimelineStatus.completed
                          ? AppColors.primary
                          : Colors.grey.shade300,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // ── Content ──
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: status == _TimelineStatus.pending
                              ? AppColors.textHint
                              : AppColors.textPrimary)),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: status == _TimelineStatus.inProgress
                                ? AppColors.primary
                                : AppColors.textSecondary)),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color get _dotColor {
    switch (status) {
      case _TimelineStatus.completed:
        return AppColors.primary;
      case _TimelineStatus.inProgress:
        return Colors.white;
      case _TimelineStatus.pending:
        return Colors.transparent;
    }
  }

  Color get _dotBorderColor {
    switch (status) {
      case _TimelineStatus.completed:
        return AppColors.primary;
      case _TimelineStatus.inProgress:
        return AppColors.primary;
      case _TimelineStatus.pending:
        return Colors.grey.shade300;
    }
  }

  Widget? get _dotIcon {
    switch (status) {
      case _TimelineStatus.completed:
        return const Icon(Icons.check, size: 14, color: Colors.white);
      case _TimelineStatus.inProgress:
        return const Padding(
          padding: EdgeInsets.all(4.0),
          child: CircularProgressIndicator(
              strokeWidth: 2.5, color: AppColors.primary),
        );
      case _TimelineStatus.pending:
        return null;
    }
  }
}

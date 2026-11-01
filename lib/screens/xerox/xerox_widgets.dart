import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/brand_text.dart';

/// Premium color palette matching modern design standards
class XeroxColors {
  static const Color primaryRed = Color(0xFFE11D48); // Modern Rose/Crimson
  static const Color primaryDark = Color(0xFFBE123C);
  static const Color primaryLight = Color(0xFFFFF1F2);
  static const Color lightRedBg = Color(0xFFFFECEF);
  static const Color darkText = Color(0xFF0F172A); // Slate 900
  static const Color bodyText = Color(0xFF334155); // Slate 700
  static const Color grayText = Color(0xFF64748B); // Slate 500
  static const Color hintText = Color(0xFF94A3B8); // Slate 400
  static const Color background = Color(0xFFF8FAFC); // Slate 50
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E8F0); // Slate 200
  static const Color borderSubtle = Color(0xFFF1F5F9);
  static const Color divider = Color(0xFFF1F5F9);
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFECFDF5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFFFBEB);
  static const Color info = Color(0xFF0284C7);
  static const Color infoLight = Color(0xFFF0F9FF);
}

/// Reusable App Logo Widget
class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? textColor;

  const AppLogo({
    super.key,
    this.size = 32,
    this.showText = false,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final imageWidget = Image.asset(
      'assets/images/app_logo.png',
      width: size * 0.72,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.print_rounded,
          size: size * 0.8,
          color: XeroxColors.primaryRed,
        );
      },
    );

    if (!showText) {
      return imageWidget;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        imageWidget,
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Order my xerox',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
                color: textColor ?? XeroxColors.darkText,
              ),
            ),
            Text(
              'Smart Instant Printing',
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: XeroxColors.grayText,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Xerox app header — "Order my xerox" with bell icon and step badge
class XeroxAppHeader extends StatelessWidget {
  final String? stepText;
  final String? sectionName;
  final VoidCallback? onBack;
  final VoidCallback? onMenuTap;

  const XeroxAppHeader({
    super.key,
    this.stepText,
    this.sectionName,
    this.onBack,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [XeroxColors.primaryRed, Color(0xFF9F1239)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (onBack != null) ...[
                InkWell(
                  onTap: onBack,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        size: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              // App Title
              const Expanded(
                child: Center(
                  child: BrandText(fontSize: 18, onDark: true, compact: true),
                ),
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('No new notifications'),
                        duration: Duration(seconds: 2)),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.notifications_none_rounded,
                      size: 20, color: Colors.white),
                ),
              ),
            ],
          ),
          if (stepText != null || sectionName != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                if (stepText != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      stepText!,
                      style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70),
                    ),
                  ),
                if (stepText != null && sectionName != null)
                  const SizedBox(width: 8),
                if (sectionName != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      sectionName!,
                      style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// 5-dot step progress indicator (used on Upload screen)
class StepProgressDots extends StatelessWidget {
  final int currentStep;
  final List<String> labels;
  final List<IconData> icons;

  const StepProgressDots({
    super.key,
    required this.currentStep,
    required this.labels,
    required this.icons,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: List.generate(labels.length * 2 - 1, (index) {
          if (index.isOdd) {
            final lineIdx = index ~/ 2;
            return Expanded(
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  color: lineIdx < currentStep
                      ? XeroxColors.primaryRed
                      : XeroxColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }
          final i = index ~/ 2;
          final isActive = i == currentStep;
          final isCompleted = i < currentStep;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isActive || isCompleted)
                      ? XeroxColors.primaryRed
                      : XeroxColors.cardWhite,
                  border: Border.all(
                    color: (isActive || isCompleted)
                        ? XeroxColors.primaryRed
                        : XeroxColors.border,
                    width: isActive ? 2.5 : 1.5,
                  ),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color:
                                XeroxColors.primaryRed.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check_rounded,
                          size: 18, color: Colors.white)
                      : Icon(icons[i],
                          size: 16,
                          color:
                              isActive ? Colors.white : XeroxColors.hintText),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                labels[i],
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color:
                      isActive ? XeroxColors.primaryRed : XeroxColors.grayText,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

/// Bottom action bar — ← Back | Total ₹xx.xx | [Next Step →]
class BottomActionBar extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onNext;
  final double total;
  final String nextLabel;
  final bool hasDocument;

  const BottomActionBar({
    super.key,
    this.onBack,
    this.onNext,
    required this.total,
    this.nextLabel = 'Next Step →',
    this.hasDocument = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: XeroxColors.borderSubtle)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (onBack != null)
              OutlinedButton.icon(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_rounded, size: 16),
                label: Text('Back',
                    style: GoogleFonts.poppins(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: XeroxColors.bodyText,
                  side: const BorderSide(color: XeroxColors.border),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              )
            else
              const SizedBox.shrink(),
            const Spacer(),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  hasDocument ? 'Total Payable' : 'Document Required',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: hasDocument
                        ? XeroxColors.grayText
                        : XeroxColors.warning,
                  ),
                ),
                Text(
                  hasDocument ? '₹${total.toStringAsFixed(2)}' : '₹0.00',
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: hasDocument && total > 0
                        ? XeroxColors.primaryRed
                        : XeroxColors.hintText,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),
            ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    hasDocument ? XeroxColors.primaryRed : XeroxColors.border,
                foregroundColor:
                    hasDocument ? Colors.white : XeroxColors.hintText,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                nextLabel,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Section label
class SectionLabel extends StatelessWidget {
  final String title;
  const SectionLabel({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title,
          style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: XeroxColors.darkText)),
    );
  }
}

/// Small badge pill
class BadgePill extends StatelessWidget {
  final String text;
  final Color bgColor;
  final Color textColor;
  final IconData? icon;

  const BadgePill({
    super.key,
    required this.text,
    required this.bgColor,
    required this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: textColor),
            const SizedBox(width: 3),
          ],
          Text(text,
              style: GoogleFonts.poppins(
                  fontSize: 10, fontWeight: FontWeight.w600, color: textColor)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../xerox_widgets.dart';

class PlaceTypeStep extends StatelessWidget {
  final String? selectedType;
  final ValueChanged<String> onTypeSelected;

  const PlaceTypeStep({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title ──
          Text('What type of place?',
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: XeroxColors.darkText)),
          const SizedBox(height: 6),
          Text(
            'Choose where you\'d like to get your documents printed or picked up.',
            style: GoogleFonts.poppins(
                fontSize: 13, color: XeroxColors.grayText, height: 1.5),
          ),
          const SizedBox(height: 24),

          // ── Xerox Shop option ──
          _PlaceTypeCard(
            icon: Icons.store_rounded,
            title: 'Xerox Shop',
            subtitle: 'Local print shops & digital copy centers',
            isSelected: selectedType == 'xerox_shop',
            onTap: () => onTypeSelected('xerox_shop'),
          ),
          const SizedBox(height: 14),

          // ── College / Campus option ──
          _PlaceTypeCard(
            icon: Icons.school_rounded,
            title: 'College / Campus',
            subtitle: 'University stationery & campus printers',
            isSelected: selectedType == 'college',
            onTap: () => onTypeSelected('college'),
          ),
          const SizedBox(height: 24),

          // ── Info note ──
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFBAE6FD)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline,
                    size: 18, color: Color(0xFF0284C7)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Selecting your place type helps us curate the best nearby vendors with the equipment and paper stocks you need.',
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFF0369A1),
                        height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Place type selection card ──
class _PlaceTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlaceTypeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? XeroxColors.lightRedBg : XeroxColors.cardWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? XeroxColors.primaryRed : XeroxColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                  color: XeroxColors.primaryRed.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? XeroxColors.primaryRed.withValues(alpha: 0.1)
                    : XeroxColors.divider,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon,
                  size: 28,
                  color: isSelected
                      ? XeroxColors.primaryRed
                      : XeroxColors.grayText),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.poppins(
                          fontSize: 15,
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
                color: isSelected ? XeroxColors.primaryRed : Colors.transparent,
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
      ),
    );
  }
}

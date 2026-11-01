import 'dart:ui';
import 'package:flutter/material.dart';

/// ─── Glassmorphism Container Widget ─────────────────────────────────────────
/// Reusable frosted glass component with blur, soft translucent gradient, and
/// subtle glowing specular border.
/// ─── Apple iOS Style Glass Container Widget with Interactive Spring Animation ───
class GlassCard extends StatefulWidget {
  final double? width;
  final double? height;
  final Widget child;
  final double blur;
  final double opacity;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? tintColor;
  final Color? backgroundColor;
  final Border? customBorder;
  final BoxBorder? border;
  final VoidCallback? onTap;
  final bool enablePressAnimation;

  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.blur = 18.0,
    this.opacity = 0.85,
    this.borderRadius = 20.0,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.tintColor,
    this.backgroundColor,
    this.customBorder,
    this.border,
    this.onTap,
    this.enablePressAnimation = true,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
      reverseDuration: const Duration(milliseconds: 180),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onTap != null && widget.enablePressAnimation) {
      _animController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onTap != null && widget.enablePressAnimation) {
      _animController.reverse();
    }
  }

  void _onTapCancel() {
    if (widget.onTap != null && widget.enablePressAnimation) {
      _animController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveTint =
        widget.backgroundColor ?? widget.tintColor ?? Colors.white;
    final effectiveBorder = widget.border ?? widget.customBorder;

    Widget card = ScaleTransition(
      scale: widget.enablePressAnimation
          ? _scaleAnimation
          : const AlwaysStoppedAnimation(1.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: widget.blur, sigmaY: widget.blur),
          child: Container(
            width: widget.width,
            height: widget.height,
            padding: widget.padding,
            decoration: BoxDecoration(
              color: effectiveTint.withValues(alpha: widget.opacity),
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: effectiveBorder ??
                  Border.all(
                    color: Colors.white.withValues(alpha: 0.65),
                    width: 1.2,
                  ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE11D48).withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: widget.child,
          ),
        ),
      ),
    );

    if (widget.margin != null) {
      card = Padding(padding: widget.margin!, child: card);
    }

    if (widget.onTap != null) {
      card = GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: card,
      );
    }

    return card;
  }
}

/// ─── Apple Red Frosted Glass Card ──────────────────────────────────────────
class AppleRedGlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const AppleRedGlassCard({
    super.key,
    required this.child,
    this.borderRadius = 20.0,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      blur: 20.0,
      opacity: 0.88,
      borderRadius: borderRadius,
      padding: padding,
      margin: margin,
      tintColor:
          const Color(0xFFFFF1F2), // Premium Apple translucent rose-white
      customBorder: Border.all(
        color: const Color(0xFFE11D48).withValues(alpha: 0.22),
        width: 1.2,
      ),
      onTap: onTap,
      child: child,
    );
  }
}

/// ─── Dark Glassmorphism Container Widget ──────────────────────────────────
class DarkGlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? tintColor;
  final VoidCallback? onTap;

  const DarkGlassCard({
    super.key,
    required this.child,
    this.blur = 20.0,
    this.opacity = 0.70,
    this.borderRadius = 18.0,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.tintColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTint = tintColor ?? const Color(0xFF0F172A);

    Widget card = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: effectiveTint.withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.12),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );

    if (margin != null) {
      card = Padding(padding: margin!, child: card);
    }

    if (onTap != null) {
      card = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: card,
      );
    }

    return card;
  }
}

/// ─── Glassmorphism Bottom Navigation Bar ────────────────────────────────────
class GlassBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;

  const GlassBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.82),
              border: Border(
                top: BorderSide(
                  color: Colors.white.withValues(alpha: 0.4),
                  width: 1.0,
                ),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: onTap,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: const Color(0xFFE11D48),
              unselectedItemColor: const Color(0xFF94A3B8),
              selectedFontSize: 11,
              unselectedFontSize: 11,
              items: items,
            ),
          ),
        ),
      ),
    );
  }
}

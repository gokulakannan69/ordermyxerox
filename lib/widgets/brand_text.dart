import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── BRAND LOGO TEXT ────────────────────────────────────────────────────────
/// Displays the official "Order my xerox" logo text.
///
/// Features:
/// • "Order" is rendered in solid dark or light text.
/// • "my" is highlighted inside a rounded red badge.
/// • "xerox" is rendered in bold weighted text.
///
/// Parameters:
/// • [fontSize] : Base font size (default: 22).
/// • [onDark]   : Set to true when placed on dark backgrounds (turns text white).
/// • [compact]  : Set to true for a smaller size suitable for app bars & headers.
class BrandText extends StatelessWidget {
  final double fontSize;
  final bool onDark;
  final bool compact;

  const BrandText({
    super.key,
    this.fontSize = 22,
    this.onDark = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = onDark ? Colors.white : const Color(0xFF0F172A);
    final size = compact ? fontSize * 0.85 : fontSize;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Order',
          style: GoogleFonts.poppins(
            fontSize: size,
            fontWeight: FontWeight.w600,
            color: baseColor,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(width: 2),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: size * 0.3,
            vertical: size * 0.08,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFE11D48),
            borderRadius: BorderRadius.circular(size * 0.22),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE11D48).withValues(alpha: 0.3),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            'my',
            style: GoogleFonts.poppins(
              fontSize: size * 0.8,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.2,
              letterSpacing: -0.3,
            ),
          ),
        ),
        const SizedBox(width: 3),
        Text(
          'xerox',
          style: GoogleFonts.poppins(
            fontSize: size,
            fontWeight: FontWeight.w800,
            color: baseColor,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}

// ── ANIMATED BRAND LOGO TEXT ───────────────────────────────────────────────
/// Smooth animated version of [BrandText] for Splash and Auth screens.
///
/// Features:
/// • "Order" slides in smoothly from the left.
/// • "my" pops in with an elastic spring animation and glowing aura.
/// • "xerox" slides in from the right to finish the logo reveal.
///
/// Parameters:
/// • [fontSize] : Base font size (default: 28).
/// • [onDark]   : Set to true for white text on dark backgrounds.
/// • [delay]    : Wait time before starting the entrance animation.
class AnimatedBrandText extends StatefulWidget {
  final double fontSize;
  final bool onDark;
  final Duration delay;

  const AnimatedBrandText({
    super.key,
    this.fontSize = 28,
    this.onDark = false,
    this.delay = Duration.zero,
  });

  @override
  State<AnimatedBrandText> createState() => _AnimatedBrandTextState();
}

class _AnimatedBrandTextState extends State<AnimatedBrandText>
    with TickerProviderStateMixin {
  late AnimationController _orderCtrl;
  late AnimationController _myCtrl;
  late AnimationController _xeroxCtrl;
  late AnimationController _glowCtrl;

  late Animation<double> _orderSlide;
  late Animation<double> _orderFade;
  late Animation<double> _myScale;
  late Animation<double> _myFade;
  late Animation<double> _xeroxSlide;
  late Animation<double> _xeroxFade;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();

    _orderCtrl = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _myCtrl = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _xeroxCtrl = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _glowCtrl = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _orderSlide = Tween<double>(begin: -30, end: 0).animate(
      CurvedAnimation(parent: _orderCtrl, curve: Curves.easeOutCubic),
    );
    _orderFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _orderCtrl, curve: Curves.easeIn),
    );

    _myScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _myCtrl, curve: Curves.elasticOut),
    );
    _myFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _myCtrl, curve: Curves.easeIn),
    );

    _xeroxSlide = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _xeroxCtrl, curve: Curves.easeOutCubic),
    );
    _xeroxFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _xeroxCtrl, curve: Curves.easeIn),
    );

    _glowAnim = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut),
    );

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    await Future.delayed(widget.delay);
    if (!mounted) return;
    _orderCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    _myCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 150));
    if (!mounted) return;
    _xeroxCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    _glowCtrl.repeat(reverse: true);
  }

  @override
  void dispose() {
    _orderCtrl.dispose();
    _myCtrl.dispose();
    _xeroxCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.onDark ? Colors.white : const Color(0xFF0F172A);
    final size = widget.fontSize;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // "Order" — slides in from left
        AnimatedBuilder(
          animation: _orderCtrl,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_orderSlide.value, 0),
              child: Opacity(
                opacity: _orderFade.value,
                child: Text(
                  'Order',
                  style: GoogleFonts.poppins(
                    fontSize: size,
                    fontWeight: FontWeight.w600,
                    color: baseColor,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 3),

        // "my" — pops in with elastic + glow
        AnimatedBuilder(
          animation: Listenable.merge([_myCtrl, _glowCtrl]),
          builder: (context, child) {
            return Transform.scale(
              scale: _myScale.value,
              child: Opacity(
                opacity: _myFade.value,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: size * 0.3,
                    vertical: size * 0.08,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE11D48),
                    borderRadius: BorderRadius.circular(size * 0.22),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE11D48).withValues(
                          alpha: _glowCtrl.isAnimating ? _glowAnim.value : 0.3,
                        ),
                        blurRadius: _glowCtrl.isAnimating ? 12 : 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    'my',
                    style: GoogleFonts.poppins(
                      fontSize: size * 0.78,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.2,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 4),

        // "xerox" — slides in from right
        AnimatedBuilder(
          animation: _xeroxCtrl,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_xeroxSlide.value, 0),
              child: Opacity(
                opacity: _xeroxFade.value,
                child: Text(
                  'xerox',
                  style: GoogleFonts.poppins(
                    fontSize: size,
                    fontWeight: FontWeight.w800,
                    color: baseColor,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

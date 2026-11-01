import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded,
                color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context)),
        title: Text('Track Order',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Map Mockup Header
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: NetworkImage(
                      'https://maps.googleapis.com/maps/api/staticmap?center=13.0827,80.2707&zoom=14&size=600x300&maptype=roadmap&path=color:0x0000ff|weight:5|13.0827,80.2707|13.0900,80.2800&key=dummy'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                      painter: MapGridPainter(),
                      size: const Size(double.infinity, 180)),
                  const Positioned(
                    left: 60,
                    top: 60,
                    child: Icon(Icons.store_rounded,
                        color: Colors.orange, size: 32),
                  ),
                  const Positioned(
                    right: 80,
                    bottom: 40,
                    child: Icon(Icons.location_on_rounded,
                        color: Colors.red, size: 36),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(8)),
                      child: Text('1.2 km away',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: AppColors.primary)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order #ORD-8891',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text('Campus Xerox Center',
                          style: GoogleFonts.poppins(
                              color: AppColors.textSecondary, fontSize: 13)),
                    ],
                  ),
                  Text('₹ 145.00',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    style: BorderStyle.solid,
                    width: 2),
              ),
              child: Column(
                children: [
                  Text('Pickup / Delivery PIN',
                      style: GoogleFonts.poppins(
                          color: AppColors.textSecondary, fontSize: 13)),
                  const SizedBox(height: 8),
                  Text('8 4 9 2',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 42,
                          letterSpacing: 8,
                          color: AppColors.primary)),
                  const SizedBox(height: 4),
                  Text('Show this to the shop owner or delivery rider',
                      style: GoogleFonts.poppins(
                          color: AppColors.textHint, fontSize: 11)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Delivery Rider Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200)),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundImage:
                        NetworkImage('https://i.pravatar.cc/150?img=11'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ramesh Kumar',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        Text('Delivery Rider • TN 07 AX 1234',
                            style: GoogleFonts.poppins(
                                color: AppColors.textSecondary, fontSize: 11)),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: Colors.amber, size: 14),
                            Text(' 4.8',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold, fontSize: 11)),
                          ],
                        )
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.call_rounded, color: Colors.green),
                    style: IconButton.styleFrom(
                        backgroundColor: Colors.green.withValues(alpha: 0.1)),
                  )
                ],
              ),
            ),

            const SizedBox(height: 32),
            Text('Tracking Status',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 24),
            _buildTimelineStep('Order Placed', '10:30 AM', true, true),
            _buildTimelineStep('Printing in Progress', '10:45 AM', true, true),
            _buildTimelineStep(
                'Ready for Pickup / Delivery', 'Waiting...', false, false),
            _buildTimelineStep('Completed', '', false, true, isLast: true),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineStep(
      String title, String time, bool isCompleted, bool isActive,
      {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted
                    ? Colors.green
                    : (isActive ? AppColors.primary : Colors.grey.shade300),
                shape: BoxShape.circle,
              ),
              child: Icon(isCompleted ? Icons.check : Icons.circle,
                  color: Colors.white, size: 14),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted ? Colors.green : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isActive
                          ? AppColors.textPrimary
                          : AppColors.textHint)),
              if (time.isNotEmpty)
                Text(time,
                    style: GoogleFonts.poppins(
                        color: AppColors.textSecondary, fontSize: 12)),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}

class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..strokeWidth = 1.0;

    for (var i = 0.0; i < size.width; i += 20) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (var i = 0.0; i < size.height; i += 20) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }

    // Draw a fake route line
    final routePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(60 + 16, 60 + 16)
      ..quadraticBezierTo(size.width / 2, size.height / 2 - 20,
          size.width - 80 - 18, size.height - 40 - 18);

    canvas.drawPath(path, routePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

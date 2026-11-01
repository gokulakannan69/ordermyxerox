import 'package:flutter/material.dart';
import '../../config/routes.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We already built an immersive Xerox Order Flow, so the standalone upload screen
    // is redundant. We will redirect the user to the main Xerox flow immediately.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, AppRoutes.xeroxOrder);
    });

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

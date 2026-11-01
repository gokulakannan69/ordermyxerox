import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/glass_card.dart';
import 'xerox_widgets.dart';
import 'steps/upload_step.dart';
import 'steps/location_step.dart';
import 'steps/place_type_step.dart';
import 'steps/shop_selection_step.dart';
import 'steps/delivery_step.dart';
import 'steps/order_summary_step.dart';
import 'steps/payment_step.dart';
import 'steps/order_tracking_step.dart';

import 'xerox_pricing.dart';

/// Main container for the entire Xerox order flow.
/// Manages step navigation, state, and the shared bottom nav + action bar.

class XeroxOrderFlow extends StatefulWidget {
  const XeroxOrderFlow({super.key});

  @override
  State<XeroxOrderFlow> createState() => _XeroxOrderFlowState();
}

class _XeroxOrderFlowState extends State<XeroxOrderFlow> {
  final GlobalKey<ScaffoldState> _orderScaffoldKey = GlobalKey<ScaffoldState>();
  int _currentStep = 0;

  // ── Step state ──
  String? _uploadedFileName;
  String? _uploadedFileSize;
  int _documentPages = 0; // Starts at 0: No document uploaded
  String _sheetSize = 'A4';
  String _paperGsm = '75 GSM (Normal)';
  String _colorMode = 'Black & White';
  String _printSides = 'Single Sided';
  String _printRatio = '100% (Fit to Page)';
  String _orientation = 'Portrait';
  String _binding = 'None';
  String _lamination = 'None';
  String _specialInstructions = '';
  int _copies = 1;
  bool _locationConfirmed = false;
  String? _placeType;
  int _selectedShopIndex = 0; // Default to first top-rated partner
  String _deliveryMethod = 'home';
  String _paymentMethod = 'upi';
  String _userAddress = 'New Fairlands, 5th Cross Road';
  String _city = 'Salem';
  String _postalCode = '636016';
  double _total = 0.00; // Total is ₹0.00 until user adds a document

  static const List<String> _shopNames = [
    'SK Xerox & Digital',
    'Campus Print Hub',
    'Quick Copy Center',
  ];

  @override
  void initState() {
    super.initState();
    _recalculateTotal();
  }

  void _recalculateTotal() {
    final newTotal = XeroxPricing.calculateTotal(
      sheetSize: _sheetSize,
      paperGsm: _paperGsm,
      colorMode: _colorMode,
      printSides: _printSides,
      printRatio: _printRatio,
      binding: _binding,
      lamination: _lamination,
      copies: _copies,
      deliveryMethod: _deliveryMethod,
      pageCount: _uploadedFileName != null && _uploadedFileName!.isNotEmpty
          ? (_documentPages > 0 ? _documentPages : 1)
          : 0,
    );
    setState(() {
      _total = newTotal;
    });
  }

  // Step labels for the header (Unified 8-step flow)
  static const _stepHeaders = [
    {'step': 'Step 1 of 8', 'name': 'Upload Document'},
    {'step': 'Step 2 of 8', 'name': 'Location Access'},
    {'step': 'Step 3 of 8', 'name': 'Select Place Type'},
    {'step': 'Step 4 of 8', 'name': 'Choose Shop'},
    {'step': 'Step 5 of 8', 'name': 'Delivery Option'},
    {'step': 'Step 6 of 8', 'name': 'Order Review'},
    {'step': 'Step 7 of 8', 'name': 'Secure Payment'},
    {'step': 'Step 8 of 8', 'name': 'Order Tracking'},
  ];

  void _nextStep() {
    // If on Step 1 (Upload Document) and no document is uploaded, prompt user to add document first!
    if (_currentStep == 0 &&
        (_uploadedFileName == null || _uploadedFileName!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Please select or upload a document first to proceed!',
                  style: GoogleFonts.poppins(
                      fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          backgroundColor: XeroxColors.primaryRed,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    if (_currentStep < 7) {
      setState(() => _currentStep++);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTrackingStep = _currentStep == 7;
    final hasDoc = _uploadedFileName != null && _uploadedFileName!.isNotEmpty;

    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          if (_currentStep > 0) {
            _prevStep();
          } else {
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
        child: Scaffold(
          key: _orderScaffoldKey,
          backgroundColor: XeroxColors.background,
          body: SafeArea(
            child: Column(
              children: [
                // ── Header ──
                if (isTrackingStep)
                  _buildTrackingHeader()
                else
                  XeroxAppHeader(
                    stepText: _stepHeaders[_currentStep]['step'],
                    sectionName: _stepHeaders[_currentStep]['name'],
                    onBack: _currentStep > 0
                        ? _prevStep
                        : () =>
                            Navigator.pushReplacementNamed(context, '/home'),
                  ),

                // ── Step content ──
                Expanded(child: _buildCurrentStep()),

                // ── Bottom action bar (Xerox order actions) ──
                BottomActionBar(
                  total: _total,
                  hasDocument: _currentStep > 0 || hasDoc,
                  onBack: _currentStep > 0 ? _prevStep : null,
                  onNext: _currentStep == 7 ? null : _nextStep,
                  nextLabel: _currentStep == 0 && !hasDoc
                      ? 'Add Document First'
                      : _currentStep == 6
                          ? 'Pay ₹${_total.toStringAsFixed(2)} →'
                          : _currentStep == 7
                              ? 'Done'
                              : 'Next Step →',
                ),
              ],
            ),
          ),
          bottomNavigationBar: GlassBottomNavBar(
            currentIndex: 1, // Xerox is selected
            onTap: (index) {
              if (index == 1) return;
              if (index == 0) {
                Navigator.pushReplacementNamed(context, '/home');
              } else if (index == 2) {
                Navigator.pushReplacementNamed(context, '/categories');
              } else if (index == 3) {
                Navigator.pushReplacementNamed(context, '/orders');
              } else if (index == 4) {
                Navigator.pushReplacementNamed(context, '/profile');
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.print_rounded),
                label: 'Xerox',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.grid_view_rounded),
                label: 'Categories',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_rounded),
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: 'Account',
              ),
            ],
          ),
        ));
  }

  // ── Tracking screen header ──
  Widget _buildTrackingHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [XeroxColors.primaryRed, Color(0xFF9F1239)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _prevStep,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_ios_new,
                  size: 16, color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Order Tracking',
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
              Text('Live Status',
                  style:
                      GoogleFonts.poppins(fontSize: 10, color: Colors.white70)),
            ],
          ),
          const Spacer(),
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
              child: const Icon(Icons.notifications_outlined,
                  size: 20, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ── Step content builder ──
  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return UploadStep(
          sheetSize: _sheetSize,
          copies: _copies,
          uploadedFileName: _uploadedFileName,
          uploadedFileSize: _uploadedFileSize,
          pageCount: _documentPages,
          paperGsm: _paperGsm,
          colorMode: _colorMode,
          printSides: _printSides,
          printRatio: _printRatio,
          orientation: _orientation,
          binding: _binding,
          lamination: _lamination,
          specialInstructions: _specialInstructions,
          onPageCountChanged: (pages) {
            _documentPages = pages;
            _recalculateTotal();
          },
          onFileSelected: (name, size) {
            setState(() {
              _uploadedFileName = name.isEmpty ? null : name;
              _uploadedFileSize = size.isEmpty ? null : size;
            });
            _recalculateTotal();
          },
          onSheetSizeChanged: (v) {
            _sheetSize = v;
            _recalculateTotal();
          },
          onCopiesChanged: (v) {
            _copies = v;
            _recalculateTotal();
          },
          onPaperGsmChanged: (v) {
            _paperGsm = v;
            _recalculateTotal();
          },
          onColorModeChanged: (v) {
            _colorMode = v;
            _recalculateTotal();
          },
          onPrintSidesChanged: (v) {
            _printSides = v;
            _recalculateTotal();
          },
          onPrintRatioChanged: (v) {
            _printRatio = v;
            _recalculateTotal();
          },
          onOrientationChanged: (v) => setState(() => _orientation = v),
          onBindingChanged: (v) {
            _binding = v;
            _recalculateTotal();
          },
          onLaminationChanged: (v) {
            _lamination = v;
            _recalculateTotal();
          },
          onSpecialInstructionsChanged: (v) =>
              setState(() => _specialInstructions = v),
        );
      case 1:
        return LocationStep(
          locationConfirmed: _locationConfirmed,
          onLocationConfirmed: (v) => setState(() => _locationConfirmed = v),
          selectedAddress: '$_userAddress, $_city - $_postalCode',
          onAddressChanged: (fullAddr) {
            setState(() {
              if (fullAddr.contains(',')) {
                final parts = fullAddr.split(',');
                _userAddress = parts[0].trim();
                if (parts.length > 1) {
                  final remaining = parts[1].trim();
                  if (remaining.contains('-')) {
                    final cityPin = remaining.split('-');
                    _city = cityPin[0].trim();
                    _postalCode = cityPin[1].trim();
                  } else {
                    _city = remaining;
                  }
                }
              } else {
                _userAddress = fullAddr;
              }
            });
          },
        );
      case 2:
        return PlaceTypeStep(
          selectedType: _placeType,
          onTypeSelected: (v) => setState(() => _placeType = v),
        );
      case 3:
        return ShopSelectionStep(
          selectedShopIndex: _selectedShopIndex,
          onShopSelected: (v) => setState(() => _selectedShopIndex = v),
        );
      case 4:
        return DeliveryStep(
          deliveryMethod: _deliveryMethod,
          streetAddress: _userAddress,
          city: _city,
          postalCode: _postalCode,
          onMethodChanged: (v) {
            _deliveryMethod = v;
            _recalculateTotal();
          },
        );
      case 5:
        return OrderSummaryStep(
          total: _total,
          fileName: _uploadedFileName,
          fileSize: _uploadedFileSize,
          pageCount: _documentPages,
          sheetSize: _sheetSize,
          paperGsm: _paperGsm,
          colorMode: _colorMode,
          copies: _copies,
          printSides: _printSides,
          binding: _binding,
          lamination: _lamination,
          deliveryMethod: _deliveryMethod,
        );
      case 6:
        return PaymentStep(
          total: _total,
          paymentMethod: _paymentMethod,
          onMethodChanged: (v) => setState(() => _paymentMethod = v),
        );
      case 7:
        final currentShop =
            (_selectedShopIndex >= 0 && _selectedShopIndex < _shopNames.length)
                ? _shopNames[_selectedShopIndex]
                : 'SK Xerox & Digital';
        return OrderTrackingStep(
          total: _total,
          fileName: _uploadedFileName,
          sheetSize: _sheetSize,
          paperGsm: _paperGsm,
          colorMode: _colorMode,
          copies: _copies,
          shopName: currentShop,
          deliveryMethod: _deliveryMethod,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

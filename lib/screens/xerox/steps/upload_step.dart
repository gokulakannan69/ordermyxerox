import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../xerox_widgets.dart';
import '../xerox_pricing.dart';
import '../../../widgets/glass_card.dart';

class UploadStep extends StatefulWidget {
  final String sheetSize;
  final int copies;
  final ValueChanged<String> onSheetSizeChanged;
  final ValueChanged<int> onCopiesChanged;
  final String? uploadedFileName;
  final String? uploadedFileSize;
  final int pageCount;
  final ValueChanged<int>? onPageCountChanged;
  final Function(String fileName, String fileSize)? onFileSelected;

  // Additional configuration callbacks & state
  final String paperGsm;
  final ValueChanged<String>? onPaperGsmChanged;
  final String colorMode;
  final ValueChanged<String>? onColorModeChanged;
  final String printSides;
  final ValueChanged<String>? onPrintSidesChanged;
  final String printRatio;
  final ValueChanged<String>? onPrintRatioChanged;
  final String orientation;
  final ValueChanged<String>? onOrientationChanged;
  final String binding;
  final ValueChanged<String>? onBindingChanged;
  final String lamination;
  final ValueChanged<String>? onLaminationChanged;
  final String specialInstructions;
  final ValueChanged<String>? onSpecialInstructionsChanged;

  const UploadStep({
    super.key,
    required this.sheetSize,
    required this.copies,
    required this.onSheetSizeChanged,
    required this.onCopiesChanged,
    this.uploadedFileName,
    this.uploadedFileSize,
    this.pageCount = 0,
    this.onPageCountChanged,
    this.onFileSelected,
    this.paperGsm = '75 GSM (Normal)',
    this.onPaperGsmChanged,
    this.colorMode = 'Black & White',
    this.onColorModeChanged,
    this.printSides = 'Single Sided',
    this.onPrintSidesChanged,
    this.printRatio = '100% (Fit to Page)',
    this.onPrintRatioChanged,
    this.orientation = 'Portrait',
    this.onOrientationChanged,
    this.binding = 'None',
    this.onBindingChanged,
    this.lamination = 'None',
    this.onLaminationChanged,
    this.specialInstructions = '',
    this.onSpecialInstructionsChanged,
  });

  @override
  State<UploadStep> createState() => _UploadStepState();
}

class _UploadStepState extends State<UploadStep> {
  String? _fileName;
  String? _fileSize;
  bool _isUploading = false;

  // Local state for options
  late String _sheetSize;
  late String _paperGsm;
  late String _colorMode;
  late String _printSides;
  late String _printRatio;
  late String _orientation;
  late String _binding;
  late String _lamination;
  late TextEditingController _instructionsController;

  // Dropdown option datasets with transparent pricing indicators
  static const List<Map<String, String>> _sheetSizeOptions = [
    {
      'value': 'A4',
      'title': 'A4 (210 × 297 mm)',
      'desc':
          'Standard office, project reports & everyday prints • From ₹1.50/page'
    },
    {
      'value': 'A3',
      'title': 'A3 (297 × 420 mm)',
      'desc':
          'Ledger, engineering drawings & architectural plans • From ₹3.50/page'
    },
    {
      'value': 'A5',
      'title': 'A5 (148 × 210 mm)',
      'desc': 'Pocket notes, flyers & mini booklets • From ₹1.00/page'
    },
    {
      'value': 'Legal',
      'title': 'Legal (216 × 356 mm)',
      'desc': 'Court documents, stamp papers & legal deeds • From ₹2.00/page'
    },
    {
      'value': 'Letter',
      'title': 'Letter (216 × 279 mm)',
      'desc': 'US standard document format • From ₹1.50/page'
    },
    {
      'value': 'Bond Paper',
      'title': 'Executive Bond (A4)',
      'desc': 'Premium corporate resumes & certificates • From ₹5.00/page'
    },
    {
      'value': 'Photo Paper',
      'title': 'Photo Glossy (4 × 6 / A4)',
      'desc': 'High-definition color photo printing • From ₹15.00/page'
    },
    {
      'value': 'Sticker Sheet',
      'title': 'Sticker / Matte Label',
      'desc': 'Self-adhesive labels & product cutouts • From ₹10.00/page'
    },
  ];

  static const List<Map<String, String>> _paperGsmOptions = [
    {
      'value': '70 GSM (Economy)',
      'title': '70 GSM (Economy Paper)',
      'desc': 'Lightweight, bulk study Xerox (+₹0.00)'
    },
    {
      'value': '75 GSM (Normal)',
      'title': '75 GSM (Executive Standard)',
      'desc': 'Standard everyday photocopy (+₹0.25)'
    },
    {
      'value': '80 GSM (High Quality)',
      'title': '80 GSM (JK Copier Premium)',
      'desc': 'Zero show-through, double sided best (+₹0.75)'
    },
    {
      'value': '100 GSM (Color Project)',
      'title': '100 GSM (Bright White)',
      'desc': 'Smooth finish for color presentations (+₹2.00)'
    },
    {
      'value': '120 GSM (Presentation)',
      'title': '120 GSM (Heavyweight)',
      'desc': 'Corporate pitch & thesis reports (+₹3.50)'
    },
    {
      'value': '250 GSM (Cardstock)',
      'title': '250 GSM (Thick Card / Ivory)',
      'desc': 'Certificates, book covers & badges (+₹6.00)'
    },
    {
      'value': '300 GSM (Art Card)',
      'title': '300 GSM (Premium Gloss / Matte)',
      'desc': 'Visiting cards, covers & posters (+₹9.00)'
    },
  ];

  static const List<Map<String, String>> _colorModeOptions = [
    {
      'value': 'Black & White',
      'title': 'Black & White (B&W)',
      'desc': 'Cost-effective high-contrast laser print • Best value'
    },
    {
      'value': 'Color Standard',
      'title': 'Standard Full Color',
      'desc': 'Vibrant graphs, charts & diagrams • From ₹5.00/page'
    },
    {
      'value': 'Color HD Laser',
      'title': 'Ultra HD Photo Color',
      'desc': 'High-precision photographic reproduction • From ₹12.00/page'
    },
  ];

  static const List<Map<String, String>> _printSidesOptions = [
    {
      'value': 'Single Sided',
      'title': 'Single Sided (Front Only)',
      'desc': 'One page per physical paper sheet'
    },
    {
      'value': 'Double Sided (Duplex)',
      'title': 'Double Sided (Back-to-Back)',
      'desc': 'Saves paper, ideal for books & notes'
    },
  ];

  static const List<Map<String, String>> _printRatioOptions = [
    {
      'value': '100% (Fit to Page)',
      'title': '100% - Fit to Printable Area',
      'desc': 'Auto margins, prevent clipped text'
    },
    {
      'value': 'Actual Size (100%)',
      'title': 'Actual 1:1 Scale',
      'desc': 'True CAD / blueprint dimensions'
    },
    {
      'value': '2 Pages per Sheet',
      'title': '2 Pages per Sheet (2-up)',
      'desc': 'Condenses study handouts'
    },
    {
      'value': '4 Pages per Sheet',
      'title': '4 Pages per Sheet (4-up)',
      'desc': 'Summary cheatsheets & slides'
    },
  ];

  static const List<Map<String, String>> _orientationOptions = [
    {
      'value': 'Auto-Detect',
      'title': 'Auto-Detect Orientation',
      'desc': 'Matches each page in the document'
    },
    {
      'value': 'Portrait',
      'title': 'Portrait (Vertical)',
      'desc': 'Standard upright pages'
    },
    {
      'value': 'Landscape',
      'title': 'Landscape (Horizontal)',
      'desc': 'Wide tables, spreadsheets & slides'
    },
  ];

  static const List<Map<String, String>> _bindingOptions = [
    {
      'value': 'None',
      'title': 'No Binding (Loose Sheets)',
      'desc': 'Standard staple or envelope'
    },
    {
      'value': 'Corner Staple',
      'title': 'Corner Stapled (Top Left)',
      'desc': 'Single metallic staple (Free)'
    },
    {
      'value': 'Spiral Binding',
      'title': 'Plastic Spiral Binding (+₹25)',
      'desc': 'Flexible coil with clear cover'
    },
    {
      'value': 'Wire-O Binding',
      'title': 'Twin Wire-O Metal Binding (+₹40)',
      'desc': 'Professional 360-degree flip'
    },
    {
      'value': 'Hardbound Book',
      'title': 'Hardbound Gold Emboss (+₹150)',
      'desc': 'University thesis & legal records'
    },
    {
      'value': 'Soft Touch Strip',
      'title': 'Tape / Strip Thermal (+₹20)',
      'desc': 'Clean book-spine adhesive binding'
    },
  ];

  static const List<Map<String, String>> _laminationOptions = [
    {
      'value': 'None',
      'title': 'No Lamination',
      'desc': 'Standard raw paper surface'
    },
    {
      'value': 'Matte Lamination',
      'title': 'Soft Matte Finish (+₹15/sheet)',
      'desc': 'Anti-glare, scratch resistant'
    },
    {
      'value': 'Gloss Lamination',
      'title': 'Gloss Shiny Finish (+₹15/sheet)',
      'desc': 'Waterproof, vivid color pop'
    },
    {
      'value': 'Pouch Thermal (A4)',
      'title': 'Hard Thermal Pouch 125 mic (+₹25)',
      'desc': 'Stiff ID & certificate encapsulation'
    },
  ];

  @override
  void initState() {
    super.initState();
    // Start with null or user provided file (NO dummy auto-selection by default!)
    _fileName = widget.uploadedFileName;
    _fileSize = widget.uploadedFileSize;

    _sheetSize = widget.sheetSize;
    _paperGsm = widget.paperGsm;
    _colorMode = widget.colorMode;
    _printSides = widget.printSides;
    _printRatio = widget.printRatio;
    _orientation = widget.orientation;
    _binding = widget.binding;
    _lamination = widget.lamination;
    _instructionsController =
        TextEditingController(text: widget.specialInstructions);
  }

  @override
  void dispose() {
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _pickDocument() async {
    try {
      setState(() => _isUploading = true);
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        withData: true,
        allowedExtensions: [
          'pdf',
          'doc',
          'docx',
          'ppt',
          'pptx',
          'jpg',
          'jpeg',
          'png',
          'txt',
          'xlsx'
        ],
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final name = file.name;
        final bytes = file.size;
        final sizeFormatted = bytes > 1024 * 1024
            ? '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB'
            : '${(bytes / 1024).toStringAsFixed(1)} KB';

        int detectedPages = 1;
        // Automatically fetch PDF page count in real-time
        if (name.toLowerCase().endsWith('.pdf')) {
          try {
            if (file.bytes != null) {
              final document = PdfDocument(inputBytes: file.bytes!);
              detectedPages = document.pages.count;
              document.dispose();
            } else if (file.path != null) {
              final fileBytes = File(file.path!).readAsBytesSync();
              final document = PdfDocument(inputBytes: fileBytes);
              detectedPages = document.pages.count;
              document.dispose();
            }
          } catch (pdfErr) {
            // Fallback estimation based on file size if parsing has an issue
            detectedPages = (bytes / (80 * 1024)).ceil().clamp(1, 200);
          }
        } else {
          // Non-PDF (images, single doc) default to 1
          detectedPages = 1;
        }

        setState(() {
          _fileName = name;
          _fileSize = sizeFormatted;
        });

        if (widget.onFileSelected != null) {
          widget.onFileSelected!(name, sizeFormatted);
        }
        widget.onPageCountChanged?.call(detectedPages);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_rounded,
                      color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Document "$name" ($detectedPages page${detectedPages > 1 ? 's' : ''}) loaded!',
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                  ),
                ],
              ),
              backgroundColor: XeroxColors.success,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not pick file: $e',
                style: GoogleFonts.poppins(fontSize: 12)),
            backgroundColor: XeroxColors.primaryRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  void _removeDocument() {
    setState(() {
      _fileName = null;
      _fileSize = null;
    });
    if (widget.onFileSelected != null) {
      widget.onFileSelected!('', '');
    }
    widget.onPageCountChanged?.call(0);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 5-Dot Progress indicator ──
          const StepProgressDots(
            currentStep: 0,
            labels: ['Upload', 'Location', 'Shop', 'Delivery', 'Pay'],
            icons: [
              Icons.cloud_upload_outlined,
              Icons.location_on_outlined,
              Icons.store_outlined,
              Icons.local_shipping_outlined,
              Icons.payment_outlined,
            ],
          ),
          const SizedBox(height: 16),

          // ── Title & Intro ──
          Text(
            'Upload & Configure Print',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
              color: XeroxColors.darkText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Select any document or photo and customize paper size, thickness, colors, and finishing.',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: XeroxColors.grayText,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),

          // ── Section 1: Upload Card or Uploaded File Tile ──
          if (_fileName == null || _fileName!.isEmpty)
            _buildUploadDropzone()
          else
            _buildUploadedFileTile(),

          const SizedBox(height: 20),

          // ── Section 2: Paper & Sheet Specifications ──
          _buildSectionHeader(
            icon: Icons.layers_outlined,
            title: '1. Paper & Sheet Specifications',
            subtitle: 'Choose physical paper dimension and sheet thickness',
          ),
          const SizedBox(height: 12),

          // Sheet Size Dropdown
          _buildDropdownField(
            label: 'Sheet Dimension (Size)',
            currentValue: _sheetSize,
            options: _sheetSizeOptions,
            icon: Icons.aspect_ratio_rounded,
            onChanged: (val) {
              if (val != null) {
                setState(() => _sheetSize = val);
                widget.onSheetSizeChanged(val);
              }
            },
          ),
          const SizedBox(height: 12),

          // Paper GSM / Thickness Dropdown
          _buildDropdownField(
            label: 'Paper Thickness & Model (GSM)',
            currentValue: _paperGsm,
            options: _paperGsmOptions,
            icon: Icons.line_weight_rounded,
            onChanged: (val) {
              if (val != null) {
                setState(() => _paperGsm = val);
                widget.onPaperGsmChanged?.call(val);
              }
            },
          ),
          const SizedBox(height: 20),

          // ── Section 3: Color, Sides & Orientation ──
          _buildSectionHeader(
            icon: Icons.tune_rounded,
            title: '2. Print Color & Layout',
            subtitle: 'Ink tones, single/double sided, and page orientation',
          ),
          const SizedBox(height: 12),

          // Color Mode Dropdown
          _buildDropdownField(
            label: 'Print Color Mode',
            currentValue: _colorMode,
            options: _colorModeOptions,
            icon: Icons.palette_outlined,
            onChanged: (val) {
              if (val != null) {
                setState(() => _colorMode = val);
                widget.onColorModeChanged?.call(val);
              }
            },
          ),
          const SizedBox(height: 12),

          // Print Sides (Duplex) Dropdown
          _buildDropdownField(
            label: 'Sides (Duplex Mode)',
            currentValue: _printSides,
            options: _printSidesOptions,
            icon: Icons.auto_stories_outlined,
            onChanged: (val) {
              if (val != null) {
                setState(() => _printSides = val);
                widget.onPrintSidesChanged?.call(val);
              }
            },
          ),
          const SizedBox(height: 12),

          // Print Ratio & Scaling
          _buildDropdownField(
            label: 'Print Ratio & Scaling',
            currentValue: _printRatio,
            options: _printRatioOptions,
            icon: Icons.fit_screen_outlined,
            onChanged: (val) {
              if (val != null) {
                setState(() => _printRatio = val);
                widget.onPrintRatioChanged?.call(val);
              }
            },
          ),
          const SizedBox(height: 12),

          // Orientation Dropdown
          _buildDropdownField(
            label: 'Orientation',
            currentValue: _orientation,
            options: _orientationOptions,
            icon: Icons.screen_rotation_outlined,
            onChanged: (val) {
              if (val != null) {
                setState(() => _orientation = val);
                widget.onOrientationChanged?.call(val);
              }
            },
          ),
          const SizedBox(height: 20),

          // ── Section 4: Quantity / Copies ──
          _buildSectionHeader(
            icon: Icons.copy_all_rounded,
            title: '3. Quantity & Copies',
            subtitle: 'Number of printed sets required',
          ),
          const SizedBox(height: 12),
          _buildCopiesCounterCard(),

          const SizedBox(height: 20),

          // ── Section 5: Finishing (Binding & Lamination) ──
          _buildSectionHeader(
            icon: Icons.book_outlined,
            title: '4. Finishing & Protection',
            subtitle: 'Professional binding styles & protective laminates',
          ),
          const SizedBox(height: 12),

          // Binding dropdown
          _buildDropdownField(
            label: 'Binding Style',
            currentValue: _binding,
            options: _bindingOptions,
            icon: Icons.collections_bookmark_outlined,
            onChanged: (val) {
              if (val != null) {
                setState(() => _binding = val);
                widget.onBindingChanged?.call(val);
              }
            },
          ),
          const SizedBox(height: 12),

          // Lamination dropdown
          _buildDropdownField(
            label: 'Surface Lamination',
            currentValue: _lamination,
            options: _laminationOptions,
            icon: Icons.shield_outlined,
            onChanged: (val) {
              if (val != null) {
                setState(() => _lamination = val);
                widget.onLaminationChanged?.call(val);
              }
            },
          ),
          const SizedBox(height: 20),

          // ── Section 6: Special Instructions ──
          _buildSectionHeader(
            icon: Icons.note_alt_outlined,
            title: '5. Special Instructions (Optional)',
            subtitle:
                'Page range, stapling notes, or custom vendor instructions',
          ),
          const SizedBox(height: 12),
          _buildSpecialInstructionsCard(),

          const SizedBox(height: 20),

          // ── Real-time Price Estimate Card ──
          _buildLivePriceCard(),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ── Live Price Estimation Card ──
  Widget _buildLivePriceCard() {
    final hasDoc =
        _fileName != null && _fileName!.isNotEmpty && widget.pageCount > 0;
    final perSheet = XeroxPricing.calculatePerSheetPrice(
      sheetSize: _sheetSize,
      paperGsm: _paperGsm,
      colorMode: _colorMode,
      printSides: _printSides,
      printRatio: _printRatio,
    );
    final bindingCost = XeroxPricing.getBindingCost(_binding);
    final laminationCost = XeroxPricing.getLaminationCost(_lamination);
    final singleSetTotal = hasDoc
        ? (perSheet * widget.pageCount) + bindingCost + laminationCost
        : 0.0;
    final allSetsTotal =
        singleSetTotal * (widget.copies < 1 ? 1 : widget.copies);

    return GlassCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 18,
      opacity: 0.92,
      tintColor: hasDoc ? const Color(0xFFFFF1F2) : const Color(0xFFFFFBEB),
      customBorder: Border.all(
        color: hasDoc
            ? XeroxColors.primaryRed.withValues(alpha: 0.25)
            : const Color(0xFFFDE68A),
        width: 1.2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color:
                      hasDoc ? XeroxColors.primaryRed : const Color(0xFFD97706),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  hasDoc ? Icons.calculate_rounded : Icons.info_outline_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasDoc
                          ? 'Live Price Calculation'
                          : 'Add Document to Calculate Total',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: hasDoc
                            ? XeroxColors.primaryRed
                            : const Color(0xFFB45309),
                      ),
                    ),
                    Text(
                      hasDoc
                          ? 'Calculated for ${widget.pageCount} page(s) × ${widget.copies} set(s)'
                          : 'Upload your PDF/doc above to auto-fetch pages and total payable',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: XeroxColors.grayText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: XeroxColors.border, height: 1),
          ),
          _priceBreakdownRow(
            'Rate per Sheet',
            '₹${perSheet.toStringAsFixed(2)} / page',
            isSub: false,
          ),
          if (hasDoc) ...[
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: _priceBreakdownRow(
                'Document Length',
                '${widget.pageCount} Pages',
                isSub: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: _priceBreakdownRow(
                'Pages Subtotal',
                '₹${(perSheet * widget.pageCount).toStringAsFixed(2)}',
                isSub: true,
              ),
            ),
          ],
          if (bindingCost > 0)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: _priceBreakdownRow(
                'Binding ($_binding)',
                '+₹${bindingCost.toStringAsFixed(2)}',
                isSub: true,
              ),
            ),
          if (laminationCost > 0)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: _priceBreakdownRow(
                'Lamination ($_lamination)',
                '+₹${laminationCost.toStringAsFixed(2)}',
                isSub: true,
              ),
            ),
          if (widget.copies > 1)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: _priceBreakdownRow(
                'Quantity Multiplier',
                '× ${widget.copies} Sets',
                isSub: true,
              ),
            ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: XeroxColors.border, height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Print Subtotal',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: XeroxColors.darkText,
                    ),
                  ),
                  Text(
                    hasDoc
                        ? '+ Delivery calculated at Step 5'
                        : 'First add document above to proceed',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: hasDoc
                          ? XeroxColors.grayText
                          : const Color(0xFFB45309),
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: hasDoc
                          ? XeroxColors.primaryRed.withValues(alpha: 0.3)
                          : const Color(0xFFFDE68A)),
                ),
                child: Text(
                  '₹${allSetsTotal.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color:
                        hasDoc ? XeroxColors.primaryRed : XeroxColors.hintText,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceBreakdownRow(String label, String value, {bool isSub = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: isSub ? 11 : 12,
            fontWeight: isSub ? FontWeight.w400 : FontWeight.w500,
            color: isSub ? XeroxColors.grayText : XeroxColors.darkText,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: isSub ? 11 : 12,
            fontWeight: FontWeight.w600,
            color: isSub ? XeroxColors.grayText : XeroxColors.darkText,
          ),
        ),
      ],
    );
  }

  // ── Upload Dropzone ──
  Widget _buildUploadDropzone() {
    return GlassCard(
      onTap: _isUploading ? null : _pickDocument,
      borderRadius: 20,
      opacity: 0.94,
      tintColor: Colors.white,
      customBorder: Border.all(
        color: XeroxColors.primaryRed.withValues(alpha: 0.35),
        width: 1.5,
      ),
      padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: XeroxColors.lightRedBg,
              shape: BoxShape.circle,
            ),
            child: _isUploading
                ? const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: XeroxColors.primaryRed,
                    ),
                  )
                : const Icon(
                    Icons.cloud_upload_rounded,
                    size: 32,
                    color: XeroxColors.primaryRed,
                  ),
          ),
          const SizedBox(height: 12),
          Text(
            _isUploading ? 'Selecting document...' : 'Upload Document to Print',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: XeroxColors.primaryRed,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Supports PDF, DOCX, PPTX, JPG, PNG & Excel files up to 100MB',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: XeroxColors.grayText,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildUploadOptionBtn(
                  Icons.folder_rounded, 'Local Storage', XeroxColors.darkText),
              const SizedBox(width: 8),
              _buildUploadOptionBtn(Icons.add_to_drive_rounded, 'Google Drive',
                  const Color(0xFF16A34A)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildUploadOptionBtn(
                  Icons.chat_rounded, 'WhatsApp', const Color(0xFF25D366)),
              const SizedBox(width: 8),
              _buildUploadOptionBtn(
                  Icons.link_rounded, 'Web Link', const Color(0xFF2563EB)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUploadOptionBtn(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: XeroxColors.divider,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: XeroxColors.darkText,
            ),
          ),
        ],
      ),
    );
  }

  // ── Selected Document Tile (with change/remove) ──
  Widget _buildUploadedFileTile() {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      borderRadius: 18,
      opacity: 0.94,
      tintColor: Colors.white,
      customBorder: Border.all(
          color: XeroxColors.success.withValues(alpha: 0.4), width: 1.2),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: XeroxColors.lightRedBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _fileName!.endsWith('.pdf')
                  ? Icons.picture_as_pdf_rounded
                  : _fileName!.endsWith('.doc') || _fileName!.endsWith('.docx')
                      ? Icons.description_rounded
                      : _fileName!.endsWith('.ppt') ||
                              _fileName!.endsWith('.pptx')
                          ? Icons.slideshow_rounded
                          : _fileName!.endsWith('.jpg') ||
                                  _fileName!.endsWith('.png')
                              ? Icons.image_rounded
                              : Icons.article_rounded,
              color: XeroxColors.primaryRed,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _fileName!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: XeroxColors.darkText,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        _fileSize ?? 'Ready',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: XeroxColors.grayText,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: XeroxColors.border,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: XeroxColors.lightRedBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        widget.pageCount > 0
                            ? '${widget.pageCount} Pages'
                            : '1 Page',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: XeroxColors.primaryRed,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Ready to print',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: XeroxColors.success,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Change file',
            onPressed: _pickDocument,
            icon: const Icon(Icons.sync_rounded,
                color: XeroxColors.primaryRed, size: 22),
          ),
          IconButton(
            tooltip: 'Remove file',
            onPressed: _removeDocument,
            icon: const Icon(Icons.delete_outline_rounded,
                color: XeroxColors.grayText, size: 20),
          ),
        ],
      ),
    );
  }

  // ── Section Header helper ──
  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: XeroxColors.lightRedBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: XeroxColors.primaryRed),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: XeroxColors.darkText,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: XeroxColors.grayText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Rich Dropdown Field with subtitle descriptions ──
  Widget _buildDropdownField({
    required String label,
    required String currentValue,
    required List<Map<String, String>> options,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    final hasValue = options.any((opt) => opt['value'] == currentValue);
    final effectiveValue = hasValue ? currentValue : options.first['value'];

    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      borderRadius: 16,
      opacity: 0.94,
      tintColor: Colors.white,
      customBorder: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          itemHeight: null,
          value: effectiveValue,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: XeroxColors.darkText, size: 22),
          borderRadius: BorderRadius.circular(14),
          onChanged: onChanged,
          selectedItemBuilder: (ctx) {
            return options.map((opt) {
              return Row(
                children: [
                  Icon(icon, size: 18, color: XeroxColors.primaryRed),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: XeroxColors.grayText,
                          ),
                        ),
                        Text(
                          opt['title'] ?? opt['value']!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: XeroxColors.darkText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList();
          },
          items: options.map((opt) {
            final isSelected = opt['value'] == effectiveValue;
            return DropdownMenuItem<String>(
              value: opt['value'],
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          opt['title'] ?? opt['value']!,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w600,
                            color: isSelected
                                ? XeroxColors.primaryRed
                                : XeroxColors.darkText,
                          ),
                        ),
                        if (isSelected) ...[
                          const Spacer(),
                          const Icon(Icons.check_rounded,
                              size: 16, color: XeroxColors.primaryRed),
                        ],
                      ],
                    ),
                    if (opt['desc'] != null)
                      Text(
                        opt['desc']!,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: XeroxColors.grayText,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ── Copies Counter Card ──
  Widget _buildCopiesCounterCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: XeroxColors.cardWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: XeroxColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Number of Sets / Copies',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: XeroxColors.darkText,
                ),
              ),
              Text(
                'Full set duplicated per copy',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: XeroxColors.grayText,
                ),
              ),
            ],
          ),
          Row(
            children: [
              InkWell(
                onTap: widget.copies > 1
                    ? () => widget.onCopiesChanged(widget.copies - 1)
                    : null,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: widget.copies > 1
                        ? XeroxColors.lightRedBg
                        : XeroxColors.divider,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: widget.copies > 1
                          ? XeroxColors.primaryRed.withValues(alpha: 0.3)
                          : XeroxColors.border,
                    ),
                  ),
                  child: Icon(
                    Icons.remove_rounded,
                    size: 18,
                    color: widget.copies > 1
                        ? XeroxColors.primaryRed
                        : XeroxColors.hintText,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '${widget.copies}',
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: XeroxColors.darkText,
                  ),
                ),
              ),
              InkWell(
                onTap: () => widget.onCopiesChanged(widget.copies + 1),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: XeroxColors.primaryRed,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Special Instructions Card ──
  Widget _buildSpecialInstructionsCard() {
    return Container(
      decoration: BoxDecoration(
        color: XeroxColors.cardWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: XeroxColors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: TextField(
        controller: _instructionsController,
        maxLines: 3,
        onChanged: (val) {
          widget.onSpecialInstructionsChanged?.call(val);
        },
        style: GoogleFonts.poppins(
          fontSize: 13,
          color: XeroxColors.darkText,
        ),
        decoration: InputDecoration(
          hintText:
              'E.g. Print pages 1-15 in B&W and page 16 in Color, add front transparent OHP sheet...',
          hintStyle: GoogleFonts.poppins(
            fontSize: 12,
            color: XeroxColors.hintText,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

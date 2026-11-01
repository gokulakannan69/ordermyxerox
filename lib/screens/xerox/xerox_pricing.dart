/// Central pricing engine for OrderMyXerox
class XeroxPricing {
  /// Base price per sheet based on paper size and color mode
  static double getBaseSheetPrice(String sheetSize, String colorMode) {
    final isColor = colorMode == 'Color Standard';
    final isHdColor = colorMode == 'Color HD Laser';

    switch (sheetSize) {
      case 'A4':
        if (isHdColor) return 12.00;
        if (isColor) return 5.00;
        return 1.50; // B&W
      case 'A3':
        if (isHdColor) return 25.00;
        if (isColor) return 12.00;
        return 3.50;
      case 'A5':
        if (isHdColor) return 8.00;
        if (isColor) return 3.50;
        return 1.00;
      case 'Legal':
        if (isHdColor) return 15.00;
        if (isColor) return 6.00;
        return 2.00;
      case 'Letter':
        if (isHdColor) return 12.00;
        if (isColor) return 5.00;
        return 1.50;
      case 'Bond Paper':
        if (isHdColor) return 18.00;
        if (isColor) return 10.00;
        return 5.00;
      case 'Photo Paper':
        if (isHdColor) return 25.00;
        if (isColor) return 18.00;
        return 15.00;
      case 'Sticker Sheet':
        if (isHdColor) return 22.00;
        if (isColor) return 15.00;
        return 10.00;
      default:
        if (isHdColor) return 12.00;
        if (isColor) return 5.00;
        return 1.50;
    }
  }

  /// GSM paper quality surcharge per sheet
  static double getGsmSurcharge(String paperGsm) {
    if (paperGsm.contains('70 GSM')) return 0.00;
    if (paperGsm.contains('75 GSM')) return 0.25;
    if (paperGsm.contains('80 GSM')) return 0.75;
    if (paperGsm.contains('100 GSM')) return 2.00;
    if (paperGsm.contains('120 GSM')) return 3.50;
    if (paperGsm.contains('250 GSM')) return 6.00;
    if (paperGsm.contains('300 GSM')) return 9.00;
    return 0.00;
  }

  /// Duplex side multiplier (Double sided gives slight discount vs 2 separate prints)
  static double getSidesMultiplier(String printSides) {
    if (printSides.contains('Double Sided')) {
      return 1.80; // 1.8x rather than 2.0x for duplex
    }
    return 1.00;
  }

  /// Print ratio / scaling multiplier (e.g. 2-up / 4-up condenses pages)
  static double getRatioMultiplier(String printRatio) {
    if (printRatio.contains('2 Pages')) return 0.85;
    if (printRatio.contains('4 Pages')) return 0.65;
    return 1.00;
  }

  /// Single sheet price before binding and copies
  static double calculatePerSheetPrice({
    required String sheetSize,
    required String paperGsm,
    required String colorMode,
    required String printSides,
    required String printRatio,
  }) {
    final base = getBaseSheetPrice(sheetSize, colorMode);
    final gsm = getGsmSurcharge(paperGsm);
    final sidesMult = getSidesMultiplier(printSides);
    final ratioMult = getRatioMultiplier(printRatio);

    final perSheet = (base + gsm) * sidesMult * ratioMult;
    return double.parse(perSheet.toStringAsFixed(2));
  }

  /// Binding cost (one-time per set)
  static double getBindingCost(String binding) {
    if (binding.contains('Corner Staple')) return 0.00;
    if (binding.contains('Spiral')) return 25.00;
    if (binding.contains('Wire-O')) return 40.00;
    if (binding.contains('Hardbound')) return 150.00;
    if (binding.contains('Soft Touch') || binding.contains('Tape')) {
      return 20.00;
    }
    return 0.00;
  }

  /// Lamination cost (per set)
  static double getLaminationCost(String lamination) {
    if (lamination.contains('Matte')) return 15.00;
    if (lamination.contains('Gloss')) return 15.00;
    if (lamination.contains('Pouch Thermal')) return 25.00;
    return 0.00;
  }

  /// Delivery cost
  static double getDeliveryCost(String deliveryMethod) {
    return deliveryMethod == 'home' ? 50.00 : 0.00;
  }

  /// Full total calculation
  static double calculateTotal({
    required String sheetSize,
    required String paperGsm,
    required String colorMode,
    required String printSides,
    required String printRatio,
    required String binding,
    required String lamination,
    required int copies,
    required String deliveryMethod,
    int pageCount = 0,
  }) {
    if (pageCount <= 0) {
      return 0.00;
    }

    final perSheet = calculatePerSheetPrice(
      sheetSize: sheetSize,
      paperGsm: paperGsm,
      colorMode: colorMode,
      printSides: printSides,
      printRatio: printRatio,
    );

    final bindingCost = getBindingCost(binding);
    final laminationCost = getLaminationCost(lamination);

    // Cost for one complete printed & finished copy
    final singleSetCost = (perSheet * pageCount) + bindingCost + laminationCost;

    // Multiplied by number of copies
    final printSubtotal = singleSetCost * (copies < 1 ? 1 : copies);

    // Add delivery fee
    final deliveryCost = getDeliveryCost(deliveryMethod);

    final total = printSubtotal + deliveryCost;
    return double.parse(total.toStringAsFixed(2));
  }
}

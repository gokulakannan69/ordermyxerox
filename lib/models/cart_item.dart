class CartItemModel {
  final String id;
  final String serviceName;
  final String? fileName;
  final int copies;
  final String paperSize; // A4, A3, Legal, Letter
  final bool isColor;
  final bool doubleSided;
  final double pricePerPage;
  final int pageCount;

  CartItemModel({
    required this.id,
    required this.serviceName,
    this.fileName,
    this.copies = 1,
    this.paperSize = 'A4',
    this.isColor = false,
    this.doubleSided = false,
    required this.pricePerPage,
    this.pageCount = 1,
  });

  double get totalPrice => pricePerPage * copies * pageCount;

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] ?? '',
      serviceName: json['service_name'] ?? '',
      fileName: json['file_name'],
      copies: json['copies'] ?? 1,
      paperSize: json['paper_size'] ?? 'A4',
      isColor: json['is_color'] ?? false,
      doubleSided: json['double_sided'] ?? false,
      pricePerPage: (json['price_per_page'] ?? 0).toDouble(),
      pageCount: json['page_count'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'service_name': serviceName,
        'file_name': fileName,
        'copies': copies,
        'paper_size': paperSize,
        'is_color': isColor,
        'double_sided': doubleSided,
        'price_per_page': pricePerPage,
        'page_count': pageCount,
      };
}

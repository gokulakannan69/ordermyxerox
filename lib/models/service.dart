class ServiceModel {
  final String id;
  final String name;
  final String description;
  final String icon;
  final double pricePerPage;
  final String category; // 'print', 'bind', 'laminate', 'scan'

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.pricePerPage,
    required this.category,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      pricePerPage: (json['price_per_page'] ?? 0).toDouble(),
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'icon': icon,
        'price_per_page': pricePerPage,
        'category': category,
      };
}

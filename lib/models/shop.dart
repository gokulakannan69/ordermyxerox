class ShopModel {
  final String id;
  final String name;
  final String address;
  final String city;
  final String phone;
  final double rating;
  final String? image;
  final double latitude;
  final double longitude;
  final bool isOpen;
  final List<String> services;

  ShopModel({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.phone,
    this.rating = 0.0,
    this.image,
    required this.latitude,
    required this.longitude,
    this.isOpen = true,
    this.services = const [],
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      phone: json['phone'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      image: json['image'],
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      isOpen: json['is_open'] ?? true,
      services: List<String>.from(json['services'] ?? []),
    );
  }
}

class UserModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String? profileImage;
  final String? address;
  final String? city;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email = '',
    this.profileImage,
    this.address,
    this.city,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profile_image'],
      address: json['address'],
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
        'profile_image': profileImage,
        'address': address,
        'city': city,
      };
}

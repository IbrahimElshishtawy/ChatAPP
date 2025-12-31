class UserModel {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String role;

  UserModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    required this.role,
  });

  factory UserModel.fromMap(String id, Map<String, dynamic> map) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'],
      phone: map['phone'],
      role: map['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'phone': phone, 'role': role};
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? role,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
    );
  }
}

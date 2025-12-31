class UserModel {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String role;
  final String? linkedin;
  final String? facebook;
  final String? instagram;
  final String? whatsapp;
  final String backgroundImage;
  final String? username;
  final String? profilePicture;
  final String? description; // وصف المستخدم
  final bool freeTrial; // حالة الفترة التجريبية
  final bool paymentStatus; // حالة الدفع

  UserModel({
    required this.profilePicture,
    required this.id,
    required this.name,
    this.email,
    this.phone,
    required this.role,
    this.username,
    this.linkedin,
    this.facebook,
    this.instagram,
    this.whatsapp,
    required this.backgroundImage,
    this.description,
    this.freeTrial = true,
    this.paymentStatus = false,
  });

  factory UserModel.fromMap(String id, Map<String, dynamic> map) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'],
      phone: map['phone'],
      role: map['role'] ?? 'user',
      username: map['username'],
      profilePicture: map['profilePicture'] ?? '',
      backgroundImage: map['backgroundImage'] ?? '',
      description: map['description'],
      freeTrial: map['freeTrial'] ?? true,
      paymentStatus: map['paymentStatus'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'username': username,
      'profilePicture': profilePicture,
      'backgroundImage': backgroundImage,
      'description': description,
      'freeTrial': freeTrial,
      'paymentStatus': paymentStatus,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? role,
    String? username,
    String? profilePicture,
    String? linkedin,
    String? facebook,
    String? instagram,
    String? whatsapp,
    String? backgroundImage,
    String? description,
    bool? freeTrial,
    bool? paymentStatus,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      profilePicture: profilePicture ?? this.profilePicture,
      username: username ?? this.username,
      linkedin: linkedin ?? this.linkedin,
      facebook: facebook ?? this.facebook,
      instagram: instagram ?? this.instagram,
      whatsapp: whatsapp ?? this.whatsapp,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      description: description ?? this.description,
      freeTrial: freeTrial ?? this.freeTrial,
      paymentStatus: paymentStatus ?? this.paymentStatus,
    );
  }
}

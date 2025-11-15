/// User model for profile module
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String? phone;
  final String? bio;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.phone,
    this.bio,
  });

  /// Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String?,
      phone: json['phone'] as String?,
      bio: json['bio'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'phone': phone,
      'bio': bio,
    };
  }

  /// Copy with
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    String? phone,
    String? bio,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
    );
  }
}

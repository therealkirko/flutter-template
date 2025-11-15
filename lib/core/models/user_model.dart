/// User model
class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final String? role;
  final Map<String, dynamic>? metadata;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    this.role,
    this.metadata,
  });

  /// Create from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      role: json['role'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'role': role,
      'metadata': metadata,
    };
  }

  /// Copy with
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatar,
    String? role,
    Map<String, dynamic>? metadata,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Get initials from name
  String getInitials() {
    String trimmedName = name.trim();
    if (trimmedName.isEmpty) return '';

    List<String> names =
        trimmedName.split(' ').where((n) => n.isNotEmpty).toList();
    if (names.isEmpty) return '';

    String initials = '';
    for (String n in names) {
      if (n.isNotEmpty) {
        initials += n[0];
        if (initials.length == 2) break;
      }
    }
    return initials.toUpperCase();
  }

  /// Get first name
  String getFirstName() {
    return name.split(' ').first;
  }
}
